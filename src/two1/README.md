# 21: Build the Machine-Payable Web [![Build Status](https://travis-ci.org/21dotco/two1-python.svg?branch=master)](https://travis-ci.org/21dotco/two1-python)

![21 logo][logo]

21 is an open source Python library and command line interface for quickly
building machine-payable web services. It allows you to accomplish three major
tasks:

* Get bitcoin on any device
* Add bitcoin micropayments to any Django or Flask app
* Earn bitcoin on every HTTP request

The package includes:

* an HD wallet to securely manage your bitcoin.
* crypto and bitcoin libraries to build bitcoin/blockchain applications.
* a [micropayment-channels][channels] client and server.
* commands for mining, buying, and earning bitcoin, as well as requesting it
from the 21 faucet.
* tools for publishing machine-payable endpoints to the [21 Marketplace][mkt].
* containers that allow your machine to sell machine resources for bitcoin
and much more.

## Security

*Please note that the 21 software is in beta*. To protect the security of your
systems while using 21, we highly recommend you install the software on a
device other than your main laptop (e.g. 21 Bitcoin Computer, an old laptop,
or an Amazon Virtual Machine) while the product is still in beta. You can read
more security-related information [here][security]. Please send an email to
[security@21.co][support] regarding any issue concerning security.

## Installation

[Create an account](https://21.co) or install the library and CLI (python3.4+
is required):

```bash
$ curl https://21.co | sh
```

`two1` can also be installed via pip:

```bash
$ sudo pip3 install two1
```

Start with the command line tool:

```bash
$ 21 help
```

Then read the [Introduction to 21](https://21.co/learn/intro-to-21/) guide
and the `two1` [documentation](https://21.co/learn/#reference-21-library).

## Developers

To edit and run the two1 source code:

```shell
$ git clone https://github.com/21dotco/two1-python.git
$ cd two1-python/
$ pip3 install -r requirements.txt  # Install the requirements
$ pip3 install -e .  # Install 21 as an editable python library
```

Your changes to the source will now be reflected in your system installation in

real-time.

## Docker

You can pull [Docker](https://www.docker.com/) images with `two1` pre-installed

from the [21 Docker Hub repository][dockerhub].

```shell

$ docker pull 21dotco/two1

```

Then run the latest base image:

```shell
$ docker run -it 21dotco/two1 sh
```

## Community

Join the [21 developer community](https://slack.21.co) to chat with other users
or to get in touch with support.

## Licensing

`two1` is licensed under the FreeBSD License. See [LICENSE][license] for the
full license text.

[logo]: https://github.com/DeSantisInc/DeOS/blob/atd-deos-v0.6-alpha/var/docs/two1/img/21_banner.png?raw=true
[docker]: https://www.docker.com/
[dockerhub]: https://hub.docker.com/r/21dotco/two1
[channels]: https://21.co/learn/intro-to-micropayment-channels/
[mkt]: https://21.co/mkt
[security]: https://21.co/learn/security/
[support]: mailto://support@21.co
[license]: https://github.com/21dotco/two1-python/blob/master/LICENSE
