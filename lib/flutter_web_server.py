import http.server
import socketserver
import os
import mimetypes

PORT = 5000
WEB_DIR = os.path.join(os.getcwd(), 'build/web')

# Assurez-vous que les types MIME sont correctement définis
mimetypes.add_type('application/javascript', '.js')
mimetypes.add_type('text/css', '.css')
mimetypes.add_type('application/wasm', '.wasm')
mimetypes.add_type('application/octet-stream', '.data')
mimetypes.add_type('application/octet-stream', '.pck')
mimetypes.add_type('font/woff2', '.woff2')
mimetypes.add_type('font/woff', '.woff')
mimetypes.add_type('font/ttf', '.ttf')

class MimeTypeHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=WEB_DIR, **kwargs)
    
    def end_headers(self):
        # Enable CORS
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept')
        super().end_headers()
    
    def guess_type(self, path):
        # Surcharger les types MIME pour les fichiers spécifiques de Flutter
        base, ext = os.path.splitext(path)
        if ext == '.js':
            return 'application/javascript'
        elif ext == '.css':
            return 'text/css'
        elif ext == '.wasm':
            return 'application/wasm'
        elif ext == '.data' or ext == '.pck':
            return 'application/octet-stream'
        elif ext == '.woff2':
            return 'font/woff2'
        elif ext == '.woff':
            return 'font/woff'
        elif ext == '.ttf':
            return 'font/ttf'
        else:
            return super().guess_type(path)
    
    def do_GET(self):
        # Pour l'historique HTML5, redirigez les chemins non trouvés vers index.html
        if not os.path.exists(os.path.join(WEB_DIR, self.path.lstrip('/'))):
            if self.path != '/' and not self.path.startswith('/assets/'):
                self.path = '/'
        return super().do_GET()

print(f"Serving Flutter web app at http://0.0.0.0:{PORT}")
with socketserver.TCPServer(("0.0.0.0", PORT), MimeTypeHandler) as httpd:
    httpd.serve_forever()
