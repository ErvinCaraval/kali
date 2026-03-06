#!/usr/bin/env python3
"""
Vulnerable Application - Proof of Concept (PoC)
Educational purposes only for cybersecurity demonstrations

This application creates a vulnerable server environment to practice
network reconnaissance using Nmap.

Usage:
    python3 vulnerable-app.py
    
Then scan with:
    nmap -sV -sC -p 1-10000 localhost
"""

import socket
import threading
import time
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
import sqlite3
import os

class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

def print_header(text):
    print(f"\n{Colors.BLUE}{Colors.BOLD}{'='*60}{Colors.RESET}")
    print(f"{Colors.BLUE}{Colors.BOLD}{text}{Colors.RESET}")
    print(f"{Colors.BLUE}{Colors.BOLD}{'='*60}{Colors.RESET}\n")

def print_success(text):
    print(f"{Colors.GREEN}✓ {text}{Colors.RESET}")

def print_error(text):
    print(f"{Colors.RED}✗ {text}{Colors.RESET}")

def print_info(text):
    print(f"{Colors.YELLOW}ℹ {text}{Colors.RESET}")

# ============================================================================
# VULNERABLE WEB APPLICATION
# ============================================================================

class VulnerableHTTPHandler(BaseHTTPRequestHandler):
    """
    HTTP Handler with intentional vulnerabilities:
    - No authentication on admin panel
    - SQL Injection vulnerability in search
    - Path traversal vulnerability
    - Exposed version information
    """
    
    def do_GET(self):
        """Handle GET requests"""
        
        # Vulnerability 1: Exposed version information in headers
        self.send_response(200)
        self.send_header('Server', 'Apache/2.4.1 (Vulnerable)')  # Old version
        self.send_header('X-Powered-By', 'PHP/5.3.8')  # Old version
        self.send_header('Content-Type', 'text/html')
        self.end_headers()
        
        # Route handling
        if self.path == '/':
            self.wfile.write(self.home_page().encode())
        elif self.path == '/admin':
            # Vulnerability 2: No authentication required for admin panel
            self.wfile.write(self.admin_panel().encode())
        elif self.path.startswith('/search'):
            # Vulnerability 3: SQL Injection vulnerability
            query = self.path.split('?q=')[1] if '?q=' in self.path else ''
            self.wfile.write(self.search_results(query).encode())
        elif self.path.startswith('/download'):
            # Vulnerability 4: Path traversal vulnerability
            file_path = self.path.split('?file=')[1] if '?file=' in self.path else ''
            self.wfile.write(self.download_file(file_path).encode())
        else:
            self.wfile.write(b"404 Not Found")
    
    def home_page(self):
        return """
        <!DOCTYPE html>
        <html>
        <head><title>Vulnerable Demo App</title></head>
        <body>
            <h1>Welcome to Vulnerable WebApp v1.0</h1>
            <p>This application contains intentional vulnerabilities for educational purposes.</p>
            <ul>
                <li><a href="/admin">Admin Panel (No Auth)</a></li>
                <li><a href="/search?q=test">Search (SQL Injection)</a></li>
                <li><a href="/download?file=data.txt">Download (Path Traversal)</a></li>
            </ul>
        </body>
        </html>
        """
    
    def admin_panel(self):
        return """
        <!DOCTYPE html>
        <html>
        <head><title>Admin Panel</title></head>
        <body>
            <h1>Admin Panel - UNPROTECTED</h1>
            <p>Database: webapp_db</p>
            <p>Users: admin, user1, user2</p>
            <p>Passwords: stored in users table</p>
        </body>
        </html>
        """
    
    def search_results(self, query):
        # Vulnerability: Query is not sanitized
        # Actual query would be: SELECT * FROM products WHERE name LIKE '%{query}%'
        html = f"""
        <!DOCTYPE html>
        <html>
        <head><title>Search Results</title></head>
        <body>
            <h1>Search Results for: {query}</h1>
            <p>[SQL Query would be executed: SELECT * FROM products WHERE name LIKE '%{query}%']</p>
            <p>Vulnerability: No input validation or parameterized queries</p>
        </body>
        </html>
        """
        return html
    
    def download_file(self, file_path):
        # Vulnerability: No path validation
        html = f"""
        <!DOCTYPE html>
        <html>
        <head><title>Download</title></head>
        <body>
            <h1>File Download</h1>
            <p>Requested file: {file_path}</p>
            <p>Vulnerability: Path traversal possible - no validation on file_path</p>
            <p>Attacker could access: /../../etc/passwd</p>
        </body>
        </html>
        """
        return html
    
    def log_message(self, format, *args):
        """Suppress default logging"""
        pass

# ============================================================================
# VULNERABLE SSH-LIKE SERVICE (Custom)
# ============================================================================

def vulnerable_ssh_service(port):
    """
    Simulates a vulnerable SSH service
    """
    try:
        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind(('localhost', port))
        server.listen(5)
        print_success(f"Vulnerable SSH Service listening on port {port}")
        
        while True:
            try:
                client, addr = server.accept()
                # Send vulnerable banner
                banner = b"SSH-2.0-OpenSSH_3.9p1 Debian-1.0\r\n"
                client.send(banner)
                client.close()
            except:
                pass
    except Exception as e:
        print_error(f"SSH Service error: {e}")

# ============================================================================
# VULNERABLE FTP SERVICE
# ============================================================================

def vulnerable_ftp_service(port):
    """
    Simulates a vulnerable FTP service
    """
    try:
        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind(('localhost', port))
        server.listen(5)
        print_success(f"Vulnerable FTP Service listening on port {port}")
        
        while True:
            try:
                client, addr = server.accept()
                # Send vulnerable FTP banner
                banner = b"220 FTP Server v2.1.0 Ready\r\n"
                client.send(banner)
                client.close()
            except:
                pass
    except Exception as e:
        print_error(f"FTP Service error: {e}")

# ============================================================================
# VULNERABLE TELNET SERVICE
# ============================================================================

def vulnerable_telnet_service(port):
    """
    Simulates a vulnerable Telnet service
    """
    try:
        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind(('localhost', port))
        server.listen(5)
        print_success(f"Vulnerable Telnet Service listening on port {port}")
        
        while True:
            try:
                client, addr = server.accept()
                # Send vulnerable Telnet banner
                banner = b"Linux 2.4.18 #14 Nov 20 00:00:00 UTC 2003\r\nusername: "
                client.send(banner)
                client.close()
            except:
                pass
    except Exception as e:
        print_error(f"Telnet Service error: {e}")

# ============================================================================
# VULNERABLE SMTP SERVICE
# ============================================================================

def vulnerable_smtp_service(port):
    """
    Simulates a vulnerable SMTP service
    """
    try:
        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind(('localhost', port))
        server.listen(5)
        print_success(f"Vulnerable SMTP Service listening on port {port}")
        
        while True:
            try:
                client, addr = server.accept()
                # Send vulnerable SMTP banner
                banner = b"220 mail.example.com ESMTP Sendmail 8.11.6\r\n"
                client.send(banner)
                client.close()
            except:
                pass
    except Exception as e:
        print_error(f"SMTP Service error: {e}")

# ============================================================================
# MAIN APPLICATION
# ============================================================================

def main():
    print_header("VULNERABLE APPLICATION - PROOF OF CONCEPT")
    print_info("Educational Cybersecurity Demonstration")
    print_info("This application intentionally contains vulnerabilities")
    print_info("for learning purposes only.\n")
    
    print(f"{Colors.BOLD}Services that will be started:{Colors.RESET}")
    print("  - Web Server (HTTP) - Port 8080")
    print("  - SSH Service - Port 2222")
    print("  - FTP Service - Port 2121")
    print("  - Telnet Service - Port 2323")
    print("  - SMTP Service - Port 2525")
    
    print(f"\n{Colors.BOLD}How to scan this application:{Colors.RESET}")
    print(f"  {Colors.YELLOW}nmap -sV -sC -p 8080,2222,2121,2323,2525 localhost{Colors.RESET}")
    print(f"  {Colors.YELLOW}nmap -A localhost{Colors.RESET}")
    print(f"  {Colors.YELLOW}nmap --script vuln localhost{Colors.RESET}")
    
    print(f"\n{Colors.BOLD}Vulnerabilities to find:{Colors.RESET}")
    print("  1. Exposed version information in HTTP headers")
    print("  2. Unprotected admin panel (no authentication)")
    print("  3. SQL Injection vulnerability in search")
    print("  4. Path traversal vulnerability in download")
    print("  5. Old/vulnerable service versions (SSH, FTP, SMTP)")
    print("  6. Telnet service running (unencrypted)")
    
    print_info("Press Ctrl+C to stop the application\n")
    
    # Start services in separate threads
    threads = []
    
    # HTTP Server
    try:
        http_server = HTTPServer(('localhost', 8080), VulnerableHTTPHandler)
        http_thread = threading.Thread(target=http_server.serve_forever)
        http_thread.daemon = True
        http_thread.start()
        print_success("HTTP Server started on port 8080")
        threads.append(http_thread)
    except Exception as e:
        print_error(f"Failed to start HTTP server: {e}")
    
    # SSH Service
    ssh_thread = threading.Thread(target=vulnerable_ssh_service, args=(2222,))
    ssh_thread.daemon = True
    ssh_thread.start()
    threads.append(ssh_thread)
    
    # FTP Service
    ftp_thread = threading.Thread(target=vulnerable_ftp_service, args=(2121,))
    ftp_thread.daemon = True
    ftp_thread.start()
    threads.append(ftp_thread)
    
    # Telnet Service
    telnet_thread = threading.Thread(target=vulnerable_telnet_service, args=(2323,))
    telnet_thread.daemon = True
    telnet_thread.start()
    threads.append(telnet_thread)
    
    # SMTP Service
    smtp_thread = threading.Thread(target=vulnerable_smtp_service, args=(2525,))
    smtp_thread.daemon = True
    smtp_thread.start()
    threads.append(smtp_thread)
    
    print_success("All services started successfully!\n")
    
    # Keep the application running
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print_error("\n\nShutting down services...")
        print_info("Application stopped")
        sys.exit(0)

if __name__ == "__main__":
    main()
