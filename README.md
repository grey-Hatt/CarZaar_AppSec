# 🚗 CarZaar — Car Bidding Marketplace

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase&logoColor=white)
![Security Review](https://img.shields.io/badge/Security%20Review-18%20findings-b3261e)
![License](https://img.shields.io/badge/Status-University%20Project-orange)

**CarZaar** ("Where Car Meets Best Prices") is a mobile marketplace where sellers list their cars and
buyers compete with bids. It was built as the final project of my **Mobile Application Development**
course using **Flutter** and **Supabase (PostgreSQL)**, and I later performed a **security review** of
both apps — the full report is included in this repository.

| App | Folder | For | What it does |
|-----|--------|-----|--------------|
| **CarZaar** | [`user_app/`](user_app) | Buyers &amp; sellers | Browse cars, place/edit/withdraw bids, list cars, accept offers, buy "connects", report problems |
| **CarZaar Admin** | [`admin_app/`](admin_app) | Moderators | Dashboard, user management, listing &amp; bid monitoring, complaint handling, analytics |

## 📑 Table of contents
[Screenshots](#-screenshots) · [Features](#-features) · [Tech stack](#-tech-stack) · [Project structure](#-project-structure) · [Getting started](#-getting-started) · [Demo flow](#-quick-demo-flow) · [**Security testing**](#-security-testing) · [Known limitations](#-known-limitations) · [Author](#-author)

---

## 📸 Screenshots

### User app (buyer &amp; seller)
<table>
  <tr>
    <td align="center" width="50%"><img src="docs/user_login.png" alt="CarZaar login screen"><br><sub><b>Login</b></sub></td>
    <td align="center" width="50%"><img src="docs/user_home.png" alt="CarZaar home with Buyer and Seller mode"><br><sub><b>Home – switch between Buyer and Seller mode</b></sub></td>
  </tr>
</table>

### Admin app
<table>
  <tr>
    <td align="center" width="50%"><img src="docs/admin_dashboard.png" alt="Admin dashboard with live counters"><br><sub><b>Dashboard – live counters &amp; modules</b></sub></td>
    <td align="center" width="50%"><img src="docs/admin_car_listing.png" alt="Car listing monitoring with status filters"><br><sub><b>Car listing monitoring – search, filter, block</b></sub></td>
  </tr>
</table>

---

## ✨ Features

**User app**
- Sign up, log in, reset password, edit profile (with photo)
- One account, two modes — switch between **Buyer** and **Seller** from the home screen
- **Buyer:** search &amp; browse active listings, view details, place / edit / withdraw bids, track bid status
- **Seller:** add / update / remove cars with photos, see received bids, accept or reject, mark a car as sold
- **Connects wallet:** buy connects (demo payment), spend them on *featured listings* and *unlocking a seller's contact*, full transaction history
- **WhatsApp contact** once a bid is accepted and the contact is unlocked
- **Complaints:** report fake listings / sellers and track the status of your reports
- Responsive layout (phone, tablet, web)

**Admin app**
- Live counters for users, cars, bids and reports
- Block / activate users
- Approve or block car listings, search &amp; filter
- Monitor bids and reject suspicious ones
- Resolve or dismiss complaints
- User and listing analytics

## 🧱 Tech stack

- Flutter (Material 3) · Dart 3
- `provider` for state management
- `supabase_flutter` (PostgreSQL backend)
- `image_picker`, `url_launcher`

## 🗂 Project structure

```
Carzaar/
├── user_app/            # Buyer / seller app
│   └── lib/
│       ├── authentication/   login, sign up, forgot password
│       ├── home/             main home, buyer &amp; seller screens
│       ├── buyer/            browse cars, car details, my bids
│       ├── seller/           my cars, received bids, dashboard
│       ├── bidding/          place bid, edit bid
│       ├── listing/          add car, update car
│       ├── connects/         wallet, buy connects, history
│       ├── reports/          submit &amp; view complaints
│       ├── user_profile/     profile, edit profile
│       └── models/ services/ providers/ widgets/ utils/
├── admin_app/           # Admin dashboard app
│   └── lib/
│       ├── user_management/  car_listing_monitoring/  bid_monitoring/
│       └── report_complaint/ system_analytics/        authentication/
├── docs/
│   ├── CarZaar_Security_Findings.pdf   # full security report
│   ├── supabase_schema.sql             # database tables
│   └── screenshots/                    # README images
└── README.md
```

## 🚀 Getting started

**Requirements:** [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `>=3.11.1`), an
Android emulator / device or Chrome, and a free [Supabase](https://supabase.com) project.

1. **Create the database** – open the Supabase *SQL editor* and run [`docs/supabase_schema.sql`](docs/supabase_schema.sql).
2. **Add your Supabase project** – put your project URL and anon key in
   - `user_app/lib/main.dart`
   - `admin_app/lib/supabase_config.dart`
3. **Run the user app**
   ```bash
   cd user_app
   flutter pub get
   flutter run          # or: flutter run -d chrome
   ```
4. **Run the admin app**
   ```bash
   cd admin_app
   flutter pub get
   flutter run -d chrome
   ```
5. **Run the tests** (in either folder): `flutter test`

## 🎬 Quick demo flow

1. Create two accounts in the user app (one seller, one buyer).
2. As the seller → **Seller Mode → Add Car**.
3. As the buyer → **Buyer Mode → Browse Cars → Place Bid**.
4. As the seller → **Received Bids → Accept**.
5. As the buyer → **My Bids → Unlock Contact** (buy connects first) → **Contact on WhatsApp**.
6. Open the admin app to see the activity, block a listing or resolve a complaint.

---

## 🔐 Security Testing

After finishing the app I reviewed both modules from an attacker's point of view. The assessment is
mapped to the **OWASP Top 10 (2021)**, **OWASP API Security Top 10** and **OWASP Mobile Top 10**.

📄 **Full report (evidence, proof-of-concept requests, impact, remediation):**
[`docs/CarZaar_Security_Findings.pdf`](docs/CarZaar_Security_Findings.pdf)

### Scope &amp; method
| | |
|---|---|
| **Targets** | User app and Admin app (Dart source, Android / iOS / web configuration, Supabase calls) |
| **Approach** | Manual static code review: every Supabase call and authentication path was traced and tied to file + line numbers |
| **Proof** | For each finding, the report includes the vulnerable code and the exact request that demonstrates it |
| **Not covered** | No dynamic testing against the live backend; the RLS state of the Supabase project must be confirmed separately |

### Results

| Severity | Count |
|----------|:-----:|
| 🔴 Critical | 5 |
| 🟠 High | 4 |
| 🟡 Medium | 6 |
| 🔵 Low | 3 |
| **Total** | **18** |

**Highlights**

| ID | Finding | Severity | OWASP |
|----|---------|----------|-------|
| SEC-01 | No server-side authorization – rules enforced only in the Flutter client (Row Level Security required) | Critical | A01 / API1 |
| SEC-02 | Passwords stored and compared in plain text | Critical | A02 / A07 |
| SEC-03 | Hard-coded admin credentials, checked only on the device | Critical | A07 / CWE-798 |
| SEC-04 | Admin actions performed with the public anon key | Critical | A01 / API5 |
| SEC-09 | Wallet balance editable by the client, no payment verification, race conditions | Critical | A04 |
| SEC-05 | Password reset needs only e-mail + phone (account takeover) | High | A07 |
| SEC-06 | Whole user rows returned to other users | High | API3 |
| SEC-07 | Insecure direct object references on bids and cars | High | API1 |
| SEC-08 | Mass assignment of `is_verified`, `status`, `is_featured`, `bid_status` | High | API3 |

The remaining medium/low findings cover user enumeration, missing brute-force protection and password
policy, unrestricted image uploads, business rules enforced only in the UI, release signing and
missing audit logging. Areas reviewed with **no weakness found**: SQL injection, XSS, cleartext
traffic and server-side secrets.

### Remediation roadmap
1. Migrate to **Supabase Auth** (hashed passwords, JWT sessions) and remove the custom `password` column
2. Enable **Row Level Security** on every table with owner-based policies and an admin role
3. Move wallet, bid-acceptance and unlock-contact logic into Postgres functions / Edge Functions
4. Store images in Supabase Storage with size and type limits
5. Generic error messages, rate limiting and an admin audit log
6. Rotate keys, keep configuration out of Git, proper release signing and obfuscation

> The findings are deliberately **documented, not hidden**: this repository shows both the application
> I built and my ability to assess its security. Remediation is planned (see below).

---

## ⚠️ Known limitations

This project was built for a university course and focuses on application features. For production use:
- Replace the custom `users` table login with Supabase Auth (hashed passwords, JWT sessions)
- Enable Row Level Security policies on every table and add a real admin role
- Move wallet and bid-acceptance logic to server-side functions
- Store images in Supabase Storage instead of base64 columns
- The admin login and Supabase anon key in this repository are **demo credentials only** – do not reuse them

## 👨‍💻 Author

Built by **Abdullah Tahir** · [GitHub](https://github.com/grey-Hatt)

Feedback and suggestions are welcome — feel free to open an issue.
