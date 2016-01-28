///udphp_serverNetworking()

/*
**  Description:
**      Use this script in the networking event of your game (unless you are using
**      GMnet ENGINE, then we've already done this for you :) ).
** 
*       Routes the traffic from the master server to the appropiate networking script
**      e.g. htme_serverNetworking, htme_coreNetworking, 
**           htme_clientNetworking, htme_lobbyNetworking
**
**      If the traffic is not from the master server:
**      If at least one client is running:
**          Forward the traffic to htme_clientNetworking
**      If a server is running:
**          Forward the traffic to htme_serverNetworking
**  
**  Usage:
**      udphp_networking()
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/
