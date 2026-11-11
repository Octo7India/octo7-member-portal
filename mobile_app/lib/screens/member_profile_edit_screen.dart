import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class MemberProfileEditScreen extends StatefulWidget {
  const MemberProfileEditScreen({super.key, required this.member});
  final Map<String, dynamic> member;

  @override
  State<MemberProfileEditScreen> createState() => _MemberProfileEditScreenState();
}

class _MemberProfileEditScreenState extends State<MemberProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _fields = {};
  bool _saving = false;

  static const _fieldGroups = <String, List<(String, String)>>{
    'Contact and address': [
      ('phone', 'Mobile number'),
      ('house_name', 'House / building'),
      ('street', 'Street / locality'),
      ('city', 'City'),
      ('district', 'District'),
      ('state', 'State'),
      ('pin_code', 'PIN code'),
      ('country', 'Country'),
    ],
    'Additional details': [
      ('date_of_birth', 'Date of birth (YYYY-MM-DD)'),
      ('gender', 'Gender'),
    ],
    'Nominee details': [
      ('nominee_full_name', 'Nominee full name'),
      ('nominee_relationship', 'Relationship'),
      ('nominee_date_of_birth', 'Nominee date of birth (YYYY-MM-DD)'),
      ('nominee_phone', 'Nominee mobile number'),
      ('nominee_email', 'Nominee email'),
      ('nominee_address', 'Nominee address'),
      ('nominee_id_proof_type', 'Nominee ID proof type'),
    ],
  };

  @override
  void initState() {
    super.initState();
    for (final group in _fieldGroups.values) {
      for (final (key, _) in group) {
        _fields[key] = TextEditingController(
          text: (widget.member[key] ?? '').toString(),
        );
      }
    }
    // Support legacy column names returned by existing member records.
    _fields['house_name']!.text = (widget.member['house_name'] ??
        widget.member['house_number'] ?? widget.member['address_line1'] ?? '').toString();
    _fields['street']!.text = (widget.member['street'] ??
        widget.member['locality'] ?? widget.member['address_line2'] ?? '').toString();
    _fields['pin_code']!.text = (widget.member['pin_code'] ??
        widget.member['pincode'] ?? widget.member['postal_code'] ?? '').toString();
    _fields['nominee_full_name']!.text = (widget.member['nominee_full_name'] ??
        widget.member['nominee_name'] ?? '').toString();
    _fields['nominee_relationship']!.text = (widget.member['nominee_relationship'] ??
        widget.member['nominee_relation'] ?? '').toString();
    _fields['nominee_date_of_birth']!.text = (widget.member['nominee_date_of_birth'] ??
        widget.member['nominee_dob'] ?? '').toString();
    _fields['nominee_phone']!.text = (widget.member['nominee_phone'] ??
        widget.member['nominee_mobile'] ?? '').toString();
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);
    try {
      final profile = <String, String>{
        for (final entry in _fields.entries)
          entry.key: entry.value.text.trim(),
      };
      await AuthService.instance.invokeMemberAction(
        'update_profile',
        {'profile': profile},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile details saved successfully.')),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save profile: $error')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _section(String title, List<(String, String)> fields) {
    return Card(
      color: const Color(0xFF10243A),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(
            color: Color(0xFF6EE7B7), fontSize: 13,
            fontWeight: FontWeight.bold, letterSpacing: 1,
          )),
          const SizedBox(height: 12),
          for (final (key, label) in fields) ...[
            TextFormField(
              controller: _fields[key],
              keyboardType: key.contains('phone')
                  ? TextInputType.phone
                  : key.contains('email')
                      ? TextInputType.emailAddress
                      : TextInputType.text,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              ),
              validator: (value) {
                final text = (value ?? '').trim();
                if (text.isNotEmpty && key.contains('email') &&
                    !RegExp(r'^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$').hasMatch(text)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
          ],
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071321),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B192C),
        title: const Text('Edit Profile'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Update your contact, address and nominee information. Your OCTO7 ID, sponsor and placement details cannot be changed here.',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 16),
            for (final entry in _fieldGroups.entries)
              _section(entry.key, entry.value),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Saving…' : 'Save profile details'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
