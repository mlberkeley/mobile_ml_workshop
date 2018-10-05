# Code modified from https://gist.github.com/bradmontgomery/2219997
from http.server import BaseHTTPRequestHandler, HTTPServer
import base64
import json
import numpy as np

class Handler(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        self._set_headers()
        with open("./user_ids.txt") as file:
            id_str = ""
            for line in file:
                id_str += (line + "<br>")
            self.wfile.write(str.encode("<html><body><h1>Current Users:</h1>" + id_str + "</body></html>"))
        
    def do_POST(self):
        self._set_headers()
        content_len = int(self.headers.get('content-length', 0))
        post_body = str(self.rfile.read(content_len))
        cleaned = post_body.replace('\\n', '').replace('\\r', '').replace('\\', '').replace(' ', '')[2:-1]
        result = json.loads(cleaned)
        label = result['label']
        print(label)
        with open('./images/' + label + "_" + result['id'] + "_" + str(np.random.randint(1000000)) + ".png", "wb") as fh:
            fh.write(base64.decodebytes(str.encode(result['img'])))
        with open("./user_ids.txt", 'a') as file:
            file.write(result['id'] + '\n')  


def run(server_class=HTTPServer, handler_class=Handler, port=8000):
    server_address = ('', port)
    server = server_class(server_address, handler_class)
    print('Serving at port ' + str(port) + '...')
    server.serve_forever()

if __name__ == '__main__':
    run()