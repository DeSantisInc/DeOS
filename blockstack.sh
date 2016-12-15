#!/bin/bash

cd /deos/.deos/venv/linux/ && sudo virtualenv blockstack --no-site-packages
source /deos/.deos/venv/linux/blockstack/bin/activate

cd /deos/.deos/ext/linux/ && git clone "https://github.com/blockstack/dns-zone-file-py"
cd /deos/.deos/ext/linux/dns-zone-file-py/ && python ./setup.py build && python ./setup.py install

cd /deos/.deos/ext/linux/ && git clone "https://github.com/blockstack/blockstack-profiles-py"
cd /deos/.deos/ext/linux/blockstack-profiles-py/ && python ./setup.py build && python ./setup.py install

cd /deos/.deos/ext/linux/ && git clone "https://github.com/blockstack/virtualchain"
cd /deos/.deos/ext/linux/virtualchain/ && python ./setup.py build && python ./setup.py install

cd /deos/.deos/ext/linux/ && git clone "https://github.com/blockstack/blockstack-cli"
cd /deos/.deos/ext/linux/blockstack-cli/ && python ./setup.py build && python ./setup.py install

cd /deos/.deos/ext/linux/ && git clone "https://github.com/blockstack/blockstack-core"
cd /deos/.deos/ext/linux/blockstack-core/ && python ./setup.py build && python ./setup.py install

cd /deos/.deos/ext/linux/ && git clone "https://github.com/blockstack/blockstack-files"
cd /deos/.deos/ext/linux/blockstack-files/ && python ./setup.py build && python ./setup.py install

cd /deos/.deos/ext/linux/ && git clone "https://github.com/blockstack/blockstack-gpg"
cd /deos/.deos/ext/linux/blockstack-gpg/ && python ./setup.py build && python ./setup.py install

cd /deos/.deos/ext/linux/ && git clone "https://github.com/blockstack/blockstack-integration-tests"
cd /deos/.deos/ext/linux/blockstack-integration-tests/ && python ./setup.py build && python ./setup.py install
