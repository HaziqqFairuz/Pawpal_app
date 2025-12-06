# pawpal_app

# PawPal – Pet Submission Feature (Mini Project)

This README documents only the parts you implemented:

* **lib/models/petsubmission.dart**
* **lib/view/home_screen.dart**
* **lib/view/submit_pet_screen.dart**
* **server/pawpal/api/get_my_pet.php**
* **server/pawpal/api/submit_pet.php**

It explains setup steps, API usage, and sample JSON to help anyone run or understand this module.

---

## Project Overview

This mini‑project is part of the PawPal App, allowing users to:

* Submit pet information along with an image
* Fetch and display their submitted pets on the home_screen

The system uses:

* **Flutter (Frontend)**
* **PHP (Backend API)**
* **MySQL (Database)**
* **File storage for pet images**

---

## 🗂 Folder Structure

```
pawpal_app/
│
├── lib/
│   ├── models/
│   │   └── petsubmission.dart
│   └── view/
│       ├── homescreen.dart
│       └── submit_pet_screen.dart
│
server/
└── pawpal/
    ├── api/
    │   ├── get_my_pet.php
    │   └── submit_pet.php
    └── assets/
        └── pets/   ← stored images go here
```

---

## ⚙️ Setup Instructions

### ✅ 1. Backend Setup (XAMPP / Hosting)

1. Copy **server/pawpal** folder into your server directory:

   * XAMPP → `htdocs/pawpal/`
2. Create a **MySQL Database** (example: `pawpal_db`)
3. Create table (example schema):

```sql
CREATE TABLE `tbl_pets` (
  `pet_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `pet_name` varchar(100),
  `pet_type` varchar(50),
  `category` varchar(50),
  `description` text,
  `lat` varchar(50),
  `lng` varchar(50),
  'created_at' Timestamp,
  PRIMARY KEY (`pet_id`)
);
```

4. Ensure `/assets/pets/` folder has **write permission**.

---

###  2. Flutter Setup

1. Inside Flutter project:

```
flutter pub get
```

2. API URL :

```
MyConfig.baseUrl = "http://10.29.19.141:80";
```

3. Run app:

```
flutter run
```

---

##  API Documentation

### **1. Submit Pet**

**URL: POST /pawpal/api/submit_pet.php**

```
POST /pawpal/api/submit_pet.php
```
This field must be send:

- userid
- pet_name
- pet_type
- category
- description
- lat
- lng
- image_list (JSON array of Base64 images)

### Request (JSON)

```json
{
    "userid": "3",
    "pet_name": "Kitty",
    "pet_type": "Cat",
    "category": "Lost",
    "description": "White cat with blue eyes",
    "lat": "6.453200",
    "lng": "100.505000",
    "image_list": [
    "BASE64_IMAGE_STRING_1",
    "BASE64_IMAGE_STRING_2"
]
}
```

### Success Response

```json
{
  "status": "success",
  "message": "Pet submitted successfully",
  "data": {
    "pet_id": "$last_id",
    "filename": "count($image_list)"
  }
}
```

### Error Response

```json
{
  "status": "failed",
  "message": "No images received"
}
```

---

### **2. Get My Pets**

**URL:**

```
GET /pawpal/api/get_my_pet.php?userid=3
```

### Success Response

```json
{
    "status": "success",
    "message": "Success",
    "data": [
{
    "pet_id": "12",
    "user_id": "3",
    "pet_name": "Kitty",
    "pet_type": "Cat",
    "category": "Lost",
    "description": "White cat with blue eyes",
    "lat": "6.453200",
    "lng": "100.505000"
}
]
}
```

### No Pets

```json
{
  "status": "failed",
  "message": "Invalid request",
  "data": null
}
```

---

## **Pet Image Naming Structure**

backend saves image files as:

```
pet_<petid>_<index>.png
```

Example:

```
pet_12_0.png
```

Place inside:

```
server/pawpal/assets/pets/
```

### Flutter must load it using:

```
${MyConfig.baseUrl}/pawpal/assets/pets/pet_${pet.petId}_0.png
```

---

## Flutter Models & Screens

### 🔹 `petsubmission.dart`

Represents a pet object returned from API.

### `home_screen.dart`

* Loads pet list using GET API
* Displays pet card with image
* Shows fallback if image fails

### `submit_pet_screen.dart`

* Form input for pet info
* Encodes image as Base64
* Sends JSON POST request to API

---

## Testing the API

### Using Postman / Thunder Client:

1. Test **submit_pet.php** using POST + JSON
2. Test **get_my_pet.php** using GET
3. Check if images appear in `/assets/pets/`

---

