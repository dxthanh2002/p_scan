# Flutter Project Structure — Core Pattern (`lib/`)

> Chỉ liệt kê các thành phần **core / tái sử dụng cao**. Các feature cụ thể (chat, conversation, discover, minigames, profile, reward, store) đều tuân theo cùng pattern `*_screen.dart` + `*_viewmodel.dart` nên được lược bỏ.

```
lib/
├── main.dart                          # Entry point
│
├── features/                          # Feature-based modules (Screen + ViewModel)
│   ├── bottom_navigator.dart          # Bottom navigation bar (reusable)
│   │
│   ├── <feature_name>/               # Mỗi feature 1 folder, pattern:
│   │   ├── <feature>_screen.dart     #   → View (UI)
│   │   └── <feature>_viewmodel.dart  #   → ViewModel (state + logic)
│   │
│   └── shared/                        # Shared/reusable UI components
│       ├── custom_confirm_dialog/
│       │   ├── custom_confirm_dialog_screen.dart
│       │   └── custom_confirm_dialog_viewmodel.dart
│       └── out_of_gems_dialog/
│           └── out_of_gems_dialog.dart
│
├── models/                            # Data models / entities
│   ├── auth.dart
│   ├── bot.dart
│   └── chat.dart
│
├── navigation/                        # Routing & navigation
│   ├── router.dart
│   └── routes.dart
│
├── repositories/                      # Data access layer (API calls, local DB)
│   ├── auth_repository.dart
│   ├── bot_repository.dart
│   ├── chat_repository.dart
│   └── user_repository.dart
│
├── services/                          # Business logic & platform services
│   ├── api_service.dart
│   ├── app_service.dart
│   ├── appService.dart
│   ├── device_service.dart
│   └── iap_service.dart
│
├── theme/                             # Theming & styling
│   ├── colors.dart
│   └── theme_data.dart
│
└── utils/                             # Utilities & helpers
    ├── console.dart
    └── constants.dart
```

## Architecture Pattern: **MVVM (Model–View–ViewModel)**

| Layer | Folder | Responsibility |
|-------|--------|----------------|
| **View** | `features/*_screen.dart` | UI widgets, layout, user interaction |
| **ViewModel** | `features/*_viewmodel.dart` | State management, UI logic, connects View ↔ Repository |
| **Model** | `models/` | Data structures / entities |
| **Repository** | `repositories/` | Data access — API calls, local storage |
| **Service** | `services/` | Cross-cutting concerns (API client, device info, IAP) |

## Cách thêm feature mới

Tạo folder mới trong `features/` theo pattern:

```
features/<tên_feature>/
├── <tên_feature>_screen.dart
└── <tên_feature>_viewmodel.dart
```

## Lưu ý

- **Shared widgets** nằm trong `features/shared/` — dùng cho dialog/component tái sử dụng.
- **Navigation** tập trung trong `navigation/` — tách route definitions khỏi router config.
- **Duplicate service** — `appService.dart` và `app_service.dart` cùng tồn tại, nên gộp lại.
