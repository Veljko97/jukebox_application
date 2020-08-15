
class ServerLocationsUtils{

  static String IP_ADDRESS = "";
  static String BACKEND_ADDRESS = "$IP_ADDRESS:8080";
  static String BASE_HTTP = "http://" + BACKEND_ADDRESS;
  static String BASE_WEB_SOCKET = "ws://" + BACKEND_ADDRESS;

  void setIpAddress(String ipAddress){
    IP_ADDRESS = ipAddress;
  }

}