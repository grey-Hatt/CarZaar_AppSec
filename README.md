# 🚗 CarZaar — Car Bidding Marketplace

**CarZaar** ("Where Car Meets Best Prices") is a mobile marketplace where sellers list their
cars and buyers compete with bids. It was built as the final project of my **Mobile Application
Development** course, using **Flutter** and **Supabase (PostgreSQL)**.

The project is made of two apps that share one backend:

| App | Folder | For | What it does |
|-----|--------|-----|--------------|
| **CarZaar** | [`user_app/`](user_app) | Buyers & sellers | Browse cars, place/edit/withdraw bids, list cars, accept offers, buy "connects", report problems |
| **CarZaar Admin** | [`admin_app/`](admin_app) | Moderators | Dashboard, user management, listing & bid monitoring, complaint handling, analytics |

## ✨ Features

**User app**
- Sign up, log in, reset password, edit profile (with photo)
- One account, two modes — switch between **Buyer** and **Seller** from the home screen
- **Buyer:** search & browse active listings, view details, place / edit / withdraw bids, see bid status
- **Seller:** add / update / remove cars with photos, see received bids, accept or reject, mark a car as sold
- **Connects wallet:** buy connects (demo payment), spend them on *featured listings* and *unlocking a seller's contact*, full transaction history
- **WhatsApp contact** once a bid is accepted and the contact is unlocked
- **Complaints:** report fake listings / sellers and track the status of your reports
- Responsive layout (phone, tablet, web)

**Admin app**
- Live counters for users, cars, bids and reports
- Block / activate users
- Approve or block car listings, search & filter
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
│       ├── home/             main home, buyer & seller screens
│       ├── buyer/            browse cars, car details, my bids
│       ├── seller/           my cars, received bids, dashboard
│       ├── bidding/          place bid, edit bid
│       ├── listing/          add car, update car
│       ├── connects/         wallet, buy connects, history
│       ├── reports/          submit & view complaints
│       ├── user_profile/     profile, edit profile
│       ├── models/ services/ providers/ widgets/ utils/
├── admin_app/           # Admin dashboard app
│   └── lib/
│       ├── user_management/  car_listing_monitoring/  bid_monitoring/
│       ├── report_complaint/ system_analytics/        authentication/
├── docs/
│   └── supabase_schema.sql   # database tables
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

## 📸 Screenshots

_Add screenshots of the login, home, browse cars, car details, seller dashboard and admin dashboard here._

## 👩‍💻 Author

Built by **<your name>** as a university project. Feedback is welcome!
