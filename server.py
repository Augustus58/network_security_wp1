import socket
import threading
import ssl
 
sizes = {'Dumbo': 'XL', 'Nemo': '3.3g', 'Ego': 'huge'}

def handleRequest(c, addr):
    while True:
        req = str(c.recv(1024),'utf-8')
        print(req)
        if req == 'stop':
            break
        try:
            c.send((sizes[req]).encode('utf-8'))
        except KeyError:
            c.send(('request error').encode('utf-8'))
            break
    c.close()

def main():
    s = socket.socket()

    ssl_s = ssl.wrap_socket(s,
                            keyfile='server.key',
                            certfile='server.crt',
                            ca_certs='ca.pem',
                            cert_reqs=ssl.CERT_REQUIRED)
    
    host = 'localhost'
    port = 12347
    ssl_s.bind((host, port))
    ssl_s.listen(5)
    while True:
        (c, addr) = ssl_s.accept()
        thread = threading.Thread(target=handleRequest, args=(c, addr))
        thread.start()
    ssl_s.close()

if __name__ == "__main__":
    main()
