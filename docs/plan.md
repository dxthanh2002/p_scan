---
title: Boilerplate Creation Plan
status: completed
---

# Plan: Basic Flutter MVVM Boilerplate

## Phase 1: Core Directories Initialization
- [x] Create `lib/features/shared/`
- [x] Create `lib/models/`
- [x] Create `lib/navigation/`
- [x] Create `lib/repositories/`
- [x] Create `lib/services/`
- [x] Create `lib/theme/`
- [x] Create `lib/utils/`

## Phase 2: Core Files Creation (No extra libraries)
- [x] Create `lib/theme/colors.dart` (Define basic AppColors)
- [x] Create `lib/theme/theme_data.dart` (Define basic AppTheme)
- [x] Create `lib/utils/constants.dart` (Define basic AppConstants)
- [x] Create `lib/utils/console.dart` (Define basic print wrapper)
- [x] Create `lib/services/api_service.dart` (Basic HTTP wrapper placeholder)
- [x] Create `lib/navigation/routes.dart` (Basic routing constants)
- [x] Create `lib/navigation/router.dart` (Basic standard Navigator routing)

## Phase 3: Sample Feature (Optional validation)
- [x] Create `lib/features/home/home_screen.dart` (Basic StatefulWidget)
- [x] Create `lib/features/home/home_viewmodel.dart` (Basic ChangeNotifier)

## Phase 4: Main Entry Point
- [x] Update `lib/main.dart` to use `AppTheme` and `AppRouter`.
