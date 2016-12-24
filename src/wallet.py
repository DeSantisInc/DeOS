#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import blockstack_client
import simplejson as json

def main():
    wallet=blockstack_client.wallet.load_wallet()
    print(json.dumps(wallet,sort_keys=True,indent=2))

if __name__=="__main__":
    main()
