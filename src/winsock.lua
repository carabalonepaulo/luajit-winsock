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

function MAKEWORD(low, high)
	return bit.bor(low, bit.lshift(high, 8))
end

function LOWBYTE(word)
	return bit.band(word, 0xff)
end

function HIGHBYTE(word)
	return bit.band(bit.rshift(word, 8), 0xff)
end

function _IO(x, y)
	return bit.bor(0x20000000, bit.lshift(x,8), y)
end

function _IOR(x, y, t)
	return bit.bor(0x40000000, bit.lshift(bit.band(ffi.sizeof(t), 0x7f), 16), bit.lshift(x, 8), y)
end

function _IOW(x, y, t)
	return bit.bor(0x80000000, bit.lshift(bit.band(ffi.sizeof(t), 0x7f), 16), bit.lshift(x, 8), y)
end

function _WSAIO(x, y)
	return bit.bor(0x20000000, x, y)
end

function _WSAIOR(x, y)
	return bit.bor(0x40000000, x, y)
end

function _WSAIOW(x, y)
	return bit.bor(0x80000000, x, y)
end

function _WSAIORW(x, y)
	return bit.bor(bit.bor(0x80000000, 0x40000000), x, y)
end

function FD_ZERO(set)
	set.fd_count = 0
	return true
end

function FD_CLR(fd, set)
	while true do
		for i = 0, set.fd_count, 1 do
			if set.fd_array[i] == fd then
				while i < set.fd_count - 1 do
					set.fd_array[i] = set.fd_array[i + 1]
					i = i + 1
				end
				set.fd_count = set.fd_count - 1
				break
			end
		end
	end
end

function FD_SET(fd, set)
	while true do
		for i = 0, set.fd_count, 1 do
			if set.fd_array[i] == fd then
				break
			end
		end

		if i == set.fd_count then
			if set.fd_count < FD_SETSIZE then
				set.fd_array[i] = fd
				set.fd_count = set.fd_count + 1
			end
		end
	end
end

--
-- Constants
--
INVALID_SOCKET		= 4294967295
SOCKET_ERROR 		= -1
--------------
AF_UNSPEC 			= 0
AF_UNIX 			= 1
AF_INET 			= 2
AF_IMPLINK 			= 3
AF_PUP 				= 4
AF_CHAOS 			= 5
AF_IPX 				= 6
AF_NS 				= 6
AF_ISO 				= 7
AF_OSI 				= AF_ISO
AF_ECMA 			= 8
AF_DATAKIT 			= 9
AF_CCITT 			= 10
AF_SNA 				= 11
AF_DECnet 			= 12
AF_DLI 				= 13
AF_LAT 				= 14
AF_HYLINK 			= 15
AF_APPLETALK 		= 16
AF_NETBIOS 			= 17
AF_VOICEVIEW 		= 18
AF_FIREFOX 			= 19
AF_UNKNOWN1 		= 20
AF_BAN 				= 21
AF_INET6  			= 23
AF_IRDA   			= 26
AF_NETDES       	= 28
AF_TCNPROCESS   	= 29
AF_TCNMESSAGE   	= 30
AF_ICLFXBM      	= 31
AF_BTH				= 32
AF_LINK 			= 33
AF_MAX 				= 34
--------------
SOCK_STREAM       	= 1
SOCK_DGRAM        	= 2
SOCK_RAW          	= 3
SOCK_RDM          	= 4
SOCK_SEQPACKET    	= 5
--------------
IPPROTO_IP						= 0
IPPROTO_ICMP					= 1
IPPROTO_IGMP					= 2
IPPROTO_GGP						= 3
IPPROTO_TCP						= 6
IPPROTO_PUP						= 12
IPPROTO_UDP						= 17
IPPROTO_IDP						= 22
IPPROTO_RDP						= 27
IPPROTO_IPV6					= 41
IPPROTO_ROUTING					= 43
IPPROTO_FRAGMENT				= 44
IPPROTO_ESP						= 50
IPPROTO_AH						= 51
IPPROTO_ICMPV6					= 58
IPPROTO_NONE					= 59
IPPROTO_DSTOPTS					= 60
IPPROTO_ND						= 77
IPPROTO_ICLFXBM					= 78
IPPROTO_PIM						= 103
IPPROTO_PGM						= 113
IPPROTO_RM						= IPPROTO_PGM
IPPROTO_L2TP					= 115
IPPROTO_SCTP					= 132
IPPROTO_RAW          			= 255
IPPROTO_MAX          			= 256
IPPROTO_RESERVED_RAW 			= 257
IPPROTO_RESERVED_IPSEC 			= 258
IPPROTO_RESERVED_IPSECOFFLOAD 	= 259
IPPROTO_RESERVED_MAX 			= 260
--------------
SD_RECEIVE       	= 0
SD_SEND           	= 1
SD_BOTH          	= 2
--------------
IP                	= 0
IPv6              	= 41
Socket           	= 65535
TCP               	= 6
UDP             	= 17
--------------
IOCPARM_MASK		= 0x7f
IOC_VOID 			= 0x20000000
IOC_OUT 			= 0x40000000
IOC_IN 				= 0x80000000
IOC_INOUT			= bit.bor(IOC_IN, IOC_OUT)
--------------
IP_OPTIONS         	= 1
IP_MULTICAST_IF   	= 2
IP_MULTICAST_TTL   	= 3
IP_MULTICAST_LOOP  	= 4
IP_ADD_MEMBERSHIP  	= 5
IP_DROP_MEMBERSHIP 	= 6
IP_TTL             	= 7
IP_TOS             	= 8
IP_DONTFRAGMENT 	= 9
--------------
FIONREAD    		= _IOR(string.byte('f'), 127, 'uint32_t')
FIONBIO     		= _IOW(string.byte('f'), 126, 'uint32_t')
FIOASYNC 			= _IOW(string.byte('f'), 125, 'uint32_t')
--------------
IOC_UNIX        	= 0x00000000;
IOC_WS2         	= 0x08000000;
IOC_PROTOCOL   		= 0x10000000;
IOC_VENDOR 			= 0x18000000;
--------------
SIO_ASSOCIATE_HANDLE         		=  _WSAIOW(IOC_WS2, 1);
SIO_ENABLE_CIRCULAR_QUEUEING 		= _WSAIO(IOC_WS2, 2);
SIO_FIND_ROUTE                		= _WSAIOR(IOC_WS2, 3);
SIO_FLUSH                     		= _WSAIO(IOC_WS2, 4);
SIO_GET_BROADCAST_ADDRESS     		= _WSAIOR(IOC_WS2, 5);
SIO_GET_EXTENSION_FUNCTION_POINTER	= _WSAIORW(IOC_WS2, 6);
SIO_GET_QOS                   		= _WSAIORW(IOC_WS2, 7);
SIO_GET_GROUP_QOS             		= _WSAIORW(IOC_WS2, 8);
SIO_MULTIPOINT_LOOPBACK       		= _WSAIOW(IOC_WS2, 9);
SIO_MULTICAST_SCOPE           		= _WSAIOW(IOC_WS2, 10);
SIO_SET_QOS                   		= _WSAIOW(IOC_WS2, 11);
SIO_SET_GROUP_QOS             		= _WSAIOW(IOC_WS2, 12);
SIO_TRANSLATE_HANDLE          		= _WSAIORW(IOC_WS2, 13);
SIO_ROUTING_INTERFACE_QUERY   		= _WSAIORW(IOC_WS2, 20);
SIO_ROUTING_INTERFACE_CHANGE  		= _WSAIOW(IOC_WS2, 21);
SIO_ADDRESS_LIST_QUERY        		= _WSAIOR(IOC_WS2, 22);
SIO_ADDRESS_LIST_CHANGE      		= _WSAIO(IOC_WS2, 23);
SIO_QUERY_TARGET_PNP_HANDLE 		= _WSAIOR(IOC_WS2, 24);

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
	union {
		struct {
			uchar s_b1, s_b2, s_b3, s_b4;
			} s_un_b;
		struct {
			ushort s_w1, s_w2;
		} s_un_w;
		uint s_addr;
	};
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
]]

local winsock = ffi.load('ws2_32.dll')
return winsock
