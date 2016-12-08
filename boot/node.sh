RUN "curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -"
RUN "apt-get -y install nodejs 2> /dev/null"
EXIT_SUCCESS
