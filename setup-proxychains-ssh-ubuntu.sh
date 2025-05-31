#!/bin/bash

SSH_USER="root"
SSH_HOST="your.server.ip"   # <-- آدرس سرور را اینجا وارد کنید
SSH_PORT=22
LOCAL_PORT=10808
PROXYCHAINS_CONF_PATH="/etc/proxychains.conf"

ask_yes_no() {
  while true; do
    read -rp "$1 [yes/no]: " yn
    case $yn in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) echo "لطفا فقط 'yes' یا 'no' وارد کنید.";;
    esac
  done
}

echo "🚀 شروع اسکریپت راه‌اندازی پروکسی و SSH SOCKS برای اوبونتو..."

if ! sudo -v >/dev/null 2>&1; then
  echo "❌ شما باید دسترسی sudo داشته باشید."
  exit 1
fi

if ! command -v proxychains4 &> /dev/null; then
  echo "❌ proxychains-ng نصب نیست."
  if ask_yes_no "می‌خواهید proxychains-ng نصب شود؟ (نیاز به اینترنت و چند دقیقه زمان دارد)"; then
    sudo apt update
    sudo apt install -y proxychains4
    if [ $? -ne 0 ]; then
      echo "❌ نصب proxychains-ng با خطا مواجه شد."
      exit 1
    fi
    echo "✅ proxychains-ng نصب شد."
  else
    echo "🚫 proxychains-ng نصب نشد. اسکریپت متوقف می‌شود."
    exit 1
  fi
else
  echo "✅ proxychains-ng نصب است."
fi

echo "⚙️ بررسی کانفیگ proxychains در $PROXYCHAINS_CONF_PATH..."

if ! grep -q "socks5  127.0.0.1 $LOCAL_PORT" "$PROXYCHAINS_CONF_PATH" 2>/dev/null; then
  echo "⚠️ کانفیگ proxychains کامل نیست، در حال اصلاح..."
  sudo tee "$PROXYCHAINS_CONF_PATH" > /dev/null <<EOL
# proxychains.conf
strict_chain
proxy_dns
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000

[ProxyList]
socks5  127.0.0.1 $LOCAL_PORT
EOL
  echo "✅ کانفیگ proxychains اصلاح شد."
else
  echo "✅ کانفیگ proxychains قبلاً تنظیم شده بود."
fi

if lsof -i tcp:$LOCAL_PORT >/dev/null 2>&1; then
  echo "🔌 تونل SOCKS proxy روی پورت $LOCAL_PORT از قبل راه‌اندازی شده."
else
  echo "🔐 در حال راه‌اندازی تونل SSH روی پورت $LOCAL_PORT ..."
  ssh -D $LOCAL_PORT -f -C -q -N -p $SSH_PORT $SSH_USER@$SSH_HOST
  if [ $? -ne 0 ]; then
    echo "❌ اتصال SSH برقرار نشد! لطفاً مشخصات را بررسی کنید."
    exit 1
  fi
  echo "✅ تونل SSH SOCKS proxy راه‌اندازی شد."
fi

echo "🚀 تست دستور npm با proxychains:"
proxychains4 npm view react version

echo "🚀 تست دستور git clone با proxych Chains:"
proxychains4 git clone --depth=1 https://github.com/vercel/next.js.git test-next

echo "✅ همه چیز باید الان با proxychains و SSH SOCKS proxy به خوبی کار کند."

echo "🎉 برای اجرای دستورات با پروکسی، از 'proxychains4' استفاده کنید."
echo "مثال: proxychains4 npm install"