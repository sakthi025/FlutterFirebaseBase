# FlutterFirebaseBase

A multi-app production foundation built with **Flutter (Stable Channel)** and **Firebase**, featuring decoupled architecture, dependency injection, reusable infrastructure modules, environment flavor configurations, and automated CI/CD pipelines.

---

## 🏗 Architecture & Project Structure

The project employs Clean Architecture and MVVM with layered separation of concerns:

```text
AI_Project/
├── .github/
│   └── workflows/
│       ├── flutter_ci.yml             # Linting, testing, coverage & build verification
│       └── firebase_deploy.yml        # Deploy Functions, Security Rules & Web hosting
├── assets/
│   ├── fonts/                         # Custom typography assets
│   ├── icons/                         # SVG & vector app icons
│   └── images/                        # Raster graphic assets
├── config/                            # Environment-specific configuration bundles
│   ├── dev/config.json
│   ├── staging/config.json
│   └── prod/config.json
├── functions/                         # Firebase Cloud Functions (TypeScript v2)
│   ├── src/
│   │   └── index.ts                   # Callable HTTPS functions & Firestore triggers
│   ├── package.json
│   └── tsconfig.json
├── lib/
│   ├── core/                          # Reusable infrastructure & foundation modules
│   │   ├── api_gateway/               # Dio HTTP client, interceptors, error handling
│   │   ├── auth/                      # Firebase Auth wrappers (Email, Google, Tokens)
│   │   ├── config/                    # Environment variables & feature flags
│   │   ├── database/                  # Firestore, Cloud Storage & Functions services
│   │   ├── di/                        # GetIt dependency injection service locator
│   │   ├── logging/                   # Standardized logger with pretty-printing
│   │   └── monitoring/                # Firebase Crashlytics & Performance monitoring
│   ├── data/                          # Data sources, API models & repositories
│   ├── domain/                        # Domain entities, use cases & Result wrappers
│   ├── ui/                            # Presentation layer (MVVM)
│   │   ├── app.dart                   # Root MaterialApp with theme & routing
│   │   ├── router.dart                # GoRouter with authentication redirect guards
│   │   ├── core/theme/                # Material 3 light & dark themes
│   │   └── features/
│   │       ├── auth/                  # Login & registration views + ViewModel
│   │       └── dashboard/             # Overview dashboard showing module statuses
│   ├── firebase_options.dart          # Multi-platform Firebase configuration
│   └── main.dart                      # Default application entry point
├── src/                               # Multi-app development setup
│   ├── apps/
│   │   ├── app_one/main.dart          # Consumer application entry point
│   │   └── app_two/main.dart          # Partner / Admin application entry point
│   └── shared/                        # Shared cross-app modules & exports
├── tests/                             # Unit, integration & E2E tests
│   ├── unit/                          # Business logic & repository tests
│   ├── integration/                   # Cross-module tests
│   └── e2e/                           # End-to-end device tests
├── firebase.json                      # Firebase project services & emulators config
├── firestore.rules                    # Hardened Firestore security rules
├── storage.rules                      # Cloud Storage security rules
└── pubspec.yaml                       # Production & development dependencies
```

---

## 🚀 Key Modules

### 1. Authentication (`lib/core/auth/`)
* **`AuthService`**: Wraps `FirebaseAuth` and `GoogleSignIn` with clean async methods (`signInWithEmail`, `registerWithEmail`, `signInWithGoogle`, `signOut`, `sendPasswordResetEmail`).
* **`AuthRepository`**: Automatically synchronizes authenticated user metadata with Cloud Firestore `users/{uid}` documents.
* **`AuthViewModel`**: ChangeNotifier-based state management binding auth streams to UI components.

### 2. Database & Storage Layer (`lib/core/database/`)
* **`FirestoreService`**: Generic CRUD operations, document & collection streams, query filters, and batched atomic writes.
* **`StorageService`**: File and byte uploads, real-time upload progress, URL resolution, and storage cleanup.
* **`FunctionsService`**: Type-safe caller for Firebase Cloud Functions (HTTPS callables) with emulator integration.

### 3. API Gateway (`lib/core/api_gateway/`)
* **`ApiClient`**: High-performance HTTP client using `Dio`.
* Automatic Bearer token injection from `FirebaseAuth` for protected microservices.
* Comprehensive interceptors for logging and timing.
* Unified exception hierarchy (`NetworkException`, `UnauthorizedException`, `NotFoundException`, `ServerException`).

### 4. Logging & Monitoring (`lib/core/logging/` & `lib/core/monitoring/`)
* **`AppLogger`**: Configurable logging levels (`verbose`, `debug`, `info`, `warning`, `error`, `fatal`).
* **`CrashlyticsService`**: Catches unhandled framework errors (`FlutterError.onError`) and asynchronous platform dispatch exceptions (`PlatformDispatcher.instance.onError`).
* **`PerformanceService`**: Custom trace monitoring and HTTP network metric captures.

---

## 📱 Multi-App Development

The repository supports multiple application targets sharing common core modules:

* **Default App**:
  ```bash
  flutter run -t lib/main.dart
  ```
* **Consumer App (App One)**:
  ```bash
  flutter run -t src/apps/app_one/main.dart
  ```
* **Admin / Partner App (App Two)**:
  ```bash
  flutter run -t src/apps/app_two/main.dart
  ```

---

## ⚙️ Environments & Flavors

Switch between environments (`dev`, `staging`, `prod`) by initializing the target `Environment`:

```dart
AppConfig.initialize(
  environment: Environment.dev,
  appName: 'FlutterFirebaseBase (Dev)',
  apiBaseUrl: 'https://api-dev.example.com/v1',
);
```

Environment JSON configurations are placed in `config/dev/config.json`, `config/staging/config.json`, and `config/prod/config.json`.

---

## 🔒 Security Rules

* **`firestore.rules`**: Restricts user document read/writes strictly to `request.auth.uid == userId` with default deny on unspecified collections.
* **`storage.rules`**: Restricts storage bucket writes to the authenticated document owner and enforces a maximum file size limit (10MB).

---

## 🛠 Local Emulators

Start the local Firebase emulators for offline development:

```bash
npx -y firebase-tools@latest emulators:start
```

* Emulator UI: `http://localhost:4000`
* Auth Emulator: `localhost:9099`
* Firestore Emulator: `localhost:8080`
* Functions Emulator: `localhost:5001`
* Storage Emulator: `localhost:9199`

---

## 🔄 CI/CD Pipelines

GitHub Actions workflows are pre-configured:
1. **`.github/workflows/flutter_ci.yml`**:
   - Triggers on PRs and pushes to `main`/`dev`.
   - Runs `flutter analyze`, `flutter test --coverage`, and builds web/APK targets.
2. **`.github/workflows/firebase_deploy.yml`**:
   - Triggers on merge to `main`.
   - Compiles TypeScript Cloud Functions.
   - Deploys Security Rules, Cloud Functions, and Flutter Web hosting to Firebase.
