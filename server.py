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
        # TODO
        
    def do_POST(self):
        # TODO


def run(server_class=HTTPServer, handler_class=Handler, port=8000):
    server_address = ('', port)
    server = server_class(server_address, handler_class)
    print('Serving at port ' + str(port) + '...')
    server.serve_forever()

if __name__ == '__main__':
	run()