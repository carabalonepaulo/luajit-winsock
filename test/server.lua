local server = TcpServer:new(5000)
server:start(10)

while true do
	if avaliable(client) > 0 then print(recv(client, avaliable(client))) end
end