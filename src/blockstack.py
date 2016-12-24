#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import blockstack_client
import simplejson as json

def main():
    exists=blockstack_client.wallet.wallet_exists()
    if isinstance(exists,bool):
        if exists:
            wallet=blockstack_client.wallet.load_wallet()
            if 'status' in wallet:
                if isinstance(wallet['status'],bool):
                    addr=wallet['wallet']['payment_addresses']
                    balance=blockstack_client.wallet.get_balance(addr)
                    print(balance)
                    #print(json.dumps(wallet,sort_keys=True,indent=2))

if __name__=="__main__":
    main()
