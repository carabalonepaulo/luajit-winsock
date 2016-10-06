local Socket = require 'socket'
--------------
local socket = Socket:new(AF_INET, SOCK_STREAM, IPPROTO_TCP)
socket:bind('127.0.0.1')
socket:listen(32)
--------------
local client = socket:accept()
client:send('hello world!')
client:close()