# 📰 News App

[![CI](https://github.com/MohammadHumedat/News-Application/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/MohammadHumedat/News-Application/actions/workflows/ci.yml)
![Flutter](https://img.shields.io/badge/Flutter-3.41.4-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)

A modern Flutter news application that delivers top headlines and lets you search, read, and bookmark articles — all in a clean, responsive UI.

---

## ✨ Features

- 🗞️ **Breaking News** — Top headlines with an auto-playing carousel
- 🔍 **Search** — Real-time search with debounce across thousands of articles
- 🔖 **Bookmarks** — Save and revisit articles offline via SharedPreferences
- 📄 **Article Details** — Full article view with read-time estimate and external link
- 🌙 **Dark / Light Theme** — Full Material 3 theming support
- 💫 **Splash Screen** — Native splash + animated Flutter splash page

---

## 🏗️ Architecture

```
lib/
├── core/
│   ├── models/          # NewsApiResponse, Article, Source, SearchBody
│   ├── utils/
│   │   ├── constants/   # AppConstants (API key, base URL, endpoints)
│   │   ├── route/       # AppRouter, AppRoutes
│   │   └── theme/       # AppColors, AppTheme
│   └── views/
│       ├── pages/       # DrawerPage
│       └── widgets/     # AppBarButton, BookmarkNews
└── features/
    ├── bookmark/        # BookmarkCubit, BookmarkState, BookmarksPage
    ├── home/            # HomeCubit, HomeState, HomePage, CarouselSlider
    ├── search/          # SearchCubit, SearchState, SearchPage
    └── splash/          # SplashPage
```

**State Management:** Flutter BLoC (Cubit)  
**HTTP Client:** Dio  
**Image Caching:** CachedNetworkImage  
**Local Storage:** SharedPreferences

---

## 🚀 Getting Started

### Prerequisites

- Flutter `>=3.41.4`
- Dart `>=3.9.2`
- A free API key from [newsapi.org](https://newsapi.org)

### Installation

```bash
# 1. Clone the repo
git clone https://github.com/MohammadHumedat/News-Application.git
cd News-Application

# 2. Install dependencies
flutter pub get

# 3. Add your API key in:
#    lib/core/utils/constants/app_constants.dart
static const String apiKey = 'YOUR_API_KEY_HERE';

# 4. Run the app
flutter run
```

---

## 🔄 CI/CD — GitHub Actions

This project uses **GitHub Actions** for continuous integration.

### Workflow

Every `push` to `development-stage` and every **Pull Request** targeting `main` triggers the pipeline automatically:

```
push / PR
    ↓
┌─────────────────────────┐
│     Analyze & Test      │
│                         │
│  1. Checkout code       │
│  2. Setup Flutter       │
│  3. flutter pub get     │
│  4. dart format check   │
│  5. flutter analyze     │
│  6. flutter test        │
└─────────────────────────┘
    ↓
✅ Pass → Safe to merge
❌ Fail → Merge is blocked
```

### Branch Strategy

| Branch | Purpose |
|--------|---------|
| `main` | Production-ready code only |
| `development-stage` | Active development branch |

> ⚠️ Direct pushes to `main` are not allowed. All changes must go through a PR from `development-stage`.

### Running Tests Locally

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run a specific test file
flutter test test/models/article_model_test.dart
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_bloc` | ^8.1.2 | State management |
| `dio` | ^5.9.1 | HTTP client |
| `cached_network_image` | ^3.4.1 | Image caching |
| `carousel_slider` | ^5.1.2 | Breaking news slider |
| `shared_preferences` | ^2.5.4 | Bookmark persistence |
| `url_launcher` | ^6.3.2 | Open articles in browser |

---

## 🧪 Tests

```
test/
└── models/
    └── article_model_test.dart   # 11 unit tests for Article, Source, NewsApiResponse
```

---

## 📄 License

This project is licensed under the MIT License.