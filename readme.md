Host and Port Scanning
It is essential to understand how the tool we use works and how it performs and processes the different functions. We will only understand the results if we know what they mean and how they are obtained. Therefore we will take a closer look at and analyze some of the scanning methods. After we have found out that our target is alive, we want to get a more accurate picture of the system. The information we need includes:

Open ports and its services
Service versions
Information that the services provided
Operating system
There are a total of 6 different states for a scanned port we can obtain:

Discovering Open TCP Ports
By default, Nmap scans the top 1000 TCP ports with the SYN scan (-sS). This SYN scan is set only to default when we run it as root because of the socket permissions required to create raw TCP packets. Otherwise, the TCP scan (-sT) is performed by default. This means that if we do not define ports and scanning methods, these parameters are set automatically. We can define the ports one by one (-p 22,25,80,139,445), by range (-p 22-445), by top ports (--top-ports=10) from the Nmap database that have been signed as most frequent, by scanning all ports (-p-) but also by defining a fast port scan, which contains top 100 ports (-F).

Scanning Top 10 TCP Ports
________________________________________
doctor@yb24:~$ sudo nmap 172.25.0.10 --top-ports=10 
[sudo] password for doctor: 
Starting Nmap 7.94SVN ( https://nmap.org ) at 2025-10-29 14:05 UTC
Nmap scan report for 172.25.0.10
Host is up (0.0025s latency).

PORT     STATE    SERVICE
21/tcp   closed   ftp
22/tcp   open     ssh
23/tcp   closed   telnet
25/tcp   open     smtp
80/tcp   open     http
110/tcp  open     pop3
139/tcp  filtered netbios-ssn
443/tcp  open     https
445/tcp  open     microsoft-ds
3389/tcp closed   ms-wbt-server
MAC Address: DE:AD:00:00:BE:EF (Unknown)

Nmap done: 1 IP address (1 host up) scanned in 2.87 seconds
__________________________________________________________________________________________________________
Scanning Options	                     Description
____________________________________________________________________________________________
 172.25.0.10                          Scans the specified target.
--top-ports=10	                      Scans the specified top ports that have been defined as most frequent.

We see that we only scanned the top 10 TCP ports of our target, and Nmap displays their state accordingly. If we trace the packets Nmap sends, we will see the RST flag on TCP port 21 that our target sends back to us. To have a clear view of the SYN scan, we disable the ICMP echo requests (-Pn), DNS resolution (-n), and ARP ping scan (--disable-arp-ping).

Nmap - Trace the Packets
______________________________________
doctor@yb24:~$ sudo nmap 172.25.0.10 -p 21 --packet-trace -Pn -n --disable-arp-ping
Starting Nmap 7.94SVN ( https://nmap.org ) at 2025-10-29 14:06 UTC
SENT (0.2499s) TCP 172.25.0.1:65127 > 172.25.0.10:21 S ttl=59 id=38321 iplen=44  seq=3279059433 win=1024 <mss 1460>
RCVD (0.2496s) TCP 172.25.0.10:21 > 172.25.0.1:65127 RA ttl=64 id=0 iplen=40  seq=0 win=0 
Nmap scan report for 172.25.0.10
Host is up (0.0031s latency).

PORT   STATE  SERVICE
21/tcp closed ftp
MAC Address: DE:AD:00:00:BE:EF (Unknown)

Nmap done: 1 IP address (1 host up) scanned in 0.67 seconds
_________________________________________________________________________________________________
Scanning Options	                          Description
_________________________________________________________________________________________________
 172.25.0.10 	                       Scans the specified target.
-p 21	                               Scans only the specified port.
--packet-trace	                       Shows all packets sent and received.
-n	                                   Disables DNS resolution.
--disable-arp-ping	                   Disables ARP ping.
We can see from the SENT line that we (10.10.14.2) sent a TCP packet with the SYN flag (S) to our target (10.129.2.28). In the next RCVD line, we can see that the target responds with a TCP packet containing the RST and ACK flags (RA). RST and ACK flags are used to acknowledge receipt of the TCP packet (ACK) and to end the TCP session (RST).
____________________________________________________________________________________________________________________________________________________
Request
__________________________________________________________________________________________________________________________
Message                                       	Description
___________________________________________________________________________________________________________________
SENT (0.0429s)                      	Indicates the SENT operation of Nmap, which sends a packet to the target.
TCP                                 	Shows the protocol that is being used to interact with the target port.
172.25.0.10:63090 >                 	Represents our IPv4 address and the source port, which will be used by Nmap to send the packets.
172.25.0.10:21	                        Shows the target IPv4 address and the target port.
S	                                     SYN flag of the sent TCP packet.
ttl=56 id=57322 iplen=44                  Additional TCP Header parameters.
seq=1699105818 win=1024 mss 1460	
__________________________________________________________________________________________________________________________________________________
Response
____________________________________________________________________________________________________________________________________
Message	                                                Description
RCVD (0.0573s)	                            Indicates a received packet from the target.
TCP	                                        Shows the protocol that is being used.
10.129.2.28:21 >	                        Represents targets IPv4 address and the source port, which will be used to reply.
10.10.14.2:63090	                        Shows our IPv4 address and the port that will be replied to.
RA                                      	RST and ACK flags of the sent TCP packet.
ttl=64 id=0 iplen=40 seq=0 win=0	        Additional TCP Header parameters.



