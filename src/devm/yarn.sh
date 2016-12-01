
DERUN "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -"

echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

DERUN "sudo apt-get update && sudo apt-get -y install yarn 2> /dev/null"

export PATH="$PATH:`yarn global bin`"

DERUN "cd /vagrant && yarn install && cd app && yarn install"

EXIT_SUCCESS
