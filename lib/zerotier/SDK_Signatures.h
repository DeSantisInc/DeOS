/*
 * ZeroTier One - Network Virtualization Everywhere
 * Copyright (C) 2011-2015  ZeroTier, Inc.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * --
 *
 * ZeroTier may be used and distributed under the terms of the GPLv3, which
 * are available at: http://www.gnu.org/licenses/gpl-3.0.html
 *
 * If you would like to embed ZeroTier into a commercial application or
 * redistribute it in a modified binary form, please contact ZeroTier Networks
 * LLC. Start here: http://www.zerotier.com/
 */

#ifndef _SDK_SIGNATURES_H
#define _SDK_SIGNATURES_H	1

#include <sys/socket.h>

#define SETSOCKOPT_SIG int socket, int level, int optname, const void *optval, socklen_t optlen
#define GETSOCKOPT_SIG int sockfd, int level, int optname, void *optval, socklen_t *optlen

#define SENDMSG_SIG int socket, const struct msghdr *message, int flags
#define SENDTO_SIG int sockfd, const void *buf, size_t len, int flags, const struct sockaddr *addr, socklen_t addr_len
#define RECV_SIG int socket, void *buffer, size_t length, int flags
#define RECVFROM_SIG int socket, void * buffer, size_t length, int flags, struct sockaddr * address, socklen_t * address_len
#define RECVMSG_SIG int socket, struct msghdr *message,int flags

#define SEND_SIG int socket, const void *buffer, size_t length, int flags
#define WRITE_SIG int __fd, const void *__buf, size_t __n
#define RECV_SIG int socket, void *buffer, size_t length, int flags
#define READ_SIG int __fd, void *__buf, size_t __nbytes

#define SOCKET_SIG int socket_family, int socket_type, int protocol
#define CONNECT_SIG int __fd, const struct sockaddr * __addr, socklen_t __len
#define BIND_SIG int sockfd, const struct sockaddr *addr, socklen_t addrlen
#define LISTEN_SIG int sockfd, int backlog
#define ACCEPT4_SIG int sockfd, struct sockaddr *addr, socklen_t *addrlen, int flags
#define ACCEPT_SIG int sockfd, struct sockaddr *addr, socklen_t *addrlen
#define CLOSE_SIG int fd
#define GETSOCKNAME_SIG int sockfd, struct sockaddr *addr, socklen_t *addrlen
#define GETPEERNAME_SIG int sockfd, struct sockaddr *addr, socklen_t *addrlen
#define FCNTL_SIG int fd, int cmd, int flags
#define SYSCALL_SIG long number, ...

#endif /* _SDK_SIGNATURES_H */