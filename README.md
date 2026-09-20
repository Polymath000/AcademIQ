# AcademIQ (GPA Calculator)

**AcademIQ** is a modern, offline-first Flutter application designed to help students track their academic progress, calculate their GPA/CGPA, and receive personalized AI-driven academic advice.

## ✨ Features

* **Offline-First Architecture**: Seamlessly handles offline usage with local caching (Hive) and background synchronization to the cloud (Supabase) when connectivity is restored.
* **Smart GPA Calculation**: Add semesters and subjects to instantly calculate Semester GPA and Cumulative GPA based on customizable grading scales.
* **AI Academic Advisor**: Integrates with OpenRouter to analyze a student's transcript and offer personalized study strategies, course recommendations, and resource suggestions.
* **Modern UI/UX**: Premium dark theme featuring smooth animations, glassmorphism, and a beautiful Rose/Indigo gradient design.
* **Secure Authentication**: Email/Password and social login powered by Supabase Auth.

## 🛠 Tech Stack

* **Framework:** [Flutter](https://flutter.dev/) (Dart 3)
* **State Management:** `flutter_bloc` (Cubits)
* **Dependency Injection:** `get_it`
* **Local Storage:** `hive` & `hive_flutter`
* **Backend as a Service:** [Supabase](https://supabase.com/) (PostgreSQL Database, Authentication)
* **AI Integration:** OpenRouter API (`flutter_markdown` for rendering output)
* **Network & Env:** `flutter_dotenv`, `connectivity_plus`

## 🏗 Architecture

The project strictly follows **Clean Architecture** principles grouped by features (Feature-First pattern).

```
lib/
├── config/             # Theme, routing, and global constants
├── core/               # Shared utilities, networking, error handling, background sync
└── features/           # Feature modules
    ├── ai_advisor/     # AI analysis and prompting logic
    ├── auth/           # Login and registration
    ├── home/           # Semesters, subjects, and GPA dashboard
    ├── main_layout/    # Bottom navigation bar and global scaffolding
    ├── onboarding/     # First-time user experience
    ├── settings/       # User profile and grading scale configurations
    └── splash/         # App initialization and routing dispatch
```

### Error Handling Pattern (`ApiResult<T>`)
We enforce safe error handling using Dart 3 sealed classes via the `ApiResult<T>` pattern. Raw exceptions are caught in the Repository layer and converted into `Success<T>` or `FailureResult<T>`. This eliminates unhandled exceptions and keeps the Presentation (Cubit) layer focused entirely on mapping results to state.


