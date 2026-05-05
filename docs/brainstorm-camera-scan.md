# Brainstorm Report: Camera Scan Feature

## Problem Statement and Requirements
Dự án **Pure Scan** cần tính năng cốt lõi: quét tài liệu. Yêu cầu đặt ra là "Level 1" (chỉ mở camera, chụp ảnh, tự crop bằng tay và lưu lại), ưu tiên một trải nghiệm người dùng cao cấp và liền mạch (Premium UX) giữ người dùng hoàn toàn bên trong giao diện ứng dụng.

## Evaluated Approaches
1. **Approach 1: Giao phó cho Native (image_picker + image_cropper)**
   - *Pros:* Nhanh, ít lỗi, độ ổn định cực cao vì dùng Camera OS.
   - *Cons:* Trải nghiệm bị gián đoạn, không đồng nhất UI/UX với app.
2. **Approach 2: Custom In-App Camera (camera + image_cropper/extended_image)**
   - *Pros:* Trải nghiệm liền mạch tuyệt đối, người dùng luôn ở trong app. Giao diện (nút bấm, overlay) có thể tùy biến 100% theo brand. Chuẩn bị nền tảng tốt cho các tính năng nâng cao (Live edge detection) sau này.
   - *Cons:* Độ phức tạp cao, phải tự quản lý vòng đời ứng dụng (lifecycle) và bộ nhớ (memory).

## Final Recommended Solution
Khách hàng đã chốt chọn **Approach 2: Custom In-App Camera Flow**.
Giải pháp này sẽ tích hợp trực tiếp package `camera` của Flutter để dựng màn hình ngắm chụp (Viewfinder) tuân thủ thiết kế của Pure Scan. Khi người dùng bấm chụp, ảnh sẽ được nén nhanh và chuyển sang một màn hình Crop thủ công nội bộ (sử dụng `image_cropper` hoặc `extended_image`) để người dùng căn chỉnh 4 góc trước khi lưu thành tài liệu.

## Implementation Considerations and Risks
- **Quản lý bộ nhớ (OOM - Out of Memory):** Xử lý file ảnh trực tiếp từ luồng byte của Camera có thể gây crash thiết bị yếu. *Mitigation:* Cần resize/compress hình ảnh trước khi đẩy vào màn hình Crop.
- **Vòng đời ứng dụng (App Lifecycle):** Camera resource không được giải phóng khi ứng dụng rơi vào trạng thái nền (background) sẽ gây lỗi. *Mitigation:* Phải implement `WidgetsBindingObserver` để ngắt kết nối/kết nối lại camera `pausePreview()`/`resumePreview()` và `dispose()` đúng cách.
- **Phân quyền (Permissions):** Xử lý luồng xin quyền truy cập Camera/Storage một cách mượt mà, cung cấp Fallback UI (màn hình giải thích) nếu người dùng từ chối cấp quyền.
- **Xoay màn hình (Orientation):** Fix cứng màn hình Portrait hoặc xử lý orientation logic một cách cẩn thận để tránh ảnh bị lệch khi crop.

## Success Metrics and Validation Criteria
- Màn hình khởi động Camera dưới 1 giây.
- Hiển thị đúng giao diện Custom UI (không dùng app ngoài).
- Thao tác kéo 4 góc để crop thủ công hoạt động trơn tru.
- Ảnh đầu ra không bị méo, lưu thành công vào thư mục ứng dụng (App Documents).
- Không xuất hiện hiện tượng memory leak khi chụp liên tiếp nhiều lần.

## Next Steps and Dependencies
1. Cài đặt các packages cần thiết: `camera`, `permission_handler`, `image_cropper` (hoặc `extended_image`), `path_provider`.
2. Thiết kế logic quản lý state cho màn hình Camera.
3. Chỉnh sửa App manifest (Android/iOS) cho permissions.
4. Triển khai code các màn hình: Xin quyền -> Chụp -> Cắt -> Lưu.
