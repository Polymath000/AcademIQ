# AcademIQ - Project Context & Overview

## 📌 Project Overview
**AcademIQ** is an offline-first Flutter application designed for university students to track semesters and courses, dynamically calculate Semester and Cumulative GPA (CGPA), customize grading scales, and receive AI-guided academic insights.

---

## 🏗 Architectural Blueprint (Clean Architecture & Feature-First)

The project strictly follows Clean Architecture layer boundaries:
`Presentation (Views & Widgets -> Cubits)` → `Domain (Entities & UseCases)` → `Data (Models, Repositories, DataSources)`.

```text
lib/
├── config/
│   ├── routes/          # AppRoutes with onGenerateRoute
│   └── theme/           # AppColors, AppTextStyles, AppTheme, AppIcons
├── core/
│   ├── background_sync/ # Workmanager callbackDispatcher for offline sync queue
│   ├── constants/       # AppConstants, AppBorders
│   ├── errors/          # Failures and Exceptions
│   ├── networking/      # ApiResult<T> sealed class, SupabaseInterceptor, ApiErrorHandler
│   ├── utls/            # GetIt service locator (setupServiceLocator)
│   └── widgets/         # Reusable global widgets (buttons, dialogs, error handlers)
└── features/
    ├── ai_advisor/      # AI prompt analysis & OpenRouter integration
    ├── auth/            # Supabase authentication (login, signup, session check)
    ├── home/            # Semesters, subjects, GPA calculations, and sync queue
    ├── main_layout/     # Bottom navigation bar & persistent scaffolding
    ├── onboarding/      # First-launch onboarding slider
    ├── settings/        # Profile info & customizable grading scale
    └── splash/          # Auth state routing dispatch
```

---

## 🗄️ Backend & Cloud Storage (Supabase)

* **Provider:** Supabase (PostgreSQL, Supabase Auth, Row-Level Security, PostgREST).
* **Tables:**
  * `profiles`: `id` (references `auth.users.id`), `full_name`, `email`, `cgpa`, `total_credits`, `grading_scale` (JSONB), `ai_usage_count`, `is_quota_finished`.
  * `semesters`: `id`, `user_id`, `name`, `order_index`, `created_at`.
  * `subjects`: `id`, `semester_id` (foreign key with `ON DELETE CASCADE`), `user_id`, `name`, `credits`, `grade_letter`, `created_at`.
* **Database Triggers & Functions:**
  * `public.handle_new_user()` executes `AFTER INSERT ON auth.users` to automatically populate `public.profiles` with standard default grading scale JSON and metadata.
* **Row-Level Security (RLS):**
  * Strict user isolation: `auth.uid() = user_id` on `semesters` and `subjects`; `auth.uid() = id` on `profiles`.
* **Telemetry & Error Handling:**
  * `SupabaseInterceptor` logs requests/responses during debug runs.
  * `ApiErrorHandler` translates Postgres error codes (`42501`, `23505`, `53300`) and Auth exceptions into safe user-facing domain failures.

---

## 🔄 Offline-First Synchronization Architecture

1. **Hive Local Cache:** All reads and writes resolve instantly through local Hive boxes (`semesters_box`, `subjects_box`, `settings_box`).
2. **Sync Action Queue:** When offline, mutations are recorded as `SyncActionModel` entries in `sync_queue_box`.
3. **Background Worker:** `Workmanager` (`callbackDispatcher`) executes headless synchronization with network constraints (`NetworkType.connected`), replaying queued actions in order to Supabase.
4. **Calculated Metric Sync:** CGPA and total credits are recalculated locally and synced to `profiles.cgpa` and `profiles.total_credits`.

---

## 🛡️ Coding Standards & Core Conventions

1. **Result Pattern (`ApiResult<T>`):** Native Dart 3 sealed class (`Success<T>` and `FailureResult<T>`) using pattern matching (`.when()`). No `dartz` or `@freezed`.
2. **State Management:** `flutter_bloc` Cubits with Dart 3 sealed state hierarchies.
3. **Routing:** Pure `onGenerateRoute` in `AppRoutes`.
4. **Dependency Injection:** `get_it` lazy singletons registered in `setupServiceLocator()`.
5. **No Business Logic in UI:** All logic resides in UseCases and Cubits. UI only observes state and renders.
