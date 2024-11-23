class ApiConstants {
  static const baseUrl = "http://35.180.117.75:5000";
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
  static const resellerEndpoint = "$baseUrl/revendeur";
  static const resellerReceiveFilledBottleEndpoint =
      "$resellerEndpoint/receive-full-bottle";
  static const resellerReceiveEmptyFromClientBottleEndpoint =
      "$resellerEndpoint/receive-bottle-from-client";
  static const resellerSellFilledBottleToClientEndpoint =
      "$resellerEndpoint/sell-bottle";
  static const resellerShipEmptyBottleToMarketerEndpoint =
      "$resellerEndpoint/ship-bottle";
}
