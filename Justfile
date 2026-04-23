build:
    cargo build --release --features "full"

install: build
    sudo make install TARGET=release

upload: build
    scp target/release/sslocal \
        target/release/ssserver \
        target/release/ssurl \
        target/release/ssmanager \
        target/release/ssservice \
        movon@$ALIYUN_HOST:~/rsocks/target/release/

genkey:
    ssservice genkey -m "2022-blake3-aes-256-gcm"

# Create a systemd service for ssserver/sslocal
# Usage: just install-service [name]
# Example: just install-service ssserver
install-service name="ssserver" :
    #!/usr/bin/env bash
    set -e
    service_name="{{name}}"
    service_file="/etc/systemd/system/${service_name}.service"
    config_path="/etc/rsocks/${service_name}-config.json"
    
    echo "Creating sample config file at ${config_path}"
    sudo mkdir -p "$(dirname ${config_path})"
    case "${service_name}" in
        sslocal)
            printf '%s\n' \
                '{' \
                '    "server": "localhost",' \
                '    "server_port": 18080,' \
                '    "password": "PASSWORD",' \
                '    "method": "2022-blake3-aes-256-gcm",' \
                '    "transport_xor_key": "KEY"' \
                '    "local_address": "localhost",' \
                '    "local_port": 1080' \
                '}' > /tmp/config.tmp
            ;;
        ssserver)
            printf '%s\n' \
                '{' \
                '    "server": "localhost",' \
                '    "server_port": 18080,' \
                '    "password": "PASSWORD",' \
                '    "method": "2022-blake3-aes-256-gcm",' \
                '    "transport_xor_key": "KEY",' \
                '}' > /tmp/config.tmp
            ;;
        *)
            echo "Error: name must be either ssserver or sslocal"
            exit 1
            ;;
    esac
    sudo mv /tmp/config.tmp "${config_path}"
    
    echo "Creating systemd service for: ${service_name}"
    printf '%s\n' \
        '[Unit]' \
        'Description=RSocks Service' \
        'After=network.target' \
        '' \
        '[Service]' \
        'Type=simple' \
        'DynamicUser=yes' \
        "ExecStart=/usr/local/bin/${service_name} -c ${config_path}" \
        'Restart=on-failure' \
        'RestartSec=5' \
        '' \
        '[Install]' \
        'WantedBy=multi-user.target' > /tmp/${service_name}.service.tmp
    sudo mv /tmp/${service_name}.service.tmp "${service_file}"
    sudo systemctl daemon-reload
    echo "✓ Systemd service created at ${service_file}"
    echo "Enable with: sudo systemctl enable ${service_name}"
    echo "Start with: sudo systemctl start ${service_name}"
    echo ""
    echo "Check status with: sudo systemctl status ${service_name}"
    echo "View logs with: journalctl -u ${service_name} -f"