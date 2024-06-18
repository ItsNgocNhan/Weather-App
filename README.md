# weatherapp

Ứng Dụng Dự Báo Thời Tiết Bằng Flutter

## Tổng Quan

- Ứng Dụng Dự Báo Thời Tiết Bằng Flutter là một ứng dụng di động được phát triển bằng framework Flutter và ngôn ngữ lập trình Dart. Ứng dụng này cung cấp các dự báo thời tiết theo thời gian thực với nền động tương ứng với các điều kiện thời tiết khác nhau (nắng, mưa, nhiều mây). Được phát triển bằng công cụ Android Studio.

## Tính Năng

- Dữ Liệu Thời Tiết Theo Thời Gian Thực: Lấy thông tin thời tiết mới nhất từ API thời tiết đáng tin cậy.
- Nền Động: Hiển thị các nền động khác nhau dựa trên điều kiện thời tiết hiện tại.
- Giao Diện Thân Thiện Với Người Dùng: Giao diện dễ sử dụng để kiểm tra cập nhật thời tiết.
- Đa Nền Tảng: Có thể xây dựng cho cả thiết bị Android và iOS (beta).

## Bắt Đầu
- Yêu Cầu Cơ Bản
- Flutter SDK
- Dart SDK: Được bao gồm với Flutter
- Android Studio 

## Cài Đặt
Bước 1:
```bash
git clone https://github.com/ItsNgocNhan/Weather-App
cd flutter-Weather-App
```
Bước 2:
```bash
flutter pub get
```
Bước 3:
```bash
Thêm API KEY trong trường hợp API KEY có sẵn bị hết hạn
```
Bước 4:
```bash
flutter run
```

## Cấu Trúc Dự Án
```bash
flutter-weather-forecast/
├── android
├── assets
│   ├── sunny.json
│   ├── rainy.json
│   └── cloudy.json
├── build
├── ios
├── lib
│   ├── main.dart
│   ├── weather_animation.dart
├── pubspec.yaml
└── README.md
```

## Sử Dụng

Màn Hình Chính: Hiển thị thời tiết hiện tại với nền động.
Hình Ảnh Động Thời Tiết: Hiển thị các hình ảnh động khác nhau dựa trên điều kiện thời tiết.

## Đóng Góp
Mọi đóng góp đều được hoan nghênh! Vui lòng làm theo các bước sau:
```bash
-1. Fork repository.
-2. Tạo một nhánh mới (git checkout -b feature/your-feature).
-3. Thực hiện các thay đổi và commit (git commit -m 'Add new feature').
-4. Đẩy lên nhánh (git push origin feature/your-feature).
-5. Tạo một Pull Request mới.
```

## Lời Cảm Ơn
[![Flutter](https://flutter.dev/))
[![Weather API: OpenWeatherMap](https://openweathermap.org/)))

## Liên Hệ
Đối với mọi thắc mắc hoặc vấn đề, vui lòng liên hệ vongocnhan1334@gmail.com
