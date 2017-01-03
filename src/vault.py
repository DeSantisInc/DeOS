#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import division
from __future__ import print_function

import configobj
import os
import ruamel.yaml as yaml
import simplejson  as json
import sys

RSA_KEYSIZE       = 2048
SYMMETRIC_KEYSIZE = 32
BLOCKSIZE         = 16

class Menu(object):
    def __init__(self): pass
    def show_groups(self): pass
    def show_passwd(self): pass

class Backup(object):
    def __init__(self):
        self.RSA_KEYSIZE = RSA_KEYSIZE
        self.SYMMETRIC_KEYSIZE = SYMMETRIC_KEYSIZE
        self.BLOCKSIZE = BLOCKSIZE
    def generate(self): pass
    def wrap_private_key(self): pass
    def unwrap_private_key(self): pass
    def serialize(self): pass
    def deserialize(self): pass
    def encrypt_passwd(self): pass
    def decrypt_passwd(self): pass

class Trezor(object):
    def __init__(self):
        self.passphrase = None
    def callback_request_button(self, msg): pass
    def callback_request_passphrase(self, msg): pass
    def callback_request_pin_matrix(self, msg): pass
    def prefill_passphrase(self, passphrase): pass
    def get_device(self): pass
    def enumerate_hid_devices(self): pass
    def choose_device(self, devices): pass

class Password(object):
    def __init__(self): pass
    def cache(self): pass
    def cached(self): pass
    def cached_or_decrypt(self): pass
    def copy_from_item(self): pass
    def copy_from_selection(self): pass
    def create(self): pass
    def delete(self): pass
    def edit(self): pass
    def show(self): pass
    def list_all(self): pass
    def load_all(self): pass
    def load_all_from_selection(self): pass

class Group(object):
    def __init__(self): pass
    def create(self): pass
    def delete(self): pass
    def filter(self): pass

class Window(object):
    def __init__(self):
        self.context_menu = Menu()
    def set_modified(self, modified): pass

class Vault(object):
    def __init__(self):
        self.group  = Group()
        self.passwd = Password()
        self.trezor = Trezor()
        self.backup = Backup()
        self.main_window = Window()

def main():
    v = Vault()
    print(v.main_window.context_menu.show_groups)
    print(v.main_window.context_menu.show_passwd)
    print(v.main_window.set_modified)
    #print(v.trezor.passphrase)
    print(v.trezor.callback_request_button)
    print(v.trezor.callback_request_passphrase)
    print(v.trezor.callback_request_pin_matrix)
    print(v.trezor.prefill_passphrase)
    print(v.trezor.get_device)
    print(v.trezor.enumerate_hid_devices)
    print(v.trezor.choose_device)
    #print(v.backup.RSA_KEYSIZE)
    #print(v.backup.SYMMETRIC_KEYSIZE)
    #print(v.backup.BLOCKSIZE)
    print(v.backup.generate)
    print(v.backup.wrap_private_key)
    print(v.backup.unwrap_private_key)
    print(v.backup.serialize)
    print(v.backup.deserialize)
    print(v.backup.encrypt_passwd)
    print(v.backup.decrypt_passwd)
    print(v.group.create)
    print(v.group.delete)
    print(v.group.filter)
    print(v.passwd.create)
    print(v.passwd.cache)
    print(v.passwd.cached)
    print(v.passwd.cached_or_decrypt)
    print(v.passwd.delete)
    print(v.passwd.show)
    print(v.passwd.edit)
    print(v.passwd.copy_from_item)
    print(v.passwd.copy_from_selection)
    print(v.passwd.list_all)
    print(v.passwd.load_all)
    print(v.passwd.load_all_from_selection)

if __name__ == "__main__":
    main()
