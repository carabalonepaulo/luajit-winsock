local Socket = require 'socket'
--------------
local socket = Socket:new(AF_INET, SOCK_STREAM, IPPROTO_TCP)
socket:connect('127.0.0.1', 5000)
socket:send('hello world')
socket:close()
