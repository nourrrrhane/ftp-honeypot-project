
#!/bin/bash
echo "Starting vsftpd 2.3.4 honeypot with backdoor..."

# Start the backdoor FIRST (important!)
python3 /honeypot/fake_exploit.py &
BACKDOOR_PID=$!

# Start vsftpd
/usr/sbin/vsftpd /etc/vsftpd.conf &
FTP_PID=$!
echo "┌──────────────────────────────────────────────┐"
echo "│          FTP Honeypot - Active              │"
echo "├──────────────────────────────────────────────┤"
echo "│ • Service: vsftpd 2.3.4 vulnerability sim   │"
echo "│ • Ports: 21 (FTP), 6200 (Backdoor listener) │"
echo "│ • Logging: /var/log/honeypot_backdoor.log   │"
echo "│ • Purpose: Educational attack simulation    │"
echo "└──────────────────────────────────────────────┘"


trap 'kill $BACKDOOR_PID $FTP_PID; exit' INT
wait
