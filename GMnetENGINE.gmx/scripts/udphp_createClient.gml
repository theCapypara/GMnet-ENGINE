///udphp_createClient(udp_socket,server_ip,buffer,directconnect,directconnect_port)

/*
**  Description:
**      This script will "register" a client for udp holepunching, assign a number to it
**      and activate all GMnet PUNCH functions for this client id.
**      Requirement: Configured GMnet PUNCH (udphp_config)
**  
**  Usage:
**      udphp_createClient(udp_socket,server_ip,buffer,directconnect,directconnect_port)
**
**  Arguments:
**      udp_docket         udp socket*    A UDP socket created with network_create_socket
**      server_ip          string         The IP of the server to connect to
**      buffer             buffer         A buffer that will be used to send data
**      directconnect      boolean        If true, holepunching will be skipped and we attempt
**                                        to connect to the server directly
**      directconnect_port real           When you want to connect directly, we need the port
**                                        the server listens on. This will be ignored if
**                                        directconnect is set to 0, since we will get the port
**                                        from the master server. PLEASE NOTE: If the master server
**                                        connection fails or if the server is not registred at the
**                                        master server, the client will try to connect
**                                        directly using this port, so you SHOULD set it anyway
**                                        if you know it (e.g. the default port of your game
**
**  Returns:
**      client id if server was created, number smaller than 0 if an error occured
**
**  *: data type udp socket means the argument needs to be the return value of 
**     network_create_socket(network_socket_udp);
**
*/

var udp_client = argument0;
var server_ip = argument1;
var buffer = argument2;
var directconnect = argument3;
var directconnect_port = argument4;

// Create a new client instance for this client
var client = instance_create(0,0,obj_punch_client);
udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Starting...");

// Create a TCP/IP socket
var tcp_client = network_create_socket(network_socket_tcp);
client.udp_socket = udp_client;
client.tcp_socket = tcp_client;
//Add client buffer
client.buffer = buffer;

if( udp_client<0 or tcp_client<0 ){   
    //Stop client, when a socket could not be created
    udphp_handleerror(udphp_dbglvl.ERROR, udphp_dbgtarget.CLIENT, client, "Could not start Client!");
    udphp_stopClient(client);
    return false;
    exit;
}

//Set up ip and port of server (if directconnect is false, the port will be replaced later with the correct one)
client.server_ip = server_ip;
client.server_port = directconnect_port;

//Setting up connection attempt (in STEP)
client.timeout = 0;
client.directconnect = directconnect;
client.connected = false;

if (!directconnect) {
    //Send request to server when hole punching.
    //UDP -> Send port
    //See udphp_serverPunch - This is essentially the same (just for the client in this case).
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Setting up hole punch.");
    buffer_seek(buffer, buffer_seek_start, 0);
    buffer_write(buffer, buffer_string, "connect"+chr(10));
    //Please note: The master server bundled with this extension can only save one port
    //per client, this means multiple clients can not connect from the same ip at the same time.
    //(if they are CONNECTED though, a new one can be registered and connect!)
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Requesting connection Data - Sent UDP Packet");
    network_send_udp(udp_client,global.udphp_master, global.udphp_master_port, buffer, buffer_tell(buffer) );
    
    //TCP -> Send connection
    //Again see udphp_serverPunch. 
    //We also send the IP adress of the server we want to connect to, for obvious reasons ;)
    //the char(10)s are newlines that seperate two conmmands/parts of the buffer
    buffer_seek(buffer, buffer_seek_start, 0);
    buffer_write(buffer, buffer_string, "connect"+chr(10)+server_ip+chr(10));
    var err = network_connect_raw(tcp_client,global.udphp_master, global.udphp_master_port);
    
    if (err<0) {
         //When the master server is not reachable, we fall back to direct connect.
         //PLEASE NOTE: Because of this you usally WANT to specify the port even with
         //             directconnect send to false! See arguement list for details!
         udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.CLIENT, client, "Requesting connection Data - Master Server Connection failed. Fallback to direct connect.");
         client.directconnect = true;
    } else {
       //Great! Let's wait for a response.
       udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Requesting connection Data - Connected via TCP");
       err = network_send_raw(tcp_client,buffer, buffer_tell(buffer) );
        if (err<0) {
           udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.CLIENT, client, "Requesting connection Data - Master Server Connection failed. Fallback to direct connect.");
           client.directconnect = true;
       }
       else {
           udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Requesting connection Data - Sent TCP Packet");
       }
    }
} else udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "We are not holepunching on request.");

udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Started");
return client;