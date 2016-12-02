DERUN "apt-get install -y python2.7"

DERUN "apt-get install -y python-dev"

DERUN "apt-get install -y python-pip"

DERUN "pip install --upgrade pip"

DERUN "pip install ndg-httpsclient"

DERUN "pip install pyasn1"

DERUN "pip install --upgrade requests[security]"

EXIT_SUCCESS
