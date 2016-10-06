local winsock = require 'winsock'
local ffi = require 'ffi'
--------------
AF_UNSPEC         = 0
AF_INET           = 2
AF_IPX            = 6
AF_APPLETALK      = 16
AF_NETBIOS        = 17
AF_INET6          = 23
AF_IRDA           = 26
AF_BTH            = 32
--------------
SOCK_STREAM       = 1
SOCK_DGRAM        = 2
SOCK_RAW          = 3
SOCK_RDM          = 4
SOCK_SEQPACKET    = 5
--------------
IPPROTO_ICMP      = 1
IPPROTO_IGMP      = 2
BTHPROTO_RFCOMM   = 3
IPPROTO_TCP       = 6
IPPROTO_UDP       = 17
IPPROTO_ICMPV6    = 58
IPPROTO_RM        = 113
--------------
SD_RECEIVE        = 0
SD_SEND           = 1
SD_BOTH           = 2
--------------
IP                = 0
IPv6              = 41
Socket            = 65535
TCP               = 6
UDP               = 17
--------------
local Socket = {}
Socket.__index = Socket

function Socket:new(addr, type, protocol)
    local self = setmetatable({}, Socket)
    --------------
    self.addressFamily = addr
    self.socketType = type
    self.protocolType = protocol
    --------------
    self.wsa = ffi.new('WSADATA')
    if winsock.WSAStartup(MAKEWORD(2, 2), self.wsa) < 0 then error('Error wsastartup') end
    --------------
    self.descriptor = winsock.socket(addr, type, protocol)
    if self.descriptor < 0 then error('Error socket: '..winsock.WSAGetLastError()) end
    --------------
    return self
end

function Socket:accept()
    local sock = winsock.accept(self.descriptor)
	if sock == INVALID_SOCKET then
        error('Error accept: '..winsock.WSAGetLastError())
	else
        return sock
    end
end

function Socket:bind(host)
    local service = ffi.new('sockaddr_in')
    service.sin_family = 2
    service.sin_addr.s_addr = winsock.inet_addr(host)
    service.sin_port = winsock.htons(port)
    --------------
    local sock_addr = ffi.cast('const struct sockaddr *', service)
    if winsock.bind(socket, nil, 0) < 0 then error('Error bind: '..winsock.WSAGetLastError()) end
end

function Socket:close()
    if winsock.closesocket(self.descriptor) < 0 then error('Erro closesocket: '..winsock.WSAGetLastError()) end
end

function Socket:connect(host, port)
    local service = ffi.new('sockaddr_in')
    service.sin_family = 2
    service.sin_addr.s_addr = winsock.inet_addr(host)
    service.sin_port = winsock.htons(port)
    --------------
    local sock_addr = ffi.cast('const struct sockaddr *', service)
    if winsock.connect(self.descriptor, sock_addr, ffi.sizeof(service)) < 0 then error('Error connect: '..winsock.WSAGetLastError()) end
end

function Socket:listen(backlog)
    if winsock.listen(self.descriptor, backlog) < 0 then error('Erro listen: '..winsock.WSAGetLastError()) end
end

function Socket:available()
    local buff = ffi.new('unsigned int[1]')
    if winsock.ioctlsocket(self.socket, 1074030207, buff) < 0 then error('Erro available: '..winsock.WSAGetLastError()) end
    return buff[0]
end

function Socket:recv(len, flags)
    flags = flags or 0
    local buff = ffi.new('char[?]', len)
    if winsock.recv(self.descriptor, buff, len, flags) < 0 then error('Error receive: '..winsock.WSAGetLastError())
    else return string.sub(ffi.string(buff), 0, len - 1) end
end

function Socket:send(message, flags)
    flags = flags or 0
    if winsock.send(self.descriptor, message, #message, flags) < 0 then error('Error send: '..winsock.WSAGetLastError()) end
end

function Socket:shutdown(how)
    if winsock.shutdown(self.descriptor, how) < 0 then error('Error shutdown: '..winsock.WSAGetLastError()) end
end

return Socket
