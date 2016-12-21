#[include]
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc

#[blacklist]
blacklist ${HOME}/.pki/nssdb
blacklist ${HOME}/.lastpass
blacklist ${HOME}/.keepassx
blacklist ${HOME}/.password-store
blacklist ${HOME}/.wine

#[config]
caps.drop all
seccomp
protocol unix,inet,inet6
noroot
