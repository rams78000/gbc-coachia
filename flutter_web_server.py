#!/usr/bin/env python3
import http.server
import socketserver
import os

PORT = 5000

class MimeTypeHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory="build/web", **kwargs)
    
    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET")
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate")
        return super().end_headers()
    
    def guess_type(self, path):
        base, ext = os.path.splitext(path)
        if ext == '.js':
            return 'application/javascript'
        elif ext == '.mjs':
            return 'application/javascript'
        return super().guess_type(path)

handler = MimeTypeHandler
httpd = socketserver.TCPServer(("0.0.0.0", PORT), handler)
print(f"Serving at http://0.0.0.0:{PORT}")
httpd.serve_forever()
