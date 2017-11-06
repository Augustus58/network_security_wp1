import socket
import ssl

def main():
    s = socket.socket()
    ssl_s = ssl.wrap_socket(s,
                            keyfile='client.key',
                            certfile='client.crt',
                            ca_certs='ca.pem',
                            cert_reqs=ssl.CERT_REQUIRED)
    host = 'localhost'
    port = 12347
    ssl_s.connect((host, port))
    try:
        while True:
            req = input('req: ')
            ssl_s.send((req).encode('utf-8'))
            res = ssl_s.recv(1024)
            print(str(res,'utf-8'))
            if str(res,'utf-8') == 'request error':
                break
    except Exception as e:
        print(e)
        ssl_s.close()
    ssl_s.close()

if __name__ == "__main__":
    main()
