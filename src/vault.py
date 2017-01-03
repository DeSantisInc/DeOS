#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import division
from __future__ import print_function

import configobj
import sys
import os
import simplejson as json
import ruamel.yaml as yaml

from PyQt4 import QtCore, QtGui
from trezorlib.transport_hid import HidTransport

DeOS_VAULT_RSA_KEYSIZE = 2048
DeOS_VAULT_SYMMETRIC_KEYSIZE = 32
DeOS_VAULT_BLOCKSIZE = 16
DeOS_VAULT_WINDOW_TITLE = 'Vault'
DeOS_VAULT_KEY_INDEX = 0 # column where key is shown in password table
DeOS_VAULT_PASSWD_INDEX = 1 # column where password is shown in password table
# column of QWidgetItem in whose data we cache decrypted passwords
DeOS_VAULT_CACHE_INDEX = 0

class DeOS_PasswordGroup(object):
    """
    Holds data for one password group.
    Each entry has three values:
    - key
    - symetrically AES-CBC encrypted password unlockable only by Trezor
    - RSA-encrypted password for creating backup of all password groups
    """
    def __init__(self):
        self.entries = []

    def addEntry(self, key, encryptedValue, backupValue):
        """
        Add key-value-backud entry.
        """
        self.entries.append((key, encryptedValue, backupValue))

    def removeEntry(self, index):
        """
        Remove entry at given index.
        """
        self.entries.pop(index)

    def updateEntry(self, index, key, encryptedValue, backupValue):
        """
        Update pair at index with given key, value, and
        backup-encrypted password.
        """
        self.entries[index] = (key, encryptedValue, backupValue)

    def entry(self, index):
        """
        Return entry with given index.
        """
        return self.entries[index]

class DeOS_PasswordMap(object):
    """
    Storage of groups of passwords in memory.
    """
    def __init__(self, trezor):
        assert trezor is not None
        self.groups = {}
        self.trezor = trezor
        self.outerKey = None # outer AES-CBC key
        self.outerIv = None  # IV for data blob encrypted with outerKey
        self.backupKey = None

    def addGroup(self, groupName):
        """
        Add group by name as utf-8 encoded string
        """
        self._add_group(groupName)

    def load(self, fname):
        """
        Load encrypted passwords from disk file, decrypt outer
        layer containing key names. Requires Trezor connected.
        @throws IOError: if reading file failed
        """
        self._load(fname)

    def _add_group(self, groupName):
        if groupName in self.groups:
            raise KeyError("Group name already exists")
        self.groups[groupName] = DeOS_PasswordGroup()

    def _load(self, fname):
        # here
        with file(fname) as f:
            header = f.read(len(Magic.headerStr))

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

class DeOS_Trezor(object):

    def __init__(self):
        self.passphrase = None

    def _get_devices(self):
        return HidTransport.enumerate()
