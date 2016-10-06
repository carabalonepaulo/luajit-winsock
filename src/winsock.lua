--[[
Copyright (c) 2015, Paulo Fernando Linhares Carabalone

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]

local ffi = require 'ffi'
local bit = require 'bit'

INVALID_SOCKET = 4294967295

function MAKEWORD(low, high)
    return bit.bor(low, bit.lshift(high, 8))
end

ffi.cdef [[
typedef unsigned short ushort;
typedef unsigned long ulong;
typedef unsigned char uchar;
typedef unsigned int uint;
typedef long SOCKET;
typedef unsigned char WORD;
typedef unsigned char BYTE;

typedef struct {
    WORD           wVersion;
    WORD           wHighVersion;
    char           szDescription[256];
    char           szSystemStatus[129];
    unsigned short iMaxSockets;
    unsigned short iMaxUdpDg;
    char           *lpVendorInfo;
} WSADATA, *LPWSADATA;

typedef struct {
    ulong s_addr;
} in_addr;

typedef struct {
    ushort sa_family;
    char sa_data[14];
} sockaddr;

typedef struct {
    short sin_family;
    ushort sin_port;
    in_addr sin_addr;
    char sin_zero[8];
} sockaddr_in;

typedef struct {
    uint fd_count;
    SOCKET fd_array[2048];
} fd_set;

typedef struct {
    long tv_sec;
    long tv_usec;
} timeval;

int WSAStartup(WORD wVersionRequested, LPWSADATA lpWSAData);
int WSAGetLastError(void);

ushort htons(ushort hostshort);
ulong inet_addr(const char *cp);

SOCKET socket(int af, int type, int protocol);
SOCKET accept(SOCKET s, struct sockaddr *adrr, int *addrlen);
int listen(SOCKET s, int backlog);
int bind(SOCKET s, const struct sockaddr *name, int namelen);
int connect(SOCKET s, const struct sockaddr *name, int namelen);
int send(SOCKET s, const char *buf, int len, int flags);
int ioctlsocket(SOCKET s, long cmd, ulong *argp);
int recv(SOCKET s, char *buf, int len, int flags);
int closesocket(SOCKET s);
int shutdown(SOCKET s, int how);
int setsockopt(SOCKET s, int level, int optname, const char *optval, int optlen);
int select(int nfds, fd_set *read, fd_set *write, fd_set *except, const struct timeval *timeout);
FD_SET(int fd, fd_set *fdset);
void FD_CLR(int fd, fd_set *fdset);
int FD_ISSET(int fd, fd_set *fdset);
FD_ZERO(fd_set *fdset); 
]]

local winsock = ffi.load('ws2_32.dll')
return winsock
