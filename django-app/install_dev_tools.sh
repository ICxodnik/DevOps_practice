#!/usr/bin/env bash
# ------------------------------------------------------------
# встановлення Docker, Docker Compose, Python (≥3.9)
# та Django на Debian/Ubuntu‑подібних системах.
# Запускати з правами sudo:  sudo ./install_dev_tools.sh
# ------------------------------------------------------------
set -euo pipefail

GREEN="\033[1;32m"
BLUE="\033[1;34m"
RESET="\033[0m"

info()    { echo -e "${BLUE}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
command_exists() { command -v "$1" &>/dev/null; }

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "Будь ласка, запустіть скрипт через sudo:  sudo $0"
    exit 1
  fi
}

install_docker() {
  if command_exists docker; then
    success "Docker вже встановлений: $(docker --version)"
  else
    info "Встановлюю Docker…"
    apt-get update
    apt-get install -y ca-certificates curl gnupg lsb-release software-properties-common
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
      tee /etc/apt/sources.list.d/docker.list >/dev/null
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl enable --now docker
    success "Docker встановлено."
  fi
}

install_docker_compose() {
  if docker compose version &>/dev/null; then
    success "Docker Compose вже доступний: $(docker compose version --short)"
  else
    info "Docker Compose встановлюється разом із Docker як плагін."
  fi
}

version_ge() { printf '%s\n%s' "$2" "$1" | sort -C -V; }

install_python() {
  REQUIRED="3.9"
  if command_exists python3; then
    CURRENT=$(python3 -c 'import sys;print(".".join(map(str, sys.version_info[:3])))')
    if version_ge "$CURRENT" "$REQUIRED"; then
      success "Python $CURRENT вже >= $REQUIRED — ок."
      return
    else
      info "Python $CURRENT < $REQUIRED — оновлюю."
    fi
  else
    info "Python не знайдено — встановлюю."
  fi

  add-apt-repository -y ppa:deadsnakes/ppa
  apt-get update
  apt-get install -y python3.10 python3.10-venv python3.10-distutils python3-pip
  ln -sf /usr/bin/python3.10 /usr/local/bin/python3
  success "Python $(python3 --version) встановлено."
}

install_django() {
  if python3 -m django --version &>/dev/null; then
    success "Django вже встановлений: $(python3 -m django --version)"
  else
    info "Встановлюю Django…"
    pip3 install --user --upgrade pip
    pip3 install --user Django
    success "Django $(python3 -m django --version) встановлено."
  fi
}

main() {
  require_root
  install_docker
  install_docker_compose
  install_python
  install_django
  success "Усі інструменти готові!"
}

main "$@"

