# 🚀 Post Challenge: Flutter + Firebase

This project was developed as part of a technical test to demonstrate skills with Flutter, Firebase Authentication, public API consumption, and best architecture practices.

### ✨ Features

1. **🔐 OAuth Authentication (Email & Password)**
    - Auth with Firebase Authentication (email and password).
    - Retrieve user profile (name, email, photo).
    - Session persistence and logout.

2. **📝 Posts Listing**
    - Consumes the public [JSONPlaceholder](https://jsonplaceholder.typicode.com/posts) API using Dio.
    - Paginated display (10 posts at a time) with loading indicator.
    - Full title and truncated body (100 characters) with "See more" option.

3. **📄 Post Details**
    - Displays title, full body, and author.
    - Back navigation to the listing.

4. **👤 Profile Details**
    - Access profile by tapping the avatar.
    - Shows mock image, name, post count, age, and interests (data saved in Firestore).

5. **🧪 Automated Tests**
    - Unit tests with Flutter Test and Mocktail.
    - Mocking Firebase and external API.
    - Integration/golden tests (bonus).

---

## ⚙️ How to Run the Project

1. **Clone the repository:**
    ```bash
    git clone https://github.com/GiovaneLopes/post-challenge.git
    cd post-challenge
    ```

2. **Install dependencies:**
    ```bash
    flutter pub get
    ```

3. **Configure Firebase:**
    - Add your `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) to the respective folders.

4. **Run the app:**
    ```bash
    flutter run
    ```

---

## 👥 Test User

- **Email:** testuser@example.com
- **Password:** Teste@123

---

## 🧪 Running Tests

```bash
flutter test
```

---

## 🏗️ Architecture

- **Pattern:** Clean Architecture
- **State Management:** Bloc (flutter_bloc)
- **Layers:** Presentation (UI), Domain (business logic), Data (data access)
- **Justification:** Bloc was chosen for its scalability, testability, and clear separation of concerns.

---

## 📈 Expansion & Scalability

- Easily add new features (e.g., comments, likes).
- Possible to swap Firebase for another backend with low coupling.
- UI decoupled from business logic, making maintenance easier.

---

## 🛠️ Technologies & Packages

- [Flutter](https://flutter.dev/)
- [Firebase Auth](https://firebase.google.com/docs/auth)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)
- [Dio](https://pub.dev/packages/dio)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [mocktail](https://pub.dev/packages/mocktail)
- [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)

---

## ✅ Evaluation Criteria Met

- Code organization and structure
- Best practices in architecture and naming
- Layer separation
- Responsive and fluid UI
- Efficient state management
- API consumption and Firebase integration
- Error handling and clear messages
- Automated tests
- Clear documentation


