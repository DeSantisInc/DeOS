#[noblacklist]
noblacklist ${HOME}/.conkeror.mozdev.org

#[include]
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc

#[config]
caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
noroot

#[whitelist]
whitelist ~/.conkeror.mozdev.org
whitelist ~/Downloads
whitelist ~/dwhelper
whitelist ~/.zotero
whitelist ~/.lastpass
whitelist ~/.gtkrc-2.0
whitelist ~/.vimperatorrc
whitelist ~/.vimperator
whitelist ~/.pentadactylrc
whitelist ~/.pentadactyl
whitelist ~/.conkerorrc

#[common]
include /etc/firejail/whitelist-common.inc
