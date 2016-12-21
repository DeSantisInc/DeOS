#[noblacklist]
noblacklist ${HOME}/.config/xchat

#[include]
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc

#[blacklist]
blacklist ${HOME}/.wine

#[config]
caps.drop all
seccomp
protocol unix,inet,inet6
noroot