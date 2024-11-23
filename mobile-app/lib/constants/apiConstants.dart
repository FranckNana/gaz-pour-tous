class ApiConstants {
  static const baseUrl = "http://192.168.1.73:5000";
  static const fillerEndpoint = "$baseUrl/emplisseur";
  static const fillerFillBottleEndpoint = "$fillerEndpoint/fill-empty-bottle";
  static const fillerReceiveBottleEndpoint =
      "$fillerEndpoint/receive-empty-bottle";
  static const fillerShipBottleEndpoint = "$fillerEndpoint/ship-bottle";
  static const marketerEndpoint = "$baseUrl/marketeur";
  static const marketerReceiveEmptyBottleEndpoint =
      "$marketerEndpoint/receive-empty-bottle";
  static const marketerReceiveFilledBottleEndpoint =
      "$marketerEndpoint/receive-full-bottle";
  static const marketerShipBottleEndpoint =
      "$marketerEndpoint/ship-full-bottle";
  static const currentBottlesEndpoint = "$baseUrl/current-bottles";
  static const loginEndpoint = "$baseUrl/login";
  static const logoutEndpoint = "$baseUrl/logout";
}
