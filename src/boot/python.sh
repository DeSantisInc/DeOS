RUN "apt-get install -y python2.7 $BOOT_DEBUG"
RUN "apt-get install -y python-dev $BOOT_DEBUG"
RUN "apt-get install -y python-pip $BOOT_DEBUG"
RUN "pip install --upgrade pip"
RUN "pip install ndg-httpsclient"
RUN "pip install pyasn1"
RUN "pip install --upgrade requests[security]"
EXIT_SUCCESS
