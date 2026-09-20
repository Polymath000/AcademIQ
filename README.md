# AcademIQ (GPA Calculator)

**AcademIQ** is a modern, offline-first Flutter application designed to help students track their academic progress, calculate their GPA/CGPA, and receive personalized AI-driven academic advice.

## 🎥 Demo

<video src="https://res.cloudinary.com/rj3iz5na/video/upload/v1/AcademIQ.mp4" width="300" controls></video>

*(If the player above does not load, [click the image below to watch the video](https://res.cloudinary.com/rj3iz5na/video/upload/v1/AcademIQ.mp4))*

[![Watch the video](https://res.cloudinary.com/rj3iz5na/video/upload/w_500/v1/AcademIQ.jpg)](https://res.cloudinary.com/rj3iz5na/video/upload/v1/AcademIQ.mp4)

## 🚀 Try the App
Want to see AcademIQ in action? You can download the fully built, production-ready application directly from the **[Releases](../../releases)** page. Simply download the latest `.apk` file to your Android device, install it, and experience the smooth, offline-first performance and premium dark UI instantly.

## 📋 Project Documentation & Planning

We heavily focused on proper software engineering practices before and during the development of AcademIQ. Here is a breakdown of our documentation and planning phases:

### 🏢 Business Requirements Document (BRD)
We started by defining the core business objectives and our target demographic. Our BRD outlines the exact problem we are solving: university students need a reliable, fast, offline-capable way to track their academic trajectory while receiving actionable advice. We established our Unique Value Proposition (UVP) as being the premier GPA calculator that pairs local-first speed with a robust AI Academic Advisor.

### 📝 Product Requirements Document (PRD)
Our PRD translates the business goals into strict technical and functional requirements. We meticulously mapped out:
* The complete offline-first database architecture using Hive and background cloud-syncing via Supabase.
* The exact UI/UX user flows, including error states, loading animations, and global gradient design rules.
* Edge cases and constraints, such as handling empty courses safely before triggering AI analysis and strictly managing usage quotas.

### 📅 Strategic Planning (Sprints & Tasks)
To ensure clean execution, the entire development process was broken down into manageable phases and sprints:
* **Phase 1: Core Architecture:** Setting up Clean Architecture, Dependency Injection (GetIt), and our strict `ApiResult<T>` pattern.
* **Phase 2: Local & Cloud Data:** Implementing Hive local storage and defining Supabase schemas.
* **Phase 3: Presentation & Logic:** Building Cubits, navigation routing, and integrating the OpenRouter AI API.
* **Phase 4: UI Polish:** Refining animations, implementing Skeletonizer loading states, and ensuring pixel-perfect transparent scaffolds.

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


