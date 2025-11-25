#!/bin/bash

# Скрипт для автоматичного встановлення інструментів DevOps
# Docker, Docker Compose, Python 3.9+, Django

set -e

# Перевірка прав доступу
if [ "$EUID" -ne 0 ]; then 
    echo "Будь ласка, запустіть скрипт з sudo: sudo ./install_dev_tools.sh"
    exit 1
fi

echo "Початок встановлення DevOps інструментів..."
echo ""

# Оновлення пакетів
echo "[1/4] Оновлення списку пакетів..."
apt-get update -qq

# Встановлення базових залежностей
echo "[2/4] Встановлення базових залежностей..."
apt-get install -y -qq \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    python3 \
    python3-pip \
    > /dev/null 2>&1

# Встановлення Docker
echo "[3/4] Перевірка та встановлення Docker..."
if command -v docker &> /dev/null; then
    echo "  Docker вже встановлено: $(docker --version)"
else
    # Додавання Docker репозиторію
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null 2>&1
    
    systemctl enable docker > /dev/null 2>&1
    systemctl start docker > /dev/null 2>&1
    
    if [ "$SUDO_USER" ]; then
        usermod -aG docker "$SUDO_USER"
    fi
    
    echo "  Docker встановлено: $(docker --version)"
fi

# Встановлення Docker Compose
if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
    echo "  Docker Compose вже встановлено"
else
    echo "  Docker Compose встановлюється разом з Docker"
fi

# Встановлення Python
echo "[4/4] Перевірка та встановлення Python..."
if command -v python3 &> /dev/null; then
    PYTHON_MINOR=$(python3 -c 'import sys; print(sys.version_info.minor)')
    if [ "$PYTHON_MINOR" -ge 9 ]; then
        echo "  Python вже встановлено: $(python3 --version)"
    else
        apt-get install -y -qq python3 python3-pip > /dev/null 2>&1
        echo "  Python встановлено: $(python3 --version)"
    fi
else
    apt-get install -y -qq python3 python3-pip > /dev/null 2>&1
    echo "  Python встановлено: $(python3 --version)"
fi

# Оновлення pip
python3 -m pip install --upgrade pip > /dev/null 2>&1

# Встановлення Django
echo "Перевірка та встановлення Django..."
if python3 -c "import django" &> /dev/null 2>&1; then
    DJANGO_VERSION=$(python3 -c "import django; print(django.get_version())" 2>/dev/null)
    echo "  Django вже встановлено: версія $DJANGO_VERSION"
else
    pip3 install django > /dev/null 2>&1
    DJANGO_VERSION=$(python3 -c "import django; print(django.get_version())" 2>/dev/null)
    echo "  Django встановлено: версія $DJANGO_VERSION"
fi

echo ""
echo "=========================================="
echo "Встановлення завершено!"
echo "=========================================="
echo ""
echo "Встановлені інструменти:"
echo "  ✓ Docker: $(docker --version)"
if command -v docker-compose &> /dev/null; then
    echo "  ✓ Docker Compose: $(docker-compose --version)"
elif docker compose version &> /dev/null; then
    echo "  ✓ Docker Compose: $(docker compose version)"
fi
echo "  ✓ Python: $(python3 --version)"
echo "  ✓ pip: $(pip3 --version | cut -d' ' -f1-2)"
echo "  ✓ Django: $(python3 -c "import django; print(django.get_version())" 2>/dev/null)"
echo ""
echo "Примітка: Якщо ви запускали скрипт з sudo, вам може знадобитися"
echo "вийти та увійти знову, щоб використовувати Docker без sudo."
