# 🐾 PawPal – Pet Adoption & Donation Mobile Application

PawPal is a full-stack mobile application developed using **Flutter**, **PHP**, and **MySQL**. The app enables users to browse pets, submit adoption requests, donate to pets in need, and manage their user profiles. This project was built as a final assignment for **STTGK3013 Mobile Web Programming**.

---

## 📱 Features

### Authentication
- User Registration
- User Login
- Persistent login using **SharedPreferences**
- Secure logout

### Public Pet Listing
- View all available pets
- Search pets by name
- Filter pets by type (e.g., Cat, Dog)
- Clean and responsive UI

### Pet Details & Adoption
- View detailed pet information
- Submit adoption request form
- Pet status updates from **Available** → **Requested**
- Form validation with user feedback (Snackbar)

### Donation Module
- Donate to pets that require donations
- Donation types:
  - Food
  - Medical
  - Money
- Money donations integrated with **Billplz payment gateway**
- Secure payment flow

### Donation History
- View donation history
- Donations filtered by logged-in user

### User Profile Management
- View user profile details
- Edit name, phone number, and profile image
- Email and User ID are read-only
- Profile image upload to server
- Drawer updates dynamically after profile changes

---

## Tech Stack

### Frontend
- Flutter (Dart)
- Material UI
- HTTP package
- SharedPreferences

### Backend
- PHP (RESTful APIs)
- MySQL Database
- cPanel Hosting Environment

### Other Services
- Billplz (Payment Gateway)
- Hosted on cPanel server

---

## ⚙️ Project Setup

### 1️ Clone Repository
```bash
git clone https://github.com/HaziqqFairuz/Pawpal_app.git
cd Pawpal_app
```

### 2️ Flutter Setup
- Ensure Flutter SDK is installed
- Run the following commands:
```bash
flutter pub get
flutter run
```

### 3️ Backend Setup (PHP & MySQL)
- Upload the backend PHP files to your **cPanel hosting** (e.g., `public_html/pawpal`)
- Create a MySQL database using **cPanel → MySQL Databases**
- Import the provided SQL file using **phpMyAdmin**
- Configure database credentials in the PHP configuration files
- Ensure required PHP extensions (cURL, mysqli) are enabled

- Update API base URL in Flutter (`myconfig.dart`)

```dart
const String server = "http://YOUR_SERVER_IP/pawpal";
```

---

## 🔗 API Usage (Overview)

The Flutter app communicates with the backend hosted on a **cPanel server** using HTTP POST requests and JSON responses.

### Example APIs Used
- **Login API** – Authenticate user
- **Register API** – Create new user
- **Get Pets API** – Fetch all pets
- **Search & Filter Pets API**
- **Adoption Request API** – Submit adoption form
- **Donation API** – Store donation data
- **Donation History API** – Retrieve user donations
- **Profile Update API** – Update user details & image

### Payment Gateway
- **Billplz API** is used for handling online payments
- Payment flow redirects users to Billplz checkout page
- Successful payments are verified before storing donation records

> All APIs return JSON responses and are handled using `dart:convert`.

---

## 📂 Project Structure (Flutter)

```
lib/
├── models/
│   ├── user.dart
│   ├── petsubmission.dart
│   └── donation.dart
├── view/
│   ├── home_screen.dart
│   ├── pets_screen.dart
│   ├── pet_details_screen.dart
│   ├── pet_donation_screen.dart
│   └── profile_screen.dart
├── shared/
│   ├── mydrawer.dart
│   └── animated_route.dart
├── myconfig.dart
└── main.dart
```

---

## Demo & Source Code

- **GitHub Repository**  
  https://github.com/HaziqqFairuz/Pawpal_app.git

- **YouTube Demo Video**  
  https://youtu.be/OtveaK6Esic

---

## Author

**Muhammad Haziq bin Mohamad Fairuz**  
Matric No: 303559  
Course: STTGK3013 Mobile Web Programming

