#mkdir ftp-honeypot-project
#cd ftp-honeypot-project
#git clone https://github.com/nourrrrhane/ftp-honeypot-project.git
#ls (u should see 3 files)

# terminal 1 :
#Build the Docker image
docker build -t ftp-honeypot .

#!!!you should see no errors!!!           

#Run the container
docker run -it --rm -p 21:21 -p 6200:6200 --name honeypot ftp-honeypot


# terminal 2:
#Test with Metasploit
msfconsole -q
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS 127.0.0.1
run
