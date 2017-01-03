#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import division
from __future__ import print_function

import cPickle
import hashlib
import hmac
import os
import struct
import sys
import configobj
import simplejson as json
import ruamel.yaml as yaml

from Crypto.PublicKey import RSA
from Crypto.Cipher import AES
from Crypto.Cipher import PKCS1_OAEP
from Crypto import Random
from PyQt4 import QtCore
from PyQt4 import QtGui
from trezorlib.client import BaseClient
from trezorlib.client import ProtocolMixin
from trezorlib.transport_hid import HidTransport
from trezorlib import messages_pb2

DeOS_VAULT_RSA_KEY_SIZE = 2048
DeOS_VAULT_SYMMETRIC_KEY_SIZE = 32
DeOS_VAULT_KEY_SIZE = 32
DeOS_VAULT_BLOCK_SIZE = 16
DeOS_VAULT_MAC_SIZE = 32
DeOS_VAULT_KEY_INDEX = 0 # column where key is shown in password table
DeOS_VAULT_PASSWD_INDEX = 1 # column where password is shown in password table
# column of QWidgetItem in whose data we cache decrypted passwords
DeOS_VAULT_CACHE_INDEX = 0
DeOS_VAULT_WINDOW_TITLE = "Vault"

class DeOS_Vault(QtGui.QMainWindow):

    def __init__(self, passwds, database):
        """
        @param passwds: a PasswordMap instance w/ encrypted passwords
        @param database: file name for saving pwMap
        """
        QtGui.QMainWindow.__init__(self)
        self.setupUi(self)
        self._set_window_title()
        self._set_modified()
        self._set_database_filename(database)
        self._set_password_map(passwds)
        self._set_selected_group()
        self._set_groups_model(header_labels=['Password group'])
        self._set_groups_filter()

    def _get_window_title(self, modified=False):
        res = self.window_title
        if modified:
            res = res+'*'*int(modified)
        return res

    def _set_selected_group(self, selected_group=None):
        self.selectedGroup = selected_group

    def _set_password_map(self, passwds):
        self.pwMap = passwds

    def _set_database_filename(self, database):
        self.dbFilename = database

    def _set_groups_filter(self):
        self.groupsFilter = QtGui.QSortFilterProxyModel()
        self.groupsFilter.setSourceModel(self.groupsModel)

    def _set_groups_model(self, header_labels):
        self.groupsModel = QtGui.QStandardItemModel()
        self.groupsModel.setHorizontalHeaderLabels(header_labels)

    def _set_modified(self, modified=False):
        self.modified = modified # modified flag "Save?" question on exit

    def _set_window_title(self, title=DeOS_VAULT_WINDOW_TITLE):
        self.window_title = title

class DeOS_VaultSettings(object):

    def __init__(self):
        self.dbFilename = None
        self.settings = QtCore.QSettings("ConstructibleUniverse", "TrezorPass")
        fname = self.settings.value("database/filename")
        if fname.isValid():
            self.dbFilename = q2s(fname.toString())

    def store(self):
        self.settings.setValue("database/filename", s2q(self.dbFilename))
