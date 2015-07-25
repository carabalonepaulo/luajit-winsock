local winsock = require 'winsock'
local ffi = require 'ffi'

TcpServer = {}
TcpServer.__index = TcpServer

function TcpServer:new(port)
    local wsa = ffi.new("WSADATA")
    if winsock.WSAStartup(MAKEWORD(2, 2), wsa) < 0 then error("Erro wsastartup") end
    -------------
    local socket = winsock.socket(2, 1, 6)
    if socket < 0 then error("Erro socket") end
    -------------
    local service = ffi.new("sockaddr_in")
    service.sin_family = 2
    service.sin_addr.s_addr = winsock.inet_addr(host)
    service.sin_port = winsock.htons(port)
    local sock_addr = ffi.cast("const struct sockaddr *", service)
    if winsock.bind(socket, nil, 0) < 0 then error("Erro bind") end
    -------------
    local self = { wsa = wsa, socket = socket, port = port }
    return setmetatable(self, TcpServer)
end

function TcpServer:start(backlog)
	self.backlog = backlog
	if winsock.listen(self.socket, backlog) < 0 then error("Erro listen") end
end

function TcpServer:stop()
	if winsock.closesocket(self.socket) < 0 then error("Erro closesocket") end
end

function TcpServer:accept()
	local sock = winsock.accept(self.socket)
	if sock == INVALID_SOCKET then error("Erro accept")
	else return sock end
end