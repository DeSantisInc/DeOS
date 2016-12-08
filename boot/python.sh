RUN "apt-get install -y python2.7 2> /dev/null"
RUN "apt-get install -y python-dev 2> /dev/null"
RUN "apt-get install -y python-pip 2> /dev/null"
RUN "pip install --upgrade pip"
RUN "pip install ndg-httpsclient"
RUN "pip install pyasn1"
RUN "pip install --upgrade requests[security]"
EXIT_SUCCESS
