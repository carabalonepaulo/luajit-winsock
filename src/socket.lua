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

local winsock = require 'winsock'
local ffi = require 'ffi'
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

function Socket:bind(host, port)
    self.host = host
    self.port = port
    --------------
    local service = ffi.new('sockaddr_in')
    service.sin_family = self.addressFamily
    service.sin_addr.s_addr = winsock.inet_addr(host)
    service.sin_port = winsock.htons(port)
    --------------
    local sock_addr = ffi.cast('const struct sockaddr *', service)
    if winsock.bind(self.descriptor, sock_addr, ffi.sizeof(sock_addr)) < 0 then error('Error bind: '..winsock.WSAGetLastError()) end
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

function Socket:select(read, write, except, timeval)
    local timeval = ffi.new('timeval')
    timeval.tv_sec = 0
    timeval.tv_usec = 0
    --------------
    local read_set = ffi.new('fd_set')
    FD_ZERO(read_set)
    if type(read) == 'table' then
        for _, i in pairs(read) do
            FD_SET(i, read_set)
        end
    else
        FD_SET(read, read_set)
    end
    --------------
    local write_set = ffi.new('fd_set')
    FD_ZERO(write_set)
    if type(write) == 'table' then
        for _, i in pairs(write) do
            FD_SET(i, write_set)
        end
    else
        FD_SET(write, write_set)
    end
    --------------
    local except_set = ffi.new('fd_set')
    FD_ZERO(except_set)
    if type(except) == 'table' then
        for _, i in pairs(except) do
            FD_SET(i, except_set)
        end
    else
        FD_SET(except, except_set)
    end
    -------------
    return winsock.select(read_set, write_set, except_set, timeval)
end

return Socket
