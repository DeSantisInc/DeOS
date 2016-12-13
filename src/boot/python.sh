MAINTAINER "atd@bitcoin.sh"

INSTALL "python2.7"
INSTALL "python-dev"
INSTALL "python-pip"

RUN "pip install --upgrade pip"
RUN "pip install ndg-httpsclient"
RUN "pip install pyasn1"
RUN "pip install --upgrade requests[security]"

EXIT_SUCCESS
