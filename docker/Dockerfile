FROM python:latest

RUN pip3 install --upgrade pip

RUN git clone https://github.com/SecureAuthCorp/impacket
RUN cd impacket && python3 setup.py install

ENTRYPOINT ["/bin/bash"]