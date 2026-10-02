CarZaar-Car Bidding Marketplace

Flutter | Dart | Supabase


**CarZaar** ("Where Car Meets Best Prices") is a mobile marketplace where sellers list their cars and buyers compete with bids. It was built as the final project of my **Mobile Application Development** course using **Flutter** and **Supabase** and I later performed a **security review** of both apps, the full report is included in this repository.

| App | Folder | For | What it does |
|-----|--------|-----|--------------|
| **CarZaar** | user_app | Buyers and sellers | Browse cars, place / edit / withdraw bids, list cars, accept offers, buy connects, report problems |
| **CarZaar Admin** | admin_app | Admin View | Dashboard, user management, listing and bid monitoring, complaint handling, analytics |


## 📸 Screenshots

### User app (buyer &amp; seller)
<table>
  <tr><td align="center" valign="top"><img src="docs/screenshots/user_app/01_login.png" width="230"><br><sub><b>Login</b></sub></td><td align="center" valign="top"><img src="docs/screenshots/user_app/02_signup.png" width="230"><br><sub><b>Sign up</b></sub></td><td align="center" valign="top"><img src="docs/screenshots/user_app/03_home.png" width="230"><br><sub><b>Home / mode switch</b></sub></td></tr>
  <tr><td align="center" valign="top"><img src="docs/screenshots/user_app/04_browse_cars.png" width="230"><br><sub><b>Browse &amp; search cars</b></sub></td><td align="center" valign="top"><img src="docs/screenshots/user_app/05_car_details.png" width="230"><br><sub><b>Car details</b></sub></td><td align="center" valign="top"><img src="docs/screenshots/user_app/06_place_bid.png" width="230"><br><sub><b>Place a bid</b></sub></td></tr>
  <tr><td align="center" valign="top"><img src="docs/screenshots/user_app/07_my_bids.png" width="230"><br><sub><b>My bids</b></sub></td><td align="center" valign="top"><img src="docs/screenshots/user_app/08_seller_dashboard.png" width="230"><br><sub><b>Seller dashboard</b></sub></td><td align="center" valign="top"><img src="docs/screenshots/user_app/09_add_car.png" width="230"><br><sub><b>Add car listing</b></sub></td></tr>
  <tr><td align="center" valign="top"><img src="docs/screenshots/user_app/10_received_bids.png" width="230"><br><sub><b>Received bids</b></sub></td><td align="center" valign="top"><img src="docs/screenshots/user_app/11_connects_wallet.png" width="230"><br><sub><b>Connects wallet</b></sub></td><td align="center" valign="top"><img src="docs/screenshots/user_app/12_profile.png" width="230"><br><sub><b>Profile</b></sub></td></tr>
</table>

### Admin app
<table>
  <tr><td align="center" valign="top"><img src="docs/screenshots/admin_app/01_admin_login.png" width="300"><br><sub><b>Admin login</b></sub></td><td align="center" valign="top"><img src="docs/screenshots/admin_app/02_dashboard.png" width="300"><br><sub><b>Dashboard</b></sub></td><td align="center" valign="top"><img src="docs/screenshots/admin_app/03_users.png" width="300"><br><sub><b>User management</b></sub></td></tr>
  <tr><td align="center" valign="top"><img src="docs/screenshots/admin_app/04_listings.png" width="300"><br><sub><b>Listing monitoring</b></sub></td><td align="center" valign="top"><img src="docs/screenshots/admin_app/05_bids.png" width="300"><br><sub><b>Bid monitoring</b></sub></td><td align="center" valign="top"><img src="docs/screenshots/admin_app/06_reports.png" width="300"><br><sub><b>Complaints</b></sub></td></tr>
  <tr><td align="center" valign="top"><img src="docs/screenshots/admin_app/07_analytics.png" width="300"><br><sub><b>Analytics</b></sub></td></tr>
</table>

---

## ✨ Features

**User app**
- Sign up, log in, reset password, edit profile.
- One account, two modes — switch between **Buyer** and **Seller** from the home screen
- **Buyer:** search and browse active listings, view details, place / edit / withdraw bids, track bid status
- **Seller:** add / update / remove cars with photos, see received bids, accept or reject, mark a car as sold
- **Connects wallet:** buy connects (demo payment), spend them on *featured listings* and *unlocking a seller's contact*
- **WhatsApp contact** once a bid is accepted and the contact is unlocked
- **Complaints:** report fake listings / sellers and track the status of your reports

**Admin app**
- Live counters for users, cars, bids and reports
- Block / activate users
- Approve or block car listings, search and filter
- Monitor bids and reject suspicious ones
- Resolve or dismiss complaints
- User and listing analytics


Demo flow

1. Create two accounts in the user app (one seller, one buyer).
2. As the seller → **Seller Mode → Add Car**.
3. As the buyer → **Buyer Mode → Browse Cars → Place Bid**.
4. As the seller → **Received Bids → Accept**.
5. As the buyer → **My Bids → Unlock Contact** (buy connects first) → **Contact on WhatsApp**.
6. Open the admin app to see the activity, block a listing or resolve a complaint.


Security Testing

After finishing the app I reviewed both modules from an attacker's point of view. The assessment is
mapped to the **OWASP Top 10 (2021)**, **OWASP API Security Top 10** and **OWASP Mobile Top 10**.


Author

Built by Me as a part of my Mobile Application project and later has done security testing on it.
Feedback and suggestions are welcome, feel free to open an issue.
