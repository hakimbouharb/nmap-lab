// Module content definitions
const modules = {
    'welcome': {
        title: 'Welcome to Nmap Training Platform',
        content: `
            <div class="welcome-section">
                <h2>Welcome, <span id="welcomeName">Student</span>! 👋</h2>
                <p>Begin your journey in mastering network reconnaissance and port scanning.</p>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Modules Completed</div>
                    <div class="stat-value" id="modulesCompleted">0/11</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Current Progress</div>
                    <div class="stat-value" id="currentProgress">0%</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Labs Completed</div>
                    <div class="stat-value" id="labsCompleted">0/3</div>
                </div>
            </div>

            <div class="module-content">
                <h2>🎯 About This Platform</h2>
                <p>This comprehensive training platform will guide you through the essential skills of network reconnaissance using Nmap, the industry-standard tool for security professionals.</p>

                <h3>What You'll Learn:</h3>
                <ul>
                    <li><strong>Host Discovery:</strong> Identify active systems on a network</li>
                    <li><strong>Port Scanning:</strong> Discover open ports and services</li>
                    <li><strong>Service Enumeration:</strong> Determine versions and configurations</li>
                    <li><strong>NSE Scripts:</strong> Leverage powerful Nmap scripting capabilities</li>
                    <li><strong>Firewall Evasion:</strong> Bypass security controls ethically</li>
                    <li><strong>Practical Labs:</strong> Apply skills in realistic scenarios</li>
                </ul>

                <div class="info-box">
                    <h4>💡 Learning Path</h4>
                    <p>This course follows a structured progression from basics to advanced techniques. Complete each module in order for the best learning experience. Use the "Complete" button at the end of each section to track your progress and move forward.</p>
                </div>

                <h3>How to Use This Platform:</h3>
                <ol>
                    <li>Navigate through modules using the sidebar on the right</li>
                    <li>Read and understand each concept thoroughly</li>
                    <li>Practice commands in your own environment or our labs</li>
                    <li>Click "Complete" at the end of each module to move forward</li>
                    <li>Track your progress in the sidebar</li>
                </ol>

                <div class="success-box">
                    <h4>✨ Ready to Start?</h4>
                    <p>Click the "Complete & Next" button below to begin your first module: Enumeration Basics!</p>
                </div>
            </div>
        `,
        next: 'enumeration'
    },

    'enumeration': {
        title: 'Enumeration Basics',
        content: `
            <div class="module-content">
                <h2>📚 Enumeration Fundamentals</h2>
                <p>Enumeration is the systematic process of gathering information about target systems. It forms the foundation of network reconnaissance and security assessment.</p>

                <h3>What is Enumeration?</h3>
                <p>Enumeration involves actively querying target systems to extract useful information such as:</p>
                <ul>
                    <li>Active hosts on a network</li>
                    <li>Open ports and services</li>
                    <li>Operating system details</li>
                    <li>Network topology and architecture</li>
                    <li>User accounts and shares</li>
                </ul>

                <h3>Why Enumeration Matters</h3>
                <p>Proper enumeration is critical for:</p>
                <ul>
                    <li><strong>Security Assessments:</strong> Identifying vulnerabilities before attackers do</li>
                    <li><strong>Network Mapping:</strong> Understanding your infrastructure</li>
                    <li><strong>Incident Response:</strong> Quickly assessing compromised systems</li>
                    <li><strong>Compliance:</strong> Meeting security audit requirements</li>
                </ul>

                <div class="warning-box">
                    <h4>⚠️ Legal and Ethical Considerations</h4>
                    <p><strong>IMPORTANT:</strong> Only perform enumeration on systems you own or have explicit written permission to test. Unauthorized scanning is illegal and unethical.</p>
                    <ul>
                        <li>Always obtain proper authorization</li>
                        <li>Document your scope of work</li>
                        <li>Respect privacy and data protection laws</li>
                        <li>Report findings responsibly</li>
                    </ul>
                </div>

                <h3>Enumeration Methodologies</h3>
                <p>There are several approaches to enumeration:</p>
                
                <p><strong>1. Passive Enumeration:</strong><br>
                Gathering information without directly interacting with target systems. Examples include:</p>
                <ul>
                    <li>OSINT (Open Source Intelligence)</li>
                    <li>DNS lookups</li>
                    <li>WHOIS queries</li>
                    <li>Social media reconnaissance</li>
                </ul>

                <p><strong>2. Active Enumeration:</strong><br>
                Direct interaction with target systems. This is what Nmap excels at:</p>
                <ul>
                    <li>Port scanning</li>
                    <li>Service fingerprinting</li>
                    <li>OS detection</li>
                    <li>Vulnerability scanning</li>
                </ul>

                <div class="info-box">
                    <h4>🎯 Next Steps</h4>
                    <p>Now that you understand the fundamentals of enumeration, you're ready to dive into Nmap - the most powerful tool for active network enumeration. Click "Complete & Next" to continue!</p>
                </div>
            </div>
        `,
        prev: 'welcome',
        next: 'nmap-intro'
    },

    'nmap-intro': {
        title: 'Introduction to Nmap',
        content: `
            <div class="module-content">
                <h2>🔍 Introduction to Nmap</h2>
                <p>Nmap (Network Mapper) is a free, open-source tool for network discovery and security auditing. It has become the de facto standard for security professionals worldwide.</p>

                <h3>What is Nmap?</h3>
                <p>Nmap was created by Gordon Lyon (Fyodor) in 1997 and has grown to become one of the most essential tools in cybersecurity. It can:</p>
                <ul>
                    <li>Discover hosts on a network</li>
                    <li>Identify open ports</li>
                    <li>Detect running services and their versions</li>
                    <li>Determine operating systems</li>
                    <li>Execute custom scripts for advanced detection</li>
                </ul>

                <h3>Why Use Nmap?</h3>
                <ul>
                    <li><strong>Industry Standard:</strong> Used by professionals globally</li>
                    <li><strong>Powerful:</strong> Comprehensive scanning capabilities</li>
                    <li><strong>Flexible:</strong> Hundreds of options and scan types</li>
                    <li><strong>Scriptable:</strong> NSE (Nmap Scripting Engine) for custom tasks</li>
                    <li><strong>Cross-platform:</strong> Works on Windows, Linux, Mac</li>
                    <li><strong>Free:</strong> Open source with active development</li>
                </ul>

                <h3>Basic Nmap Syntax</h3>
                <p>The basic syntax of Nmap is straightforward:</p>
                <div class="info-box">
                    <code>nmap [Scan Type] [Options] {target specification}</code>
                </div>

                <h3>Simple Examples</h3>
                <p><strong>Scan a single IP:</strong></p>
                <code>nmap 192.168.1.1</code>
                
                <p><strong>Scan a subnet:</strong></p>
                <code>nmap 192.168.1.0/24</code>
                
                <p><strong>Scan specific ports:</strong></p>
                <code>nmap -p 80,443 192.168.1.1</code>

                <p><strong>Scan with service detection:</strong></p>
                <code>nmap -sV 192.168.1.1</code>

                <div class="warning-box">
                    <h4>⚠️ Performance Note</h4>
                    <p>Nmap can be very "loud" on a network. Always consider the impact of your scans:</p>
                    <ul>
                        <li>Scans can trigger IDS/IPS alerts</li>
                        <li>Aggressive scans may impact network performance</li>
                        <li>Some scan types require root/administrator privileges</li>
                        <li>Always scan during approved maintenance windows when possible</li>
                    </ul>
                </div>

                <h3>Nmap Output Formats</h3>
                <p>Nmap can output results in multiple formats:</p>
                <ul>
                    <li><strong>Normal:</strong> Human-readable (default)</li>
                    <li><strong>XML:</strong> Machine-parseable (<code>-oX</code>)</li>
                    <li><strong>Grepable:</strong> Easy to parse with grep (<code>-oG</code>)</li>
                    <li><strong>All formats:</strong> Save all three (<code>-oA</code>)</li>
                </ul>

                <div class="success-box">
                    <h4>✨ Ready for Hands-On?</h4>
                    <p>You now understand what Nmap is and its basic syntax. Next, we'll dive into host discovery techniques to find active systems on a network. Click "Complete & Next" when you're ready!</p>
                </div>
            </div>
        `,
        prev: 'enumeration',
        next: 'host-discovery'
    },

    'host-discovery': {
        title: 'Host Discovery',
        content: `
            <div class="module-content">
                <h2>🎯 Host Discovery Techniques</h2>
                <p>Before scanning ports, you need to identify which hosts are active on the network. Nmap provides multiple techniques for host discovery.</p>

                <h3>Why Host Discovery?</h3>
                <p>Host discovery helps you:</p>
                <ul>
                    <li>Identify live systems before detailed scanning</li>
                    <li>Map network topology</li>
                    <li>Save time by avoiding dead hosts</li>
                    <li>Reduce network noise</li>
                </ul>

                <h3>Common Discovery Techniques</h3>

                <p><strong>1. Ping Scan (ICMP Echo):</strong></p>
                <code>nmap -sn 192.168.1.0/24</code>
                <p>Sends ICMP echo requests. Fast but may be blocked by firewalls.</p>

                <p><strong>2. TCP SYN Ping:</strong></p>
                <code>nmap -PS 192.168.1.0/24</code>
                <p>Sends TCP SYN packets. More reliable than ICMP as it mimics legitimate traffic.</p>

                <p><strong>3. TCP ACK Ping:</strong></p>
                <code>nmap -PA 192.168.1.0/24</code>
                <p>Sends TCP ACK packets. Can bypass some stateless firewalls.</p>

                <p><strong>4. UDP Ping:</strong></p>
                <code>nmap -PU 192.168.1.0/24</code>
                <p>Sends UDP packets. Useful when TCP is heavily filtered.</p>

                <p><strong>5. ARP Scan (Local Network):</strong></p>
                <code>nmap -PR 192.168.1.0/24</code>
                <p>Uses ARP requests. Most reliable for local networks but limited to same subnet.</p>

                <div class="info-box">
                    <h4>💡 Pro Tip: Combining Methods</h4>
                    <p>You can combine multiple discovery methods for better coverage:</p>
                    <code>nmap -PS -PA -PU 192.168.1.0/24</code>
                    <p>This sends TCP SYN, TCP ACK, and UDP pings simultaneously.</p>
                </div>

                <h3>Disabling Host Discovery</h3>
                <p>Sometimes you want to skip host discovery and scan all targets:</p>
                <code>nmap -Pn 192.168.1.1</code>
                <p>The <code>-Pn</code> flag treats all hosts as online. Useful when ICMP is blocked.</p>

                <h3>Practical Example</h3>
                <p>Let's discover hosts on our target network:</p>
                <code>nmap -sn -PE -PS22,80,443 -PA80,443 172.25.0.0/16</code>
                <p>This scan uses:</p>
                <ul>
                    <li><code>-sn</code>: No port scan (discovery only)</li>
                    <li><code>-PE</code>: ICMP echo request</li>
                    <li><code>-PS22,80,443</code>: TCP SYN ping on common ports</li>
                    <li><code>-PA80,443</code>: TCP ACK ping on web ports</li>
                </ul>

                <div class="warning-box">
                    <h4>⚠️ Firewall Considerations</h4>
                    <p>Modern firewalls often block ICMP and unexpected TCP packets. If discovery fails:</p>
                    <ul>
                        <li>Try different ping types</li>
                        <li>Target commonly allowed ports (80, 443)</li>
                        <li>Use <code>-Pn</code> to skip discovery if you know hosts are up</li>
                        <li>Consider using <code>--reason</code> to understand why hosts appear down</li>
                    </ul>
                </div>

                <h3>Reading Discovery Results</h3>
                <p>Nmap will report:</p>
                <ul>
                    <li><strong>Host is up:</strong> Responded to discovery probes</li>
                    <li><strong>Host seems down:</strong> No response (but may still be up)</li>
                    <li><strong>Latency:</strong> Response time in milliseconds</li>
                    <li><strong>MAC address:</strong> If scanning local network</li>
                </ul>

                <div class="success-box">
                    <h4>✨ Next: Port Scanning</h4>
                    <p>Now that you can discover active hosts, you're ready to learn about port scanning techniques. Click "Complete & Next" to continue!</p>
                </div>
            </div>
        `,
        prev: 'nmap-intro',
        next: 'port-scanning'
    },

    'port-scanning': {
        title: 'Port Scanning Techniques',
        content: `
            <div class="module-content">
                <h2>🔌 Port Scanning Mastery</h2>
                <p>Port scanning is the process of probing target systems to determine which network ports are open, closed, or filtered. This is one of Nmap's core capabilities.</p>

                <h3>Understanding Port States</h3>
                <p>Nmap categorizes ports into six states:</p>
                <ul>
                    <li><strong>Open:</strong> Application is accepting connections</li>
                    <li><strong>Closed:</strong> No application listening, but port is accessible</li>
                    <li><strong>Filtered:</strong> Firewall or filter blocking probe</li>
                    <li><strong>Unfiltered:</strong> Accessible but state unclear (rare)</li>
                    <li><strong>Open|Filtered:</strong> Can't determine if open or filtered</li>
                    <li><strong>Closed|Filtered:</strong> Can't determine if closed or filtered</li>
                </ul>

                <h3>Common Scan Types</h3>

                <p><strong>1. TCP Connect Scan (-sT):</strong></p>
                <code>nmap -sT 192.168.1.1</code>
                <p>Completes full TCP three-way handshake. Doesn't require root privileges but is easily detected.</p>

                <p><strong>2. TCP SYN Scan (-sS) [STEALTH]:</strong></p>
                <code>nmap -sS 192.168.1.1</code>
                <p>Sends SYN, waits for SYN-ACK, then sends RST. Faster and stealthier than connect scan. <strong>Requires root/admin privileges.</strong></p>

                <p><strong>3. UDP Scan (-sU):</strong></p>
                <code>nmap -sU 192.168.1.1</code>
                <p>Scans UDP ports. Slower than TCP but important for services like DNS, SNMP, DHCP.</p>

                <p><strong>4. TCP FIN Scan (-sF):</strong></p>
                <code>nmap -sF 192.168.1.1</code>
                <p>Sends FIN packet. Can bypass some simple firewalls. No response = open|filtered.</p>

                <p><strong>5. TCP Null Scan (-sN):</strong></p>
                <code>nmap -sN 192.168.1.1</code>
                <p>Sends packet with no flags set. Stealthy but doesn't work against Windows targets.</p>

                <p><strong>6. TCP Xmas Scan (-sX):</strong></p>
                <code>nmap -sX 192.168.1.1</code>
                <p>Sends packet with FIN, PSH, and URG flags. Called "Xmas" because flags light up like a Christmas tree.</p>

                <div class="info-box">
                    <h4>💡 Default Scan</h4>
                    <p>If you don't specify a scan type, Nmap uses <code>-sS</code> (SYN scan) if you have privileges, otherwise <code>-sT</code> (Connect scan).</p>
                </div>

                <h3>Port Specification</h3>
                <p>Control which ports to scan:</p>
                <ul>
                    <li><strong>Single port:</strong> <code>-p 80</code></li>
                    <li><strong>Port list:</strong> <code>-p 22,80,443</code></li>
                    <li><strong>Port range:</strong> <code>-p 1-1000</code></li>
                    <li><strong>All ports:</strong> <code>-p-</code> or <code>-p 1-65535</code></li>
                    <li><strong>Top ports:</strong> <code>--top-ports 100</code></li>
                    <li><strong>Fast scan:</strong> <code>-F</code> (100 most common ports)</li>
                </ul>

                <h3>Practical Examples</h3>

                <p><strong>Quick scan of common ports:</strong></p>
                <code>nmap -F 172.25.0.10</code>

                <p><strong>Comprehensive TCP + UDP scan:</strong></p>
                <code>nmap -sS -sU -p- 172.25.0.10</code>

                <p><strong>Scan specific services:</strong></p>
                <code>nmap -p 80,443,8080,8443 172.25.0.10</code>

                <div class="warning-box">
                    <h4>⚠️ Scan Timing</h4>
                    <p>UDP scans are slow! A full 65,535 port UDP scan can take hours. Consider:</p>
                    <ul>
                        <li>Scan only important UDP ports: <code>-p U:53,161,162,500</code></li>
                        <li>Use timing templates: <code>-T4</code> for faster scanning</li>
                        <li>Combine with TCP: <code>-sS -sU -p T:1-1000,U:53,161</code></li>
                    </ul>
                </div>

                <h3>Target Network Scan</h3>
                <p>Let's scan our training target:</p>
                <code>nmap -sS -sU -p T:20-9999,U:137,138,5353 172.25.0.10</code>
                <p>This scans:</p>
                <ul>
                    <li>TCP ports 20-9999 with SYN scan</li>
                    <li>Important UDP ports (NetBIOS, mDNS)</li>
                    <li>Target: 172.25.0.10 (our vulnerable container)</li>
                </ul>

                <div class="success-box">
                    <h4>✨ Next: Service Enumeration</h4>
                    <p>You now know how to discover open ports. Next, we'll learn how to identify the services and versions running on those ports. Click "Complete & Next"!</p>
                </div>
            </div>
        `,
        prev: 'host-discovery',
        next: 'service-enum'
    },

    'service-enum': {
        title: 'Service Enumeration',
        content: `
            <div class="module-content">
                <h2>🔧 Service Enumeration & Version Detection</h2>
                <p>Knowing which ports are open is useful, but knowing what services and versions are running on those ports is crucial for security assessment.</p>

                <h3>Why Version Detection Matters</h3>
                <p>Service version information helps you:</p>
                <ul>
                    <li>Identify vulnerable software versions</li>
                    <li>Understand the target's technology stack</li>
                    <li>Plan further testing strategies</li>
                    <li>Generate accurate vulnerability reports</li>
                </ul>

                <h3>Service Detection (-sV)</h3>
                <p>The <code>-sV</code> flag enables service version detection:</p>
                <code>nmap -sV 172.25.0.10</code>
                <p>Nmap will:</p>
                <ul>
                    <li>Connect to open ports</li>
                    <li>Send probes to identify services</li>
                    <li>Analyze responses using its database</li>
                    <li>Report service name, version, and additional info</li>
                </ul>

                <h3>Version Detection Intensity</h3>
                <p>Control how aggressive version detection is:</p>
                <ul>
                    <li><code>--version-intensity 0</code>: Light probes only</li>
                    <li><code>--version-intensity 5</code>: Default</li>
                    <li><code>--version-intensity 9</code>: All probes (slow but thorough)</li>
                </ul>

                <p><strong>Light version scan:</strong></p>
                <code>nmap -sV --version-light 172.25.0.10</code>

                <p><strong>Aggressive version scan:</strong></p>
                <code>nmap -sV --version-all 172.25.0.10</code>

                <h3>OS Detection (-O)</h3>
                <p>Identify the operating system:</p>
                <code>nmap -O 172.25.0.10</code>
                <p>Nmap analyzes:</p>
                <ul>
                    <li>TCP/IP stack behavior</li>
                    <li>Port responses</li>
                    <li>ICMP messages</li>
                    <li>Other network characteristics</li>
                </ul>

                <div class="info-box">
                    <h4>💡 Aggressive Scan (-A)</h4>
                    <p>Combine multiple detection methods:</p>
                    <code>nmap -A 172.25.0.10</code>
                    <p>This enables:</p>
                    <ul>
                        <li>OS detection (-O)</li>
                        <li>Version detection (-sV)</li>
                        <li>Script scanning (-sC)</li>
                        <li>Traceroute (--traceroute)</li>
                    </ul>
                </div>

                <h3>Practical Service Enumeration</h3>

                <p><strong>Basic service scan:</strong></p>
                <code>nmap -sV -p 22,80,443 172.25.0.10</code>

                <p><strong>Comprehensive enumeration:</strong></p>
                <code>nmap -sS -sV -O -p- 172.25.0.10</code>

                <p><strong>Fast aggressive scan:</strong></p>
                <code>nmap -A -T4 --top-ports 1000 172.25.0.10</code>

                <h3>Reading Service Detection Output</h3>
                <p>Example output:</p>
                <code>
                PORT    STATE SERVICE VERSION<br>
                22/tcp  open  ssh     OpenSSH 8.9p1 Ubuntu<br>
                80/tcp  open  http    Apache httpd 2.4.52<br>
                443/tcp open  ssl/http Apache httpd 2.4.52
                </code>

                <p>You can see:</p>
                <ul>
                    <li><strong>Port number and protocol</strong></li>
                    <li><strong>State:</strong> open, closed, filtered</li>
                    <li><strong>Service name:</strong> What the service is</li>
                    <li><strong>Version:</strong> Specific version information</li>
                </ul>

                <h3>Banner Grabbing</h3>
                <p>Sometimes Nmap can't determine the version. You can grab banners manually:</p>
                <code>nmap -sV --script=banner 172.25.0.10</code>

                <div class="warning-box">
                    <h4>⚠️ Detection Accuracy</h4>
                    <p>Version detection isn't always 100% accurate:</p>
                    <ul>
                        <li>Services may hide their versions</li>
                        <li>Custom software won't be in Nmap's database</li>
                        <li>SSL/TLS encryption can interfere</li>
                        <li>Firewalls may alter responses</li>
                    </ul>
                    <p>Always verify findings with additional tools when needed.</p>
                </div>

                <h3>Target Practice</h3>
                <p>Scan our vulnerable target with full service detection:</p>
                <code>nmap -sS -sV -O -p- -T4 172.25.0.10</code>
                <p>This will reveal:</p>
                <ul>
                    <li>SSH server version</li>
                    <li>Web server type (Apache)</li>
                    <li>Samba version</li>
                    <li>MySQL version</li>
                    <li>And many other services...</li>
                </ul>

                <div class="success-box">
                    <h4>✨ Next: NSE Scripts</h4>
                    <p>You now know how to identify services and versions. Next, we'll explore the Nmap Scripting Engine (NSE) for advanced detection. Click "Complete & Next"!</p>
                </div>
            </div>
        `,
        prev: 'port-scanning',
        next: 'nmap-scripting'
    },

    'nmap-scripting': {
        title: 'Nmap Scripting Engine (NSE)',
        content: `
            <div class="module-content">
                <h2>📝 Nmap Scripting Engine (NSE)</h2>
                <p>The Nmap Scripting Engine (NSE) is one of Nmap's most powerful features, allowing you to extend its capabilities with custom scripts written in Lua.</p>

                <h3>What is NSE?</h3>
                <p>NSE enables you to:</p>
                <ul>
                    <li>Perform advanced version detection</li>
                    <li>Discover vulnerabilities</li>
                    <li>Exploit services (ethically)</li>
                    <li>Brute-force authentication</li>
                    <li>Gather additional information</li>
                </ul>

                <h3>Script Categories</h3>
                <p>NSE scripts are organized into categories:</p>
                <ul>
                    <li><strong>auth:</strong> Authentication testing</li>
                    <li><strong>broadcast:</strong> Network broadcast/multicast</li>
                    <li><strong>brute:</strong> Brute-force attacks</li>
                    <li><strong>default:</strong> Default scan scripts</li>
                    <li><strong>discovery:</strong> Information gathering</li>
                    <li><strong>dos:</strong> Denial of service</li>
                    <li><strong>exploit:</strong> Exploiting vulnerabilities</li>
                    <li><strong>fuzzer:</strong> Fuzzing</li>
                    <li><strong>intrusive:</strong> Aggressive probing</li>
                    <li><strong>malware:</strong> Malware detection</li>
                    <li><strong>safe:</strong> Low-risk scripts</li>
                    <li><strong>version:</strong> Version detection</li>
                    <li><strong>vuln:</strong> Vulnerability detection</li>
                </ul>

                <h3>Using Scripts</h3>

                <p><strong>Run default scripts:</strong></p>
                <code>nmap -sC 172.25.0.10</code>

                <p><strong>Run specific script:</strong></p>
                <code>nmap --script=http-title 172.25.0.10</code>

                <p><strong>Run script category:</strong></p>
                <code>nmap --script=vuln 172.25.0.10</code>

                <p><strong>Run multiple scripts:</strong></p>
                <code>nmap --script=http-enum,http-headers 172.25.0.10</code>

                <p><strong>Run all scripts except intrusive:</strong></p>
                <code>nmap --script="not intrusive" 172.25.0.10</code>

                <h3>Popular NSE Scripts</h3>

                <p><strong>1. HTTP Enumeration:</strong></p>
                <code>nmap --script=http-enum -p 80 172.25.0.10</code>
                <p>Discovers common web directories and files.</p>

                <p><strong>2. SMB Vulnerabilities:</strong></p>
                <code>nmap --script=smb-vuln-* -p 445 172.25.0.10</code>
                <p>Checks for SMB vulnerabilities like