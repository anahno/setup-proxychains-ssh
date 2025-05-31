# راه‌اندازی SSH SOCKS Proxy با proxychains-ng روی Ubuntu و macOS

این پروژه شامل اسکریپت‌هایی است که به شما کمک می‌کند به راحتی یک تونل SSH SOCKS5 بسازید و ابزارهایی مثل `npm` و `git` را از طریق proxychains اجرا کنید.

---

## ویژگی‌ها

- نصب خودکار proxychains-ng (یا proxychains برای macOS) در صورت نبود
- اصلاح فایل کانفیگ proxychains
- راه‌اندازی تونل SSH SOCKS5 با درخواست پسورد
- تست اتصال npm و git با proxychains
- پشتیبانی از Ubuntu و macOS

---

## نحوه استفاده

### ۱. کلون کردن پروژه

```bash
git clone https://github.com/username/setup-proxychains-ssh.git
cd setup-proxychains-ssh
```

### ۲. اجرای اسکریپت مناسب سیستم عامل

روی Ubuntu:
```bash
chmod +x setup-proxychains-ssh-ubuntu.sh
./setup-proxychains-ssh-ubuntu.sh
```

روی macOS:
```bash
chmod +x setup-proxychains-ssh-macos.sh
./setup-proxychains-ssh-macos.sh
```

### توضیحات

پس از اجرای اسکریپت و راه‌اندازی تونل، برای اجرای دستورات از `proxychains4` استفاده کنید:
```bash
proxychains4 npm install
proxychains4 git clone https://github.com/...
```

اگر می‌خواهید بدون پسورد تونل SSH بسازید، بهتر است کلید SSH را روی سرور تنظیم کنید.

### توجه

- این اسکریپت‌ها برای سیستم‌های Ubuntu 20.04+ و macOS 10.14+ نوشته شده‌اند.
- اگر خطایی در نصب یا اجرا داشتید، لطفا اطمینان حاصل کنید که دسترسی sudo دارید و اتصال اینترنت برقرار است.

### تغییر آدرس سرور SSH

در هر دو اسکریپت، متغیرهای زیر را با اطلاعات خود جایگزین کنید:
```bash
SSH_USER="root"
SSH_HOST="your.server.ip"
SSH_PORT=22
LOCAL_PORT=10808
```

### لایسنس
MIT License