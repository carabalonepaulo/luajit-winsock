local winsock = require 'winsock'

TcpClient = {}
TcpClient.__index = TcpClient

function TcpClient:new(host, port)
    local wsa = ffi.new("WSADATA")
    if winsock.WSAStartup(MAKEWORD(2, 2), wsa) < 0 then error("Erro wsastartup") end
    -------------
    local socket = winsock.socket(2, 1, 6)
    if socket < 0 then error("Erro socket") end
    -------------
    local self = { socket = socket, wsa = wsa, connected = false }
    setmetatable(self, TcpClient)
    -------------
    self:connect(host, port)
    return self
end

function TcpClient:connect(host, port)
    self.host = host
    self.port = port
    -------------
    if self.connected then winsock.closesocket(self.socket) end
    -------------
    local service = ffi.new("sockaddr_in")
    service.sin_family = 2
    service.sin_addr.s_addr = winsock.inet_addr(host)
    service.sin_port = winsock.htons(port)
    local sock_addr = ffi.cast("const struct sockaddr *", service)
    if winsock.connect(self.socket, sock_addr, ffi.sizeof(service)) < 0 then error("Erro connect")
    else self.connected = true end
end

function TcpClient:send(message, flags)
    flags = flags or 0
    if winsock.send(self.socket, message, #message, flags) < 0 then error("Erro ao enviar mensagem!") end
end

function TcpClient:avaliable()
    local buff = ffi.new("unsigned int[1]")
    if winsock.ioctlsocket(self.socket, 1074030207, buff) < 0 then error("Erro avaliable") end
    return buff[0]
end

function TcpClient:receive(len)
    local str = ffi.new("char[?]", len)
    if winsock.recv(self.socket, str, len, 0) < 0 then error("Erro receive")
    else return string.sub(ffi.string(str), 0, len - 1) end
end

function TcpClient:close()
    self.connected = false
    if winsock.closesocket(self.socket) < 0 then error("Erro closesocket") end
end