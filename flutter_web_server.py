import http.server
import socketserver
import os

PORT = 5000
WEB_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "build/web")

class MimeTypeHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=WEB_DIR, **kwargs)

    def guess_type(self, path):
        base, ext = os.path.splitext(path)
        
        # Define correct MIME types for Flutter web files
        if ext == '.dart':
            return 'application/javascript'
        elif ext == '.js':
            return 'application/javascript'
        elif ext == '.json':
            return 'application/json'
        elif ext == '.png':
            return 'image/png'
        elif ext == '.jpg' or ext == '.jpeg':
            return 'image/jpeg'
        elif ext == '.svg':
            return 'image/svg+xml'
        elif ext == '.css':
            return 'text/css'
        elif ext == '.html':
            return 'text/html'
        elif ext == '.ico':
            return 'image/x-icon'
        elif ext == '.ttf':
            return 'font/ttf'
        elif ext == '.woff':
            return 'font/woff'
        elif ext == '.woff2':
            return 'font/woff2'
        else:
            return super().guess_type(path)

if __name__ == "__main__":
    # Check if build/web exists, if not print instructions
    if not os.path.exists(WEB_DIR):
        print(f"Directory {WEB_DIR} not found!")
        print("Please build the Flutter web app first with:")
        print("flutter build web --web-renderer html")
        exit(1)
    
    handler = MimeTypeHandler
    
    # Create the server
    with socketserver.TCPServer(("0.0.0.0", PORT), handler) as httpd:
        print(f"Serving Flutter web app at http://0.0.0.0:{PORT}")
        print(f"Press Ctrl+C to stop the server")
        httpd.serve_forever()