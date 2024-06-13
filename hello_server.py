# Importing the HTTP server libraries
from http.server import BaseHTTPRequestHandler, HTTPServer

# Handler class
class HelloWorldHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # Responding to a GET request
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write("Hello World".encode())

# Server settings
host = '0.0.0.0'
port = 8080
server_address = (host, port)

# Creating and starting the server
httpd = HTTPServer(server_address, HelloWorldHandler)
print(f"Server running on http://{host}:{port}/")
httpd.serve_forever()