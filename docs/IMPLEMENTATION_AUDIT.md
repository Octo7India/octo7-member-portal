# OCTO7 India — Implementation Audit

Audit date: 6 November 2026  
Repository: Octo7India/octo7-member-portal  
Base branch: main  
Working branch: octo7-completion-work

## Current repository state

The default branch currently contains only:
- `index.html` (27,195 bytes): public landing page, Supabase Auth login/recovery, a limited member dashboard, a two-position genealogy preview, and a product listing.
- `README.md`: one-line project description.

There is no backend Edge Function source, SQL migration directory, automated test suite, or deployment workflow in this repository. The frontend calls the Edge Function at `/functions/v1/octo7-api`.

## Confirmed frontend integration mismatches

The current page calls:
- `me` for the member profile/dashboard.
- `my_genealogy` for genealogy.
- `get_products` for products.

The previously prepared OCTO7 API source in the project work package documents actions named `me` / `dashboard`, `genealogy`, and `products`. These names must be reconciled against the actual deployed Supabase function before changing the live frontend. Do not assume the staged API package is deployed.

## Required member portal navigation

The agreed member menu contains:
1. Dashboard
2. Home
3. My Profile
4. My Genealogy
5. New Member Registration
6. Products
7. My Orders
8. My Wallet
9. Bank Details
10. Withdrawals
11. My Coupons
12. Change Password
13. Help Line
14. Report
15. Logout

The current portal implements only Dashboard, Genealogy, Products, and Logout.

## Critical backend-dependent work

The following cannot be made production-functional by frontend-only code:
- Authenticated member profile and profile updates.
- Secure sponsor-authorized registration and manual placement into an available left/right slot.
- Orders and payment verification/webhook reconciliation.
- Wallet ledger and transfers.
- Coupon issuance and redemption.
- Encrypted bank-detail storage and controlled finance access.
- Withdrawal request and finance reconciliation.
- Support/report creation, attachments, replies and history.
- Role-based admin workflows.

Each feature must call a verified deployed API action and enforce authorization server-side. Hiding buttons in the browser is not security.

## Safety and business rules to preserve

- Preserve Founder Member ID 1 and every existing member record.
- Do not reset, truncate, recreate, or overwrite populated Supabase tables.
- Keep manual binary placement; sponsor and placement parent are distinct.
- Only eligible activated members may sponsor/register, subject to server-side checks.
- Coupon face value: ₹999 per activated Member ID; redemption rule: ₹99.90 per eligible purchase, up to 10 uses, one use per purchase.
- Minimum child-to-main transfer: ₹500.
- Minimum withdrawal: ₹500.
- Do not allocate BV or matching earnings until the written distribution policy and tested backend trigger are confirmed.
- Never store bank account numbers in browser storage or expose service-role credentials in frontend code.

## Safe completion sequence

1. Inspect the actual deployed Supabase schema, Edge Function actions, RLS policies and secrets configuration. Supabase is not currently connected to this ChatGPT session, so deployment state remains unverified.
2. Reconcile the GitHub frontend against the actual deployed API contract.
3. Implement the agreed 15-item member navigation and member screens on this working branch.
4. Add or reconcile server-side actions and additive SQL migrations only after inspecting the live schema. Never run reset scripts against the populated project.
5. Add tests for authentication, placement authorization, genealogy, coupon limits, order/payment verification, wallet ledger, bank encryption, withdrawal and support workflows.
6. Review the branch, open a pull request, and merge only after review.
7. Deploy database migrations and Edge Function separately, then publish GitHub Pages and run end-to-end tests with test accounts.

## Current deployment status

No Supabase migration or Edge Function deployment has been performed by this audit. No live member data has been changed. The default `main` branch has not been modified.