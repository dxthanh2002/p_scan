---
title: Camera Scan Feature Implementation
status: pending
blockedBy: []
blocks: []
---

# Camera Scan Feature Implementation

## Context
Dựa trên báo cáo `brainstorm-camera-scan.md`, hệ thống sẽ sử dụng **Approach 2 (Custom In-App Camera Flow)** kết hợp với giao diện tham khảo từ người dùng (UI tối màu, khung viền xanh, nút chụp tròn, flash, thư viện ảnh).

## Objective
Xây dựng luồng quét tài liệu "Level 1" hoàn chỉnh bên trong ứng dụng `Pure Scan`:
1. Giao diện ngắm chụp (Viewfinder) tuân thủ mockup (Dark theme, reticle góc xanh, text báo trạng thái).
2. Xử lý chụp ảnh an toàn (tránh OOM) và truyền dữ liệu mượt mà.
3. Cho phép người dùng cắt ảnh thủ công sau khi chụp và lưu vào hệ thống file của thiết bị.

## Phases

### Phase 1: Setup Dependencies & Permissions
1. Thêm các dependencies vào `pubspec.yaml`:
   - `camera` (Core module để stream và capture ảnh).
   - `image_cropper` (UI cắt ảnh chuẩn).
   - `path_provider` (Lấy thư mục để lưu ảnh).
   - `permission_handler` (Quản lý quyền an toàn).
   - `image_picker` (Cho nút chọn ảnh từ gallery trong UI).
2. Thiết lập quyền truy cập cho Android (`AndroidManifest.xml`) và iOS (`Info.plist`).
3. Chạy `flutter pub get`.

### Phase 2: Core Camera Logic & State Management
1. Tạo thư mục `lib/features/camera_scan/`.
2. Khởi tạo `CameraController` an toàn (xử lý `WidgetsBindingObserver` cho vòng đời ứng dụng).
3. Xử lý quyền (Permissions logic): Nếu user từ chối, hiển thị màn hình hướng dẫn cấp quyền.
4. Cấu hình độ phân giải phù hợp (Ví dụ: `ResolutionPreset.high`) để cân bằng giữa chất lượng và RAM.

### Phase 3: Implement Viewfinder UI (Giao diện chụp)
1. Tạo `CameraScanScreen` với cấu trúc `Stack`.
2. Lớp nền dưới cùng: `CameraPreview`.
3. Lớp Overlay (Dựa trên mockup):
   - **Top Bar:** Nút `Close` (Trái), Nút `Flash Toggle` (Phải) với nền mờ.
   - **Reticle (Khung ngắm):** Khung viền chỉ hiện 4 góc (màu xanh dương) để mô phỏng vùng quét.
   - **Trạng thái:** Một nút pill "ALIGNING DOCUMENT" (có thể làm giả trạng thái text tĩnh ở Level 1 này).
   - **Bottom Bar:** 
     - Dòng chữ "SCAN" có gạch chân màu xanh.
     - Nút chụp (Shutter) lớn, màu trắng, có viền tròn bao quanh ở giữa.
     - Nút "Gallery" dạng biểu tượng (Icon) nằm góc phải dưới.

### Phase 4: Capture, Crop & Save
1. Logic nút Shutter: Khi nhấn, gọi `takePicture()`. Nén/Resize ảnh nếu cần thiết để tránh Out-of-Memory trên thiết bị yếu.
2. Logic nút Gallery: Dùng `image_picker` để lấy ảnh có sẵn.
3. Chuyển ảnh (từ Camera hoặc Gallery) qua package `image_cropper` với thiết lập chuẩn (tỉ lệ tự do, giao diện dark mode đồng bộ).
4. Lưu file đầu ra: Lấy ảnh crop được lưu vào thư mục sinh ra bởi `path_provider` (Ví dụ: `ApplicationDocumentsDirectory`).
5. Quay về màn hình Home và thông báo lưu thành công.

## Next Step
- Để bắt đầu thực thi kế hoạch này, vui lòng sử dụng lệnh `/ck:cook d:\Flutter\pure_scan\plans\20260505-camera-scan\plan.md` hoặc cho tôi biết nếu bạn muốn thêm/bớt điều gì từ kế hoạch này.
