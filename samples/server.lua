local Socket = require 'socket'
--------------
local socket = Socket:new(AF_INET, SOCK_STREAM, IPPROTO_TCP)
socket:bind('127.0.0.1', 5000)
socket:listen(32)
--------------
winsock.ioctlsocket(socket.descriptor, FIONBIO, 1)
--------------
while true do
	if socket.select(socket, nil, nil, 0) then
		local client = socket:accept()
		client:send('hello world!')
		client:close()
	end
end