#client side command
#$ echo "Hello World" | nc -u 192.168.33.10 4321
#HELLO WORLD

#"Socket programming is a means of communicating data between two computers across a network. Connections can be made using either a connection-oriented protocol or a connectionless protocol. In our case, we will use TCP/IP which is a connection-oriented protocol."

#TCP example
require "socket"
require "json"
require "jwt"

host = "127.0.0.1"                  # The server IP address
#host = "api.coindesk.com"
port = 3000                         # The server port
#port = 80
path = "/tests.json"                 # The file we want
#path = "/v1/bpi/currentprice.json"
# This is the HTTP request we send to fetch a file
request = "GET #{path} HTTP/1.0\r\n\r\n" #HTTP GET request \r\n\r\n is required for HTTP requests?

#p request                          # Display request
#socket = TCPSocket.open(host, port) # Connect to server TCP
#socket.print(request)               # Send GET request to the server
#p socket                            # Display TCP socket
#response = socket.read              # Read complete response

#p response                          # Display entire packet

#Find \r\n\r\n and split and select the 2nd one
#headers, body = response.split("\r\n\r\n", 2)

#print body                          # And display it
#puts "#{path} downloaded: #{body}"

#jbody = JSON.parse(body)            # Parse the JSON string to hashes

#p jbody                             # Display hashes

#puts jbody[0]["title"]              # Display title: in hashes

#puts "Now sending the data through the UDP"

#UDP example
BUFFER_SIZE = 1024                  # Set the buffer size for the packet?

client = "10.0.0.184"               # Set the destination IP addr
socket2 = UDPSocket.new              # Create a new UDP Socket

#"Each socket needs a unique address, the combination of IP Addr and port#"
#"The process of allocating a port to a socket is called 'binding'"
socket2.bind(client, 4321)           # Bind client IP address and port#

loop do
  #print "Please type a message: "

  #p socket.recvfrom(BUFFER_SIZE)
  message, sender = socket2.recvfrom(BUFFER_SIZE) # Receive a packet from client's command line

  #p sender # eg. ["AF_INET", 49524, "10.0.0.184", "10.0.0.184"]

  port2 = sender[1]                  # Extract port# eg. 49524
  host2 = sender[2]                  # Extract the sender's IP Addr

  puts "UDP Message Received from #{host2}:#{port2} : " + message #eg. hello\n

  #pp message

  #decoded_token = JWT.decode message, nil, false

  #pp decoded_token

  socket2.send("This app allows to transfer a hash value from ruby DB, then send to the client: #{client}\n\n", 0, host2, port2)

  #socket2.send("Server: #{host}:#{port}#{path} - #{body}\n\nPlease type a message: ", 0, host, port)

  print "Please type a message: "
  #message2 = gets.chomp()
  message2 = "UDP MESSAGE TEST"

  payload = { data: message2 }
  token = JWT.encode payload, nil, "none", { typ: "JWT" }
  pp token

  socket2.send("UDP Message Received from #{host2}:#{port2} : #{token}", 0, host2, port2)

  #######################

  #TCP test in loop

  path = "/tests.json"

  socket = TCPSocket.open(host, port) # Connect to server TCP
  socket.print(request)               # Send GET request to the server
  #p socket                            # Display TCP socket
  response = socket.read              # Read complete response
  #p response
  headers, body = response.split("\r\n\r\n", 2) #HTTP GET request \r\n\r\n is required for HTTP requests?
  #print body                          # And display it
  #puts "#{path} downloaded: #{body}"
  #print body
  jbody = JSON.parse(body)            # Parse the JSON string to hashes

  p jbody
  ########################

  #UDP test in loop again

  #p jbody                             # Display hashes
  #puts jbody[0]["title"]              # Display title: in hashes
  puts "Now sending the JSON hashes/string data through the UDP"

  #"\nUDP Message Received from #{host2}:#{port2} : \n\nMessage Title: #{jbody[0]["title"]}\n  Sender: #{jbody[0]["sender"]}\n  Receiver: #{jbody[0]"receiver"]}\n  Body: #{jbody[0]["body"]}\n  \n\nPlease type a message: "

  decoded_body = JWT.decode jbody[1]["body"], nil, false
  #puts decoded_token[0]["data"]

  socket2.send("\nUDP Message Received from #{host2}:#{port2} : \n\nMessage Title: #{jbody[1]["title"]}\n  Sender: #{jbody[1]["sender"]}\n  Receiver: #{jbody[1]["receiver"]}\n  Body: #{decoded_body}\n  \n\nPlease type a message: ", 0, host2, port2)
end
