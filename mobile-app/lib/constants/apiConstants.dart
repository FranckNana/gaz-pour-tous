class ApiConstants {
  static String apiEndpoint = "localhost";
  static String baseUrl = "http://$apiEndpoint";
  static String fillerEndpoint = "$baseUrl/emplisseur";
  static String fillerFillBottleEndpoint = "$fillerEndpoint/fill-empty-bottle";
  static String fillerReceiveBottleEndpoint =
      "$fillerEndpoint/receive-empty-bottle";
  static String fillerShipBottleEndpoint = "$fillerEndpoint/ship-bottle";
  static String marketerEndpoint = "$baseUrl/marketeur";
  static String marketerReceiveEmptyBottleEndpoint =
      "$marketerEndpoint/receive-empty-bottle";
  static String marketerReceiveFilledBottleEndpoint =
      "$marketerEndpoint/receive-full-bottle";
  static String marketerShipBottleEndpoint =
      "$marketerEndpoint/ship-full-bottle";
  static String currentBottlesEndpoint = "$baseUrl/current-bottles";
  static String loginEndpoint = "$baseUrl/login";
  static String logoutEndpoint = "$baseUrl/logout";
  static String resellerEndpoint = "$baseUrl/revendeur";
  static String resellerReceiveFilledBottleEndpoint =
      "$resellerEndpoint/receive-full-bottle";
  static String resellerReceiveEmptyFromClientBottleEndpoint =
      "$resellerEndpoint/receive-bottle-from-client";
  static String resellerSellFilledBottleToClientEndpoint =
      "$resellerEndpoint/sell-bottle";
  static String resellerShipEmptyBottleToMarketerEndpoint =
      "$resellerEndpoint/ship-bottle";

  static String verifyBottleHashEndpoint = "$baseUrl/verify-bottle-hash";

  static setEndpoint(String endpoint) {
    print("========== remote config endpoint value ============");
    apiEndpoint = endpoint;
    print("=========  $apiEndpoint ===============================");
    print("========== remote config endpoint value ============");
  }
}
