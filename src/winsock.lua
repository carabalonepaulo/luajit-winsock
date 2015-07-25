local ffi = require 'ffi'
local bit = require 'bit'

INVALID_SOCKET = 4294967295

function MAKEWORD(low, high)
    return bit.bor(low, bit.lshift(high, 8))
end

ffi.cdef[[
    typedef unsigned short ushort;
    typedef unsigned long ulong;
    typedef unsigned char uchar;
    typedef unsigned int uint;
    typedef long SOCKET;
    typedef unsigned char WORD;
    typedef unsigned char BYTE;

    typedef struct WSAData {
        WORD           wVersion;
        WORD           wHighVersion;
        char           szDescription[256];
        char           szSystemStatus[129];
        unsigned short iMaxSockets;
        unsigned short iMaxUdpDg;
        char           *lpVendorInfo;
    } WSADATA, *LPWSADATA;

    typedef struct in_addr {
        ulong s_addr;
    };

    struct sockaddr {
        ushort sa_family;
        char sa_data[14];
    };

    typedef struct {
        short sin_family;
        ushort sin_port;
        struct in_addr sin_addr;
        char sin_zero[8];
    } sockaddr_in;

    typedef struct fd_set {
        uint fd_count;
        SOCKET fd_array[64];
    } fd_set;

    typedef struct timeval {
        long tv_sec;
        long tv_usec;
    } timeval;

    int WSAStartup(WORD wVersionRequested, LPWSADATA lpWSAData);
    int WSAGetLastError(void);

    ushort htons(ushort hostshort);
    ulong inet_addr(const char *cp);

    SOCKET socket(int af, int type, int protocol);
    SOCKET accept(SOCKET s, struct sockaddr * adrr, int * addrlen);
    int listen(SOCKET s, int backlog);
    int bind(SOCKET s, const struct sockaddr * name, int namelen);
    int connect(SOCKET s, const struct sockaddr * name, int namelen);
    int send(SOCKET s, const char * buf, int len, int flags);
    int select(int nfds, fd_set * read, fd_set * write, fd_set * except, const struct timeval * timeout);
    int ioctlsocket(SOCKET s, long cmd, ulong * argp);
    int recv(SOCKET s, char * buf, int len, int flags);
    int closesocket(SOCKET s);
]]

local winsock = ffi.load('ws2_32.dll')
return winsock