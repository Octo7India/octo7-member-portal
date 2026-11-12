import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class MemberRegistrationScreen extends StatefulWidget {
  const MemberRegistrationScreen({super.key, this.initialParentPositionId, this.initialSide});

  final int? initialParentPositionId;
  final String? initialSide;

  @override
  State<MemberRegistrationScreen> createState() => _MemberRegistrationScreenState();
}

class _MemberRegistrationScreenState extends State<MemberRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sponsor = TextEditingController();
  final _parent = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  String _method = 'email';
  String _side = 'left';
  String? _verificationId;
  String _snapshot = '';
  bool _verified = false;
  bool _busy = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _message;
  bool _error = false;
  Map<String, dynamic>? _createdMember;

  @override
  void initState() {
    super.initState();
    _parent.text = widget.initialParentPositionId?.toString() ?? '';
    _side = widget.initialSide == 'right' ? 'right' : 'left';
  }

  String _details() =>
      '${_name.text.trim()}|${_sponsor.text.trim()}|${_email.text.trim().toLowerCase()}|${_phone.text.trim()}|$_method|${_parent.text.trim()}|$_side';

  void _setMessage(String value, [bool error = false]) {
    if (!mounted) return;
    setState(() {
      _message = value;
      _error = error;
    });
  }

  void _resetVerification() {
    _verificationId = null;
    _verified = false;
    _otp.clear();
    _snapshot = '';
  }

  Future<void> _sendOtp() async {
    if (_busy || !_formKey.currentState!.validate()) return;

    setState(() {
      _busy = true;
      _message = 'Sending OTP…';
      _error = false;
    });

    try {
      _resetVerification();
      final result = await AuthService.instance.invokeMemberAction(
        'start_registration_verification',
        {
          'full_name': _name.text.trim(),
          'sponsor_member_id': _sponsor.text.trim(),
          'email': _email.text.trim().isEmpty ? null : _email.text.trim(),
          'phone': _phone.text.trim(),
          'verification_method': _method,
        },
      );

      final id = result['verification_id']?.toString();
      if (id == null || id.isEmpty) {
        throw Exception('Verification session was not returned by the server.');
      }

      if (!mounted) return;
      setState(() {
        _verificationId = id;
        _snapshot = _details();
        _message =
            '${result['message'] ?? 'OTP sent.'} ${result['destination'] ?? ''} Enter the six-digit code.';
      });
    } catch (e) {
      _setMessage(e.toString().replaceFirst('Exception: ', ''), true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_busy) return;
    if (_verificationId == null) {
      _setMessage('Send an OTP first.', true);
      return;
    }
    if (_details() != _snapshot) {
      setState(_resetVerification);
      _setMessage('Your details changed. Send a new OTP.', true);
      return;
    }
    if (!RegExp(r'^\d{6}$').hasMatch(_otp.text.trim())) {
      _setMessage('Enter the six-digit OTP.', true);
      return;
    }

    setState(() {
      _busy = true;
      _message = 'Verifying OTP…';
      _error = false;
    });

    try {
      final action = _method == 'email'
          ? 'verify_registration_email_otp'
          : 'verify_registration_sms_otp';
      final result = await AuthService.instance.invokeMemberAction(
        action,
        {
          'verification_id': _verificationId,
          'code': _otp.text.trim(),
        },
      );
      if (result['verified'] != true) {
        throw Exception('OTP verification was not confirmed.');
      }
      if (!mounted) return;
      setState(() {
        _verified = true;
        _message = result['message']?.toString() ??
            'OTP verified. You can create the member.';
        _error = false;
      });
    } catch (e) {
      _setMessage(e.toString().replaceFirst('Exception: ', ''), true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _createMember() async {
    if (_busy || !_verified || _verificationId == null) return;
    if (_details() != _snapshot) {
      setState(_resetVerification);
      _setMessage('Your details changed. Verify again.', true);
      return;
    }
    if (_password.text.length < 8 || _password.text.length > 72) {
      _setMessage('Password must contain 8 to 72 characters.', true);
      return;
    }
    if (_password.text != _confirm.text) {
      _setMessage('Passwords do not match.', true);
      return;
    }

    final parentId = int.tryParse(_parent.text.trim());
    if (parentId == null || parentId <= 0) {
      _setMessage('Enter a valid Placement Parent ID.', true);
      return;
    }

    setState(() {
      _busy = true;
      _message = 'Creating member…';
      _error = false;
    });

    try {
      final result = await AuthService.instance.invokeMemberAction(
        'register_person',
        {
          'sponsor_member_id': _sponsor.text.trim(),
          'parent_position_id': parentId,
          'placement_side': _side,
          'full_name': _name.text.trim(),
          'email': _email.text.trim().isEmpty ? null : _email.text.trim(),
          'phone': _phone.text.trim(),
          'verification_id': _verificationId,
          'password': _password.text,
        },
      );

      final member = result['member'] is Map
          ? Map<String, dynamic>.from(result['member'])
          : <String, dynamic>{};
      if (!mounted) return;
      setState(() {
        _createdMember = member;
        _message = member['status'] == 'active'
            ? 'Member registered and automatically activated.'
            : 'Member registered successfully. Activation is still required.';
        _error = false;
      });
    } catch (e) {
      _setMessage(e.toString().replaceFirst('Exception: ', ''), true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _sponsor,
      _parent,
      _name,
      _email,
      _phone,
      _otp,
      _password,
      _confirm,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  InputDecoration _dec(String label, {String? hint}) => InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      );

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? type,
    bool required = true,
    String? hint,
    bool obscure = false,
    bool? isObscured,
    VoidCallback? onToggleObscure,
    bool numericOnly = false,
    bool editableAfterVerification = false,
    bool invalidateVerificationOnChange = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isObscured ?? obscure,
        enabled: _createdMember == null &&
            !_busy &&
            (!_verified || editableAfterVerification),
        decoration: _dec(label, hint: hint).copyWith(
          suffixIcon: onToggleObscure == null
              ? null
              : IconButton(
                  tooltip: (isObscured ?? obscure) ? 'Show password' : 'Hide password',
                  onPressed: onToggleObscure,
                  icon: Icon(
                    (isObscured ?? obscure) ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
        ),
        validator: (value) {
          final text = (value ?? '').trim();
          if (required && text.isEmpty) return 'Required';
          if (numericOnly && text.isNotEmpty &&
              !RegExp(r'^\d{1,20}$').hasMatch(text)) {
            return 'Enter numbers only';
          }
          return null;
        },
        onChanged: (_) {
          if (invalidateVerificationOnChange && _verificationId != null) {
            setState(_resetVerification);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final created = _createdMember;
    return Scaffold(
      appBar: AppBar(title: const Text('New Member Registration')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (created != null) ...[
                  const Icon(Icons.check_circle, color: Colors.green, size: 58),
                  const Text(
                    'Registration completed',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'New Member ID: OCTO7 ${created['member_id'] ?? '—'}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Account status: ${(created['status'] ?? 'pending').toString().toUpperCase()}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    created['status'] == 'active'
                        ? 'This Member ID is active. No activation code is required for OCTO7 IDs 1–15.'
                        : 'Membership remains pending until activation.',
                    textAlign: TextAlign.center,
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('RETURN'),
                  ),
                ] else ...[
                  const Text(
                    'Register a new OCTO7 member in an available binary position. Verify the selected email or mobile number before creating the account.',
                  ),
                  const SizedBox(height: 16),
                  _field(
                    _sponsor,
                    'Sponsor Member ID',
                    type: TextInputType.number,
                    numericOnly: true,
                    hint: 'Enter numeric OCTO7 Member ID',
                  ),
                  _field(
                    _parent,
                    'Placement Parent ID',
                    type: TextInputType.number,
                    numericOnly: true,
                    hint: 'Enter the selected parent position ID',
                  ),
                  DropdownButtonFormField<String>(
                    value: _side,
                    decoration: _dec('Selected Position'),
                    items: const [
                      DropdownMenuItem(value: 'left', child: Text('Left')),
                      DropdownMenuItem(value: 'right', child: Text('Right')),
                    ],
                    onChanged: _busy || _verified
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() {
                                _side = value;
                                _resetVerification();
                              });
                            }
                          },
                  ),
                  const SizedBox(height: 12),
                  _field(_name, 'Full Name'),
                  _field(
                    _email,
                    'Email Address',
                    type: TextInputType.emailAddress,
                    required: _method == 'email',
                  ),
                  _field(
                    _phone,
                    'Mobile Number',
                    type: TextInputType.phone,
                  ),
                  DropdownButtonFormField<String>(
                    value: _method,
                    decoration: _dec('Verification Method'),
                    items: const [
                      DropdownMenuItem(
                        value: 'email',
                        child: Text('Email OTP'),
                      ),
                      DropdownMenuItem(
                        value: 'phone',
                        child: Text('SMS OTP'),
                      ),
                    ],
                    onChanged: _busy || _verified
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() {
                                _method = value;
                                _resetVerification();
                              });
                            }
                          },
                  ),
                  const SizedBox(height: 12),
                  if (!_verified) ...[
                    ElevatedButton(
                      onPressed: _busy ? null : _sendOtp,
                      child: Text(_busy ? 'PLEASE WAIT…' : 'SEND OTP'),
                    ),
                    if (_verificationId != null) ...[
                      const SizedBox(height: 12),
                      _field(
                        _otp,
                        'Six-digit OTP',
                        type: TextInputType.number,
                        invalidateVerificationOnChange: false,
                      ),
                      ElevatedButton(
                        onPressed: _busy ? null : _verifyOtp,
                        child: const Text('VERIFY OTP'),
                      ),
                    ],
                  ],
                  if (_verified) ...[
                    const Text(
                      'OTP VERIFIED',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _field(
                      _password,
                      'Create Password',
                      obscure: true,
                      isObscured: !_showPassword,
                      onToggleObscure: () => setState(() => _showPassword = !_showPassword),
                      editableAfterVerification: true,
                      invalidateVerificationOnChange: false,
                    ),
                    _field(
                      _confirm,
                      'Confirm Password',
                      obscure: true,
                      isObscured: !_showConfirmPassword,
                      onToggleObscure: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                      editableAfterVerification: true,
                      invalidateVerificationOnChange: false,
                    ),
                    ElevatedButton(
                      onPressed: _busy ? null : _createMember,
                      child: Text(_busy ? 'CREATING…' : 'CREATE MEMBER'),
                    ),
                  ],
                  if (_message != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Text(
                        _message!,
                        style: TextStyle(
                          color: _error ? Colors.redAccent : Colors.green,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
