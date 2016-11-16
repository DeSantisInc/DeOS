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

#ifdef USE_GNU_SOURCE
    #define _GNU_SOURCE
#endif

// For defining the Android direct-call API
#if defined(__ANDROID__)
    #include <jni.h>
#endif

#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <strings.h>
#include <errno.h>
#include <stdarg.h>
#include <netdb.h>
#include <string.h>
#include <fcntl.h>
#include <pthread.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/poll.h>
#include <arpa/inet.h>
#include <netinet/in.h>

#if defined(__linux__)
    #include <linux/errno.h>
    #include <sys/syscall.h>
    #include <linux/net.h>
#endif

#ifdef __cplusplus
    extern "C" {
#endif
    
#if defined(__linux__)
    #define SOCK_MAX (SOCK_PACKET + 1)
#endif
#define SOCK_TYPE_MASK 0xf

#include "SDK.h"
#include "SDK_Signatures.h"
#include "SDK_Debug.h"
#include "SDK_RPC.h"
#include "Constants.hpp" // For Tap's MTU

// Prototypes
void dwr(int level, const char *fmt, ... );
char *api_netpath = (char *)0;
void load_symbols();
void load_symbols_rpc();
int (*realclose)(CLOSE_SIG);

    // ------------------------------------------------------------------------------
    // ---------------------------------- zt_init_rpc -------------------------------
    // ------------------------------------------------------------------------------
    
    // Assembles (and/or) sets the RPC path for communication with the ZeroTier service
    void zts_init_rpc(const char *path, const char *nwid)
    {
        // dwr(MSG_DEBUG_EXTRA, "zt_init_rpc\n");
        #if !defined(__IOS__)
            // Since we don't use function interposition in iOS 
            if(!realconnect) {
                load_symbols_rpc();
            }
        #endif
        // If no path, construct one or get it fron system env vars
        if(!api_netpath) {
            rpc_mutex_init();
            #if defined(SDK_BUNDLED)
                // Get the path/nwid from the user application
                // netpath = [path + "/nc_" + nwid] 
                char *fullpath = malloc(strlen(path)+strlen(nwid)+1+4);
                if(fullpath) {
                    strcpy(fullpath, path);
                    strcat(fullpath, "/nc_");
                    strcat(fullpath, nwid);
                    api_netpath = fullpath;
                }
            #else
                // Get path/nwid from environment variables
                // This is used when you're dynamically-linking our library into your application at runtime
                if (!api_netpath) {
                    api_netpath = getenv("ZT_NC_NETWORK");
                    dwr(MSG_DEBUG, "$ZT_NC_NETWORK(len=%d) = %s\n", strlen(api_netpath), api_netpath);
                }
            #endif
            dwr(MSG_DEBUG_EXTRA, "zt_init_rpc(): api_netpath = %s\n", api_netpath);
        }
    }

    void get_api_netpath() { zts_init_rpc("",""); }
        
    // ------------------------------------------------------------------------------
    // ------------------------------------ send() ----------------------------------
    // ------------------------------------------------------------------------------
    // int sockfd, const void *buf, size_t len

#if defined(__ANDROID__)
    JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1send(JNIEnv *env, jobject thisObj, jint fd, jarray buf, jint len, int flags)
    {
        jbyte *body = (*env)->GetByteArrayElements(env, buf, 0);
        char * bufp = (char *)malloc(sizeof(char)*len);
        memcpy(bufp, body, len);
        (*env)->ReleaseByteArrayElements(env, buf, body, 0);
        int written_bytes = write(fd, body, len);
        return written_bytes;
    }
#endif

    // ------------------------------------------------------------------------------
    // ------------------------------------ sendto() --------------------------------
    // ------------------------------------------------------------------------------
    // int sockfd, const void *buf, size_t len, int flags, 
    // const struct sockaddr *addr, socklen_t addr_len

#if defined(__ANDROID__)
    // TODO: Check result of each JNI call
    // UDP TX
	JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1sendto(
        JNIEnv *env, jobject thisObj, jint fd, jarray buf, jint len, jint flags, jobject ztaddr)
    {
        struct sockaddr_in addr;
        jclass cls = (*env)->GetObjectClass(env, ztaddr);
        jfieldID f = (*env)->GetFieldID(env, cls, "port", "I");
        addr.sin_port = htons((*env)->GetIntField(env, ztaddr, f));
        f = (*env)->GetFieldID(env, cls, "_rawAddr", "J");
        addr.sin_addr.s_addr = (*env)->GetLongField(env, ztaddr, f);
        addr.sin_family = AF_INET;
        //LOGV("zt_sendto(): fd = %d\naddr = %s\nport=%d", fd, inet_ntoa(addr.sin_addr), ntohs(addr.sin_port));
        // TODO: Optimize this
        jbyte *body = (*env)->GetByteArrayElements(env, buf, 0);
        char * bufp = (char *)malloc(sizeof(char)*len);
        memcpy(bufp, body, len);
        (*env)->ReleaseByteArrayElements(env, buf, body, 0);
        // "connect" and send buffer contents
        int sent_bytes = zts_sendto(fd, body, len, flags, (struct sockaddr *)&addr, sizeof(addr));
        return sent_bytes;
    }
#endif

//#if !defined(__ANDROID__)
    #ifdef DYNAMIC_LIB
        ssize_t zt_sendto(SENDTO_SIG) // Exposed as API
    #else
        ssize_t zts_sendto(SENDTO_SIG) // Used as internal implementation 
    #endif
        {
            dwr(MSG_DEBUG_EXTRA, "zt_sendto(%d, ...)\n", sockfd);
            if(len > ZT_UDP_DEFAULT_PAYLOAD_MTU) {
                errno = EMSGSIZE; // Msg is too large
                return -1;
            }
            int socktype = 0;
            socklen_t socktype_len;
            getsockopt(sockfd,SOL_SOCKET, SO_TYPE, (void*)&socktype, &socktype_len);

            if((socktype & SOCK_STREAM) || (socktype & SOCK_SEQPACKET)) {
                if(addr == NULL || flags != 0) {
                    errno = EISCONN;
                    return -1;
                }
            }
            // EMSGSIZE should be returned if the message is too long to be passed atomically through
            // the underlying protocol, in our case MTU?
            // TODO: More efficient solution
            // This connect call is used to get the address info to the stack for sending the packet
            int err;
            if((err = zts_connect(sockfd, addr, addr_len)) < 0) {
                LOGV("sendto(): unknown problem passing address info to stack\n");
                errno = EISCONN; // double-check this is correct
                return -1;
            }
            return write(sockfd, buf, len);
        }
//#endif

    // ------------------------------------------------------------------------------
    // ----------------------------------- sendmsg() --------------------------------
    // ------------------------------------------------------------------------------
    // int socket, const struct msghdr *message, int flags

#if !defined(__ANDROID__)
    #ifdef DYNAMIC_LIB
        ssize_t zt_sendmsg(SENDMSG_SIG)
    #else
        ssize_t zts_sendmsg(SENDMSG_SIG)
    #endif
        {
            dwr(MSG_DEBUG_EXTRA, "zt_sendmsg()\n");
            char * p, * buf;
            size_t tot_len = 0;
            size_t err;
            struct iovec * iov = message->msg_iov;
            for(int i=0; i<message->msg_iovlen; ++i)
                tot_len += iov[i].iov_len;
            if(tot_len > ZT_UDP_DEFAULT_PAYLOAD_MTU) {
                errno = EMSGSIZE; // Message too large to send atomically via underlying protocol, don't send
                return -1;
            }
            buf = malloc(tot_len);
            if(tot_len != 0 && buf == NULL) {
                errno = ENOMEM; // Unable to allocate space for message
                return -1;
            }
            p = buf;
            for(int i=0; i < message->msg_iovlen; ++i) {
                memcpy(p, iov[i].iov_base, iov[i].iov_len);
                p += iov[i].iov_len;
            }
            err = sendto(socket, buf, tot_len, flags, message->msg_name, message->msg_namelen);
            free(buf);
            return err;
        }
#endif
    
    // ------------------------------------------------------------------------------
    // ---------------------------------- recvfrom() --------------------------------
    // ------------------------------------------------------------------------------
    // int socket, void *restrict buffer, size_t length, int flags, struct sockaddr
    // *restrict address, socklen_t *restrict address_len

#if defined(__ANDROID__)
    // UDP RX
	JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1recvfrom(
        JNIEnv *env, jobject thisObj, jint fd, jbyteArray buf, jint len, jint flags, jobject ztaddr)
    {
        struct sockaddr_in addr;
        jbyte *body = (*env)->GetByteArrayElements(env, buf, 0);
        unsigned char buffer[ZT_MAX_MTU];
        int payload_offset = sizeof(int) + sizeof(struct sockaddr_storage);
        int rxbytes = zts_recvfrom(fd, &buffer, len, flags, &addr, sizeof(struct sockaddr_storage));
        if(rxbytes > 0)
            memcpy(body, (jbyte*)buffer + payload_offset, rxbytes);
        (*env)->ReleaseByteArrayElements(env, buf, body, 0);
        // Update fields of Java ZTAddress object
        jfieldID fid;
        jclass cls = (*env)->GetObjectClass(env, ztaddr);
        fid = (*env)->GetFieldID(env, cls, "port", "I");
        (*env)->SetIntField(env, ztaddr, fid, addr.sin_port);
        fid = (*env)->GetFieldID(env, cls,"_rawAddr", "J");
        (*env)->SetLongField(env, ztaddr, fid,addr.sin_addr.s_addr);        
        return rxbytes;
    }
#endif

//#if !defined(__ANDROID__)
    #ifdef DYNAMIC_LIB
        ssize_t zt_recvfrom(RECVFROM_SIG)
    #else
        ssize_t zts_recvfrom(RECVFROM_SIG)
    #endif
        {
            int tmpsz = 0; // payload size
            // dwr(MSG_DEBUG_EXTRA,"zt_recvfrom(%d, ...)\n", socket);
            if(read(socket, buffer, ZT_MAX_MTU) > 0) {
                // TODO: case for address size mismatch?
                memcpy(address, buffer, address_len);
                memcpy(&tmpsz, buffer + sizeof(struct sockaddr_storage), sizeof(tmpsz));
            }
            else {
                perror("read:\n");
            }
            return tmpsz;
        }
//#endif

    // ------------------------------------------------------------------------------
    // ----------------------------------- recvmsg() --------------------------------
    // ------------------------------------------------------------------------------
    // int socket, struct msghdr *message, int flags

#if !defined(__ANDROID__)
    #ifdef DYNAMIC_LIB
        ssize_t zt_recvmsg(RECVMSG_SIG)
    #else
        ssize_t zts_recvmsg(RECVMSG_SIG)
    #endif
        {
            dwr(MSG_DEBUG_EXTRA, "zt_recvmsg(%d)\n", socket);
            ssize_t err, n, tot_len = 0;
            char *buf, *p;
            struct iovec *iov = message->msg_iov;
            
            for(int i = 0; i < message->msg_iovlen; ++i)
                tot_len += iov[i].iov_len;
            buf = malloc(tot_len);
            if(tot_len != 0 && buf == NULL) {
                errno = ENOMEM;
                return -1;
            }
            n = err = recvfrom(socket, buf, tot_len, flags, message->msg_name, &message->msg_namelen);
            p = buf;
            
            // According to: http://pubs.opengroup.org/onlinepubs/009695399/functions/recvmsg.html
            if(err > message->msg_controllen && !( message->msg_flags & MSG_PEEK)) {
                // excess data should be disgarded
                message->msg_flags |= MSG_TRUNC; // Indicate that the buffer has been truncated
            }
            
            while (n > 0) {
                ssize_t count = n < iov->iov_len ? n : iov->iov_len;
                memcpy (iov->iov_base, p, count);
                p += count;
                n -= count;
                ++iov;
            }
            free(buf);
            return err;
        }
#endif

    // ------------------------------------------------------------------------------
    // ----------------------- Exposed RX/TX API for UNITY 3D -----------------------
    // ------------------------------------------------------------------------------
        
#if defined(__UNITY_3D__)
        // Just expose some basic calls for configuring and RX/TXing through ZT sockets
        ssize_t zt_send(int fd, void *buf, int len) {
            return write(fd, buf, len);
        }
        
        ssize_t zt_recv(int fd, void *buf, int len) {
            return read(fd, buf, len);
        }
        
        int zt_set_nonblock(int fd) {
            return 	fcntl(fd, F_SETFL, O_NONBLOCK);
        }
#endif

    // ------------------------------------------------------------------------------
    // ----------------------- Exposed RX/TX API for Java JNI -----------------------
    // ------------------------------------------------------------------------------

#if defined(__ANDROID__)
    // TCP TX
	JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1write(JNIEnv *env, jobject thisObj, jint fd, jarray buf, jint len)
    {
        jbyte *body = (*env)->GetByteArrayElements(env, buf, 0);
        char * bufp = (char *)malloc(sizeof(char)*len);
        memcpy(bufp, body, len);
        (*env)->ReleaseByteArrayElements(env, buf, body, 0);
        int written_bytes = write(fd, body, len);
        return written_bytes;
    }
    // TCP RX
    JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1read(JNIEnv *env, jobject thisObj, jint fd, jarray buf, jint len)
    {
        jbyte *body = (*env)->GetByteArrayElements(env, buf, 0);
        int read_bytes = read(fd, body, len);
        (*env)->ReleaseByteArrayElements(env, buf, body, 0);
        return read_bytes;
    }    
#endif

    // ------------------------------------------------------------------------------
    // --------------------------------- setsockopt() -------------------------------
    // ------------------------------------------------------------------------------
    // int socket, int level, int option_name, const void *option_value, 
    // socklen_t option_len

#if defined(__ANDROID__)
	JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1setsockopt(
        JNIEnv *env, jobject thisObj, jint fd, jint level, jint optname, jint optval, jint optlen) {
        return zts_setsockopt(fd, level, optname, optval, optlen);
    }
#endif

    #ifdef DYNAMIC_LIB
    int zt_setsockopt(SETSOCKOPT_SIG)
    #else
    int zts_setsockopt(SETSOCKOPT_SIG)
    #endif
    {
        dwr(MSG_DEBUG, "zt_setsockopt()\n");
        return 0;
    }
    
    // ------------------------------------------------------------------------------
    // --------------------------------- getsockopt() -------------------------------
    // ------------------------------------------------------------------------------
    // int sockfd, int level, int optname, void *optval, 
    // socklen_t *optlen 

#if defined(__ANDROID__)
	JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1getsockopt(
        JNIEnv *env, jobject thisObj, jint fd, jint level, jint optname, jint optval, jint optlen) {
        return zts_getsockopt(fd, level, optname, optval, optlen);
    }
#endif

#ifdef DYNAMIC_LIB
    int zt_getsockopt(GETSOCKOPT_SIG)
#else
    int zts_getsockopt(GETSOCKOPT_SIG)
#endif
    {
        dwr(MSG_DEBUG,"zt_getsockopt(%d)\n", sockfd);
        if(optname == SO_TYPE) {
            int* val = (int*)optval;
            *val = 2;
            optval = (void*)val;
        }
        return 0;
    }
    
    // ------------------------------------------------------------------------------
    // ----------------------------------- socket() ---------------------------------
    // ------------------------------------------------------------------------------
    // int socket_family, int socket_type, int protocol

#if defined(__ANDROID__)
    JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1socket(JNIEnv *env, jobject thisObj, jint family, jint type, jint protocol) {
        return zts_socket(family, type, protocol);
    }
#endif

#ifdef DYNAMIC_LIB
    int zts_socket(SOCKET_SIG)
#else
    int zts_socket(SOCKET_SIG)
#endif
    {
        get_api_netpath();
        dwr(MSG_DEBUG, "zt_socket()\n");
        /* Check that type makes sense */
#if defined(__linux__)
        int flags = socket_type & ~SOCK_TYPE_MASK;
    #if !defined(__ANDROID__)
        if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK)) {
            errno = EINVAL;
            return -1;
        }
    #endif
#endif
        socket_type &= SOCK_TYPE_MASK;
        /* Check protocol is in range */
#if defined(__linux__)
        if (socket_family < 0 || socket_family >= NPROTO){
            errno = EAFNOSUPPORT;
            return -1;
        }
        if (socket_type < 0 || socket_type >= SOCK_MAX) {
            errno = EINVAL;
            return -1;
        }
#endif
        /* Assemble and send RPC */
        struct socket_st rpc_st;
        rpc_st.socket_family = socket_family;
        rpc_st.socket_type = socket_type;
        rpc_st.protocol = protocol;
#if defined(__linux__)
    #if !defined(__ANDROID__)
        rpc_st.__tid = 5; //syscall(SYS_gettid);
    #else
        rpc_st.__tid = gettid(); // dummy value
    #endif
#endif
        /* -1 is passed since we we're generating the new socket in this call */
        printf("api_netpath = %s\n", api_netpath);
        int err = rpc_send_command(api_netpath, RPC_SOCKET, -1, &rpc_st, sizeof(struct socket_st));
        dwr(MSG_DEBUG," socket() = %d\n", err);
        return err;
    }

    // ------------------------------------------------------------------------------
    // ---------------------------------- connect() ---------------------------------
    // ------------------------------------------------------------------------------
    // int __fd, const struct sockaddr * __addr, socklen_t __len

#if defined(__ANDROID__)
    JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1connect(JNIEnv *env, jobject thisObj, jint fd, jstring addrstr, jint port) {
        struct sockaddr_in addr;
        const char *str = (*env)->GetStringUTFChars(env, addrstr, 0);
        dwr(MSG_DEBUG, "zt_connect(): fd = %d\naddr = %s\nport=%d", fd, str, port);
        addr.sin_addr.s_addr = inet_addr(str);
        addr.sin_family = AF_INET;
        addr.sin_port = htons( port );
        (*env)->ReleaseStringUTFChars(env, addrstr, str);
        return zts_connect(fd, (struct sockaddr *)&addr, sizeof(addr));
    }
#endif

#ifdef DYNAMIC_LIB
    int zt_connect(CONNECT_SIG)
#else
    int zts_connect(CONNECT_SIG)
#endif
    {
        get_api_netpath();
        dwr(MSG_DEBUG,"zt_connect(%d)\n", __fd);
        struct connect_st rpc_st;
#if defined(__linux__)
    #if !defined(__ANDROID__)
        //rpc_st.__tid = syscall(SYS_gettid);
    #else
        //rpc_st.__tid = gettid(); // dummy value
    #endif
#endif
        rpc_st.__fd = __fd;
        memcpy(&rpc_st.__addr, __addr, sizeof(struct sockaddr_storage));
        memcpy(&rpc_st.__len, &__len, sizeof(socklen_t));
        return rpc_send_command(api_netpath, RPC_CONNECT, __fd, &rpc_st, sizeof(struct connect_st));
    }
    
    // ------------------------------------------------------------------------------
    // ------------------------------------ bind() ----------------------------------
    // ------------------------------------------------------------------------------
    // int sockfd, const struct sockaddr *addr, socklen_t addrlen

#if defined(__ANDROID__)
    JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1bind(JNIEnv *env, jobject thisObj, jint fd, jstring addrstr, jint port) {
        struct sockaddr_in addr;
        const char *str = (*env)->GetStringUTFChars(env, addrstr, 0);
        dwr(MSG_DEBUG, "zt_bind(): fd = %d\naddr = %s\nport=%d", fd, str, port);
        addr.sin_addr.s_addr = inet_addr(str);
        addr.sin_family = AF_INET;
        addr.sin_port = htons( port );
        (*env)->ReleaseStringUTFChars(env, addrstr, str);
        return zts_bind(fd, (struct sockaddr *)&addr, sizeof(addr));
    }
#endif

#ifdef DYNAMIC_LIB
    int zt_bind(BIND_SIG)
#else
    int zts_bind(BIND_SIG)
#endif
    {
        get_api_netpath();
        dwr(MSG_DEBUG,"zt_bind(%d)\n", sockfd);
        struct bind_st rpc_st;
        rpc_st.sockfd = sockfd;
#if defined(__linux__)
    #if !defined(__ANDROID__)
        // TODO: Candidate for removal
        rpc_st.__tid = 5;//syscall(SYS_gettid);
    #else
        rpc_st.__tid = gettid(); // dummy value
    #endif
#endif
        memcpy(&rpc_st.addr, addr, sizeof(struct sockaddr_storage));
        memcpy(&rpc_st.addrlen, &addrlen, sizeof(socklen_t));
        return rpc_send_command(api_netpath, RPC_BIND, sockfd, &rpc_st, sizeof(struct bind_st));
    }

    // ------------------------------------------------------------------------------
    // ----------------------------------- accept4() --------------------------------
    // ------------------------------------------------------------------------------
    // int sockfd, struct sockaddr *addr, socklen_t *addrlen, int flags

#if defined(__ANDROID__)
    JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1accept4(JNIEnv *env, jobject thisObj, jint fd, jstring addrstr, jint port, jint flags) {
        struct sockaddr_in addr;
        char *str;
        // = env->GetStringUTFChars(addrstr, NULL);
        (*env)->ReleaseStringUTFChars(env, addrstr, str);
        addr.sin_addr.s_addr = inet_addr(str);
        addr.sin_family = AF_INET;
        addr.sin_port = htons( port );
        return zts_accept4(fd, (struct sockaddr *)&addr, sizeof(addr), flags);
    }
#endif

#if defined(__linux__)
    #ifdef DYNAMIC_LIB
        int zt_accept4(ACCEPT4_SIG)
    #else
        int zts_accept4(ACCEPT4_SIG)
    #endif
        {
            get_api_netpath();
            dwr(MSG_DEBUG,"zt_accept4(%d):\n", sockfd);
        #if !defined(__ANDROID__)
            if ((flags & SOCK_CLOEXEC))
                fcntl(sockfd, F_SETFL, FD_CLOEXEC);
            if ((flags & SOCK_NONBLOCK))
               fcntl(sockfd, F_SETFL, O_NONBLOCK);
        #endif
            int len = !addr ? 0 : addrlen;
            return accept(sockfd, addr, len);
        }
#endif
    
    // ------------------------------------------------------------------------------
    // ----------------------------------- accept() ---------------------------------
    // ------------------------------------------------------------------------------
    // int sockfd struct sockaddr *addr, socklen_t *addrlen

#if defined(__ANDROID__)
    JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1accept(JNIEnv *env, jobject thisObj, jint fd, jstring addrstr, jint port) {
        struct sockaddr_in addr;
        // TODO: Send addr info back to Javaland
        addr.sin_addr.s_addr = inet_addr("");
        addr.sin_family = AF_INET;
        addr.sin_port = htons( port );
        return zts_accept(fd, (struct sockaddr *)&addr, sizeof(addr));    
    }
#endif

#ifdef DYNAMIC_LIB
    int zt_accept(ACCEPT_SIG)
#else
    int zts_accept(ACCEPT_SIG)
#endif
    {
        get_api_netpath();
        dwr(MSG_DEBUG,"zt_accept(%d):\n", sockfd);
    // FIXME: Find a better solution for this before production
    #if !defined(__UNITY_3D__)
        if(addr)
            addr->sa_family = AF_INET;
    #endif
        int new_fd = get_new_fd(sockfd);
        dwr(MSG_DEBUG,"newfd = %d\n", new_fd);

        if(new_fd > 0) {
            errno = ERR_OK;
            return new_fd;
        }
        errno = EAGAIN;
        return -EAGAIN;
    }
    
    // ------------------------------------------------------------------------------
    // ------------------------------------- listen()--------------------------------
    // ------------------------------------------------------------------------------
    // int sockfd, int backlog

#if defined(__ANDROID__)
    JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1listen(JNIEnv *env, jobject thisObj, jint fd, int backlog) {
        return zts_listen(fd, backlog);
    }
#endif

#ifdef DYNAMIC_LIB
    int zt_listen(LISTEN_SIG)
#else
    int zts_listen(LISTEN_SIG)
#endif
    {
        get_api_netpath();
        dwr(MSG_DEBUG,"zt_listen(%d):\n", sockfd);
        struct listen_st rpc_st;
        rpc_st.sockfd = sockfd;
        rpc_st.backlog = backlog;
#if defined(__linux__)
    #if !defined(__ANDROID__)
        rpc_st.__tid = syscall(SYS_gettid);
    #else
        rpc_st.__tid = gettid(); // dummy value
    #endif
#endif
        return rpc_send_command(api_netpath, RPC_LISTEN, sockfd, &rpc_st, sizeof(struct listen_st));
    }
    
    // ------------------------------------------------------------------------------
    // ------------------------------------- close() --------------------------------
    // ------------------------------------------------------------------------------
    // int fd

#if defined(__ANDROID__)
    JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1close(JNIEnv *env, jobject thisObj, jint fd) {
        return zts_close(fd);
    }
#endif

#ifdef DYNAMIC_LIB
    int zt_close(CLOSE_SIG) 
#else
    int zts_close(CLOSE_SIG) 
#endif
    {
        get_api_netpath();
        dwr(MSG_DEBUG, "zt_close(%d)\n", fd);
        return realclose(fd);
    }
    
    // ------------------------------------------------------------------------------
    // -------------------------------- getsockname() -------------------------------
    // ------------------------------------------------------------------------------
    // int sockfd, struct sockaddr *addr, socklen_t *addrlen
    
#if defined(__ANDROID__)
    JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1getsockname(JNIEnv *env, jobject thisObj, jint fd, jobject ztaddr) {
        struct sockaddr_in addr;
        int err = zts_getsockname(fd, &addr, sizeof(struct sockaddr));
        jfieldID fid;
        jclass cls = (*env)->GetObjectClass(env, ztaddr);
        fid = (*env)->GetFieldID(env, cls, "port", "I");
        (*env)->SetIntField(env, ztaddr, fid, addr.sin_port);
        fid = (*env)->GetFieldID(env, cls,"_rawAddr", "J");
        (*env)->SetLongField(env, ztaddr, fid,addr.sin_addr.s_addr);        
        return err;    
    }
#endif

#ifdef DYNAMIC_LIB
    int zt_getsockname(GETSOCKNAME_SIG)
#else
    int zts_getsockname(GETSOCKNAME_SIG)
#endif
    {
        get_api_netpath();
        dwr(MSG_DEBUG_EXTRA,"zt_getsockname(%d):\n", sockfd);
        struct getsockname_st rpc_st;
        rpc_st.sockfd = sockfd;
        memcpy(&rpc_st.addrlen, &addrlen, sizeof(socklen_t));
        int rpcfd = rpc_send_command(api_netpath, RPC_GETSOCKNAME, sockfd, &rpc_st, sizeof(struct getsockname_st));
        // read address info from service
        char addrbuf[sizeof(struct sockaddr_storage)];
        memset(&addrbuf, 0, sizeof(struct sockaddr_storage));
        if(rpcfd > -1) {
            int err = read(rpcfd, &addrbuf, sizeof(struct sockaddr));
            close(rpcfd);
            if(err > 0) {
                int sum=0;
                for(int i=0;i<sizeof(struct sockaddr_storage);i++) {
                    sum|=addrbuf[i];
                }
                if(!sum) { // RXed a zero-ed address buffer, currently the only way to signal a problem
                    errno = ENOTSOCK; // TODO: general error, needs to be more specific
                    dwr(MSG_ERROR, "zt_getpeername(): no address info given by service.\n");
                    return -1;
                }
            } 
            else {
                errno = ENOTSOCK; // TODO: general error, needs to be more specific
                dwr(MSG_ERROR, "zt_getpeername(): unable to read address info from service.\n", err);
                return -1;
            }
        }
        struct sockaddr_storage sock_storage;
        memcpy(&sock_storage, addrbuf, sizeof(struct sockaddr));
        addrlen = sizeof(struct sockaddr_in);
        memcpy(addr, &sock_storage, sizeof(struct sockaddr));
        addr->sa_family = AF_INET;
        return 0;
    }

    // ------------------------------------------------------------------------------
    // -------------------------------- getpeername() -------------------------------
    // ------------------------------------------------------------------------------
    // int sockfd, struct sockaddr *addr, socklen_t *addrlen
    
#if defined(__ANDROID__)
    JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1getpeername(JNIEnv *env, jobject thisObj, jint fd, jobject ztaddr) {
        struct sockaddr_in addr;
        int err = zts_getpeername(fd, &addr, sizeof(struct sockaddr));
        jfieldID fid;
        jclass cls = (*env)->GetObjectClass(env, ztaddr);
        fid = (*env)->GetFieldID(env, cls, "port", "I");
        (*env)->SetIntField(env, ztaddr, fid, addr.sin_port);
        fid = (*env)->GetFieldID(env, cls,"_rawAddr", "J");
        (*env)->SetLongField(env, ztaddr, fid,addr.sin_addr.s_addr);        
        return err;
    }
#endif

#ifdef DYNAMIC_LIB
    int zt_getpeername(GETSOCKNAME_SIG)
#else
    int zts_getpeername(GETSOCKNAME_SIG)
#endif
    {
        get_api_netpath();
        dwr(MSG_DEBUG_EXTRA,"zt_getpeername(%d):\n", sockfd);
        struct getsockname_st rpc_st;
        rpc_st.sockfd = sockfd;
        memcpy(&rpc_st.addrlen, &addrlen, sizeof(socklen_t));
        int rpcfd = rpc_send_command(api_netpath, RPC_GETPEERNAME, sockfd, &rpc_st, sizeof(struct getsockname_st));
        // read address info from service
        char addrbuf[sizeof(struct sockaddr_storage)];
        memset(&addrbuf, 0, sizeof(struct sockaddr_storage));

        if(rpcfd > -1) {
            int err = read(rpcfd, &addrbuf, sizeof(struct sockaddr));
            close(rpcfd);
            if(err > 0) {
                int sum=0;
                for(int i=0;i<sizeof(struct sockaddr_storage);i++) {
                    sum|=addrbuf[i];
                }
                if(!sum) { // RXed a zero-ed address buffer, currently the only way to signal a problem
                    errno = ENOTSOCK; // TODO: general error, needs to be more specific
                    dwr(MSG_ERROR, "zt_getpeername(): no address info given by service.\n");
                    return -1;
                }
            } 
            else {
                errno = ENOTSOCK; // TODO: general error, needs to be more specific
                dwr(MSG_ERROR, "zt_getpeername(): unable to read address info from service.\n", err);
                return -1;
            }
        }
        struct sockaddr_storage sock_storage;
        memcpy(&sock_storage, addrbuf, sizeof(struct sockaddr));
        addrlen = sizeof(struct sockaddr_in);
        memcpy(addr, &sock_storage, sizeof(struct sockaddr));
        addr->sa_family = AF_INET;
        return 0;
    }

    // ------------------------------------------------------------------------------
    // ------------------------------------ fcntl() ---------------------------------
    // ------------------------------------------------------------------------------
    // int fd, int cmd, int flags

    #if defined(__ANDROID__)
	JNIEXPORT jint JNICALL Java_ZeroTier_SDK_zt_1fcntl(JNIEnv *env, jobject thisObj, jint fd, jint cmd, jint flags) {
        return zts_fcntl(fd,cmd,flags);
    }
#endif

#ifdef DYNAMIC_LIB
    int zt_fcntl(FCNTL_SIG)
#else
    int zts_fcntl(FCNTL_SIG)
#endif
    {
        dwr(MSG_DEBUG_EXTRA,"zt_fcntl(%d, %d, %d)\n", fd, cmd, flags);
        return fcntl(fd,cmd,flags);
    }

#ifdef __cplusplus
}
#endif