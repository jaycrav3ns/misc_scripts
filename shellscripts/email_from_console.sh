#!/bin/bash

clear -x

# Detect package manager and set package names
if command -v apt-get &>/dev/null; then
    pkgapp="apt-get"
		mailapp="mailutils"
elif command -v dnf &>/dev/null; then
    pkgapp="dnf"
		mailapp="mailx"
else
    echo "Unsupported package manager."
    exit 1
fi

# Function to check and install missing dependencies
check_dependencies() {
    local deps=("$mailapp" "msmtp")
    local missing_deps=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo "Installing missing dependencies: ${missing_deps[*]}"
        sudo "$pkgapp" install "${missing_deps[@]}"
    fi
}

whiptail --title "MTP configuration" --yesno "Setup msmtp default account for: $USER?" 8 40 10 3>&1 1>&2 2>&3
	if [ $? != 0 ]; then
		exit 0
	fi

if [ -f ~/.msmtprc ]; then
	whiptail --title "File exists" --yesno "Overwrite existing configuration?" 8 42 10 3>&1 1>&2 2>&3
		if [ $? != 0 ]; then
	    echo "Cancelled."
			exit 1
		fi
fi

check_dependencies

case $? in
    0)
        # Prompt user for input
        host_addr=$(whiptail --inputbox "Enter the SMTP server address:" 10 30 3>&1 1>&2 2>&3)
        port_smtp=$(whiptail --inputbox "Enter the SMTP port:" 10 30 3>&1 1>&2 2>&3)
        tls_onoff=$(whiptail --inputbox "Enable TLS? (on/off):" 10 30 3>&1 1>&2 2>&3)
        start_tls=$(whiptail --inputbox "Enable STARTTLS? (on/off):" 10 30 3>&1 1>&2 2>&3)
        auth_type=$(whiptail --inputbox "Authentication type? (plain/login):" 10 30 3>&1 1>&2 2>&3)
        auth_user=$(whiptail --inputbox "SMTP server - Username:" 10 30 3>&1 1>&2 2>&3)
        auth_pass=$(whiptail --passwordbox "SMTP server - Password:" 10 30 3>&1 1>&2 2>&3)
        user_from=$(whiptail --inputbox "Enter 'From' address:" 10 30 3>&1 1>&2 2>&3)

        # Append user input to ~/.msmtprc
        echo "account default" > ~/.msmtprc
        echo "host $host_addr" >> ~/.msmtprc
        echo "port $port_smtp" >> ~/.msmtprc
        echo "tls $tls_onoff" >> ~/.msmtprc
        echo "tls_starttls $start_tls" >> ~/.msmtprc
        echo "auth $auth_type" >> ~/.msmtprc
        echo "user $auth_user" >> ~/.msmtprc
        echo "password $auth_pass" >> ~/.msmtprc
        echo "from $user_from" >> ~/.msmtprc
        echo -e "allow_from_override off\nset_from_header on\nsyslog LOG_MAIL" >> ~/.msmtprc
        ;;
    1)
        echo "Canceled."
        exit 1;;
    255)
        echo "Aborted!"
        exit 255;;
esac

echo "MTP configuration successful."
echo "Location: $USER/.msmtprc"

exit 0
