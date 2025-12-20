FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install vsftpd and tools
RUN apt update && apt install -y \
    vsftpd \
    python3 \
    python3-pip \
    net-tools \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 2. Create fake user and files
RUN useradd -m -s /bin/bash ftpuser \
    && echo "ftpuser:password123" | chpasswd \
    && mkdir -p /var/ftp/pub /home/ftpuser/files \
    && mkdir -p /var/run/vsftpd/empty

# 3. Configure vsftpd to look old and weak - ONE SINGLE ECHO COMMAND
RUN echo 'listen=YES\n\
anonymous_enable=YES\n\
local_enable=YES\n\
write_enable=YES\n\
local_umask=022\n\
dirmessage_enable=YES\n\
use_localtime=YES\n\
xferlog_enable=YES\n\
connect_from_port_20=YES\n\
chroot_local_user=YES\n\
allow_writeable_chroot=YES\n\
secure_chroot_dir=/var/run/vsftpd/empty\n\
pam_service_name=vsftpd\n\
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem\n\
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key\n\
ssl_enable=NO\n\
hide_ids=YES\n\
pasv_min_port=40000\n\
pasv_max_port=50000\n\
# CRITICAL: Fake the version to attract hackers\n\
ftpd_banner=220 (vsFTPd 2.3.4)\n\
# Weak configuration for honeypot\n\
seccomp_sandbox=NO\n\
require_cert=NO\n\
validate_cert=NO\n\
# Passive mode fixes\n\
pasv_enable=YES\n\
pasv_min_port=30000\n\
pasv_max_port=31000\n\
pasv_address=127.0.0.1' > /etc/vsftpd.conf

# 4. Install lftp for testing
RUN apt update && apt install -y lftp && rm -rf /var/lib/apt/lists/*

# 5. Create bait files
RUN echo "FTP Server Internal Backup\nIP: 192.168.1.100\nSSH Port: 22\nUser: admin\nTemp Pass: P@ssw0rd2024!" > /var/ftp/pub/README.txt \
    && echo "database backup 2024" > /var/ftp/pub/db_backup.sql \
    && echo "config files" > /home/ftpuser/server_config.tar

WORKDIR /honeypot

# 6. Copy Python scripts - MAKE SURE fake_exploit.py EXISTS in your project folder!
COPY fake_exploit.py /honeypot/
COPY start.sh /honeypot/

RUN chmod +x /honeypot/start.sh

EXPOSE 21 2121 6200

CMD ["/bin/bash", "/honeypot/start.sh"]
