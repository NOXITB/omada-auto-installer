#!/bin/bash
#title           : install.sh
#description     :Installer for TP-Link Omada Software Controller
#supported       :Ubuntu 16.04, 18.04, 20.04, 22.04; Debian 9, 10, 11; CentOS 7, 8
#author          :noxitb-blake
#date            :27-05-2024
#updated         :27-05-2024

echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Omada auto installler"
echo "https://github.com/NOXITB/omada-auto-installer"
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"

echo "[+] Verifying running as root"
if [ "$(id -u)" -ne 0 ]; then
    echo -e "\e[1;31m[!] Script requires to be run as root. Please rerun using sudo. \e[0m"
    exit 1
fi

echo "[+] Verifying supported OS"
OS=$(hostnamectl status | grep "Operating System" | sed 's/^[ \t]*//')
echo "[~] $OS"

# Determine the OS and version
if [[ $OS == *"Ubuntu 16.04"* ]]; then
    OsVer=xenial
    OsType=ubuntu
elif [[ $OS == *"Ubuntu 18.04"* ]]; then
    OsVer=bionic
    OsType=ubuntu
elif [[ $OS == *"Ubuntu 20.04"* ]]; then
    OsVer=focal
    OsType=ubuntu
elif [[ $OS == *"Ubuntu 22.04"* ]]; then
    OsVer=focal  # MongoDB 4.4 is not officially supported on 22.04
    OsType=ubuntu
    echo "[+] Installing libssl 1.1 package for Ubuntu 22.04"
    wget -qP /tmp/ http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
    dpkg -i /tmp/libssl1.1_1.1.1f-1ubuntu2_amd64.deb &> /dev/null
elif [[ $OS == *"Debian GNU/Linux 9"* ]]; then
    OsVer=stretch
    OsType=debian
elif [[ $OS == *"Debian GNU/Linux 10"* ]]; then
    OsVer=buster
    OsType=debian
elif [[ $OS == *"Debian GNU/Linux 11"* ]]; then
    OsVer=bullseye
    OsType=debian
elif [[ $OS == *"CentOS Linux 7"* ]]; then
    OsVer=7
    OsType=centos
elif [[ $OS == *"CentOS Linux 8"* ]]; then
    OsVer=8
    OsType=centos
else
    echo -e "\e[1;31m[!] This script only supports Ubuntu 16.04, 18.04, 20.04, 22.04; Debian 9, 10, 11; CentOS 7, 8! \e[0m"
    exit 1
fi

echo "[+] Installing script prerequisites"
if [[ $OsType == "ubuntu" || $OsType == "debian" ]]; then
    apt-get -qq update
    apt-get -qq install gnupg curl wget &> /dev/null
elif [[ $OsType == "centos" ]]; then
    yum -q install -y gnupg curl wget &> /dev/null
fi

if [[ $OsType == "ubuntu" || $OsType == "debian" ]]; then
    echo "[+] Importing the MongoDB 4.4 PGP key and creating APT repository"
    curl -fsSL https://pgp.mongodb.com/server-4.4.asc | gpg -o /usr/share/keyrings/mongodb-server-4.4.gpg --dearmor
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-4.4.gpg ] https://repo.mongodb.org/apt/${OsType} $OsVer/mongodb-org/4.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.4.list

    echo "[+] Installing MongoDB 4.4"
    apt-get -qq update
    apt-get -qq install mongodb-org &> /dev/null
    echo "[+] Installing OpenJDK 8 JRE (headless)"
    apt-get -qq install openjdk-8-jre-headless &> /dev/null
    echo "[+] Installing JSVC"
    apt-get -qq install jsvc &> /dev/null
elif [[ $OsType == "centos" ]]; then
    echo "[+] Adding MongoDB repository"
    cat <<EOF > /etc/yum.repos.d/mongodb-org-4.4.repo
[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOF

    echo "[+] Installing MongoDB 4.4"
    yum -q install -y mongodb-org &> /dev/null
    echo "[+] Installing OpenJDK 8 JRE (headless)"
    yum -q install -y java-1.8.0-openjdk-headless &> /dev/null
    echo "[+] Installing JSVC"
    yum -q install -y jsvc &> /dev/null
fi

echo "[+] Downloading the latest Omada Software Controller package"
OmadaPackageUrl=$(curl -fsSL https://www.tp-link.com/us/support/download/omada-software-controller/ | grep -oPi '<a[^>]*href="\K[^"]*Linux_x64.deb[^"]*' | head -n 1)
wget -qP /tmp/ $OmadaPackageUrl

echo "[+] Installing Omada Software Controller"
if [[ $OsType == "ubuntu" || $OsType == "debian" ]]; then
    dpkg -i /tmp/$(basename $OmadaPackageUrl) &> /dev/null
elif [[ $OsType == "centos" ]]; then
    rpm -Uvh /tmp/$(basename $OmadaPackageUrl) &> /dev/null
fi

hostIP=$(hostname -I | cut -f1 -d' ')
echo -e "\e[0;32m[~] Omada Software Controller has been successfully installed! :)\e[0m"
echo -e "\e[0;32m[~] Please visit https://${hostIP}:8043 to complete the initial setup wizard.\e[0m\n"
