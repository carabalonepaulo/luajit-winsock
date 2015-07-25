require 'tcpclient'

local client = TcpClient:new('127.0.0.1', 5000)
client:send('hello world')
client:close()
