import 'dart:convert';

import 'package:gazpourtous/constants/apiConstants.dart';
import 'package:gazpourtous/constants/httpClient.dart';
import 'package:gazpourtous/models/bottleModel.dart';

class BottleService {
  final _httpClient = HttpClient.getInstance();

  //final cookieJar = Get.find();

  Future<List<BottleModel>> getBottles() async {
    ///print(await cookieJar.loadForRequest(Uri.parse("https://dart.dev")));

    try {
      final response =
          await _httpClient.get(ApiConstants.currentBottlesEndpoint);
      if (response.statusCode == 200) {
        final List json = jsonDecode(response.data);
        return json.map((m) => BottleModel.fromJson(m)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String> fillerScanFilledBottleReadyToDeliverToMarketer(code) async {
    try {
      final response = await _httpClient.post(
          ApiConstants.fillerShipBottleEndpoint,
          data: {"bottleHash": code});
      return response.statusCode == 200 ? "success" : "error";
    } catch (e) {
      return "error";
    }
  }

  Future<String> fillerScanReceivedEmptyBottle(code) async {
    try {
      final response = await _httpClient.post(
          ApiConstants.fillerReceiveBottleEndpoint,
          data: {"bottleHash": code});
      return response.statusCode == 200 ? "success" : "error";
    } catch (e) {
      return "error";
    }
  }

  Future<String> fillerScanFilledBottle(code) async {
    try {
      final response = await _httpClient.post(
          ApiConstants.fillerFillBottleEndpoint,
          data: {"bottleHash": code});
      return response.statusCode == 200 ? "success" : "error";
    } catch (e) {
      return "error";
    }
  }

  Future<String> marketerShipFilledBottle(code) async {
    try {
      final response = await _httpClient.post(
          ApiConstants.marketerShipBottleEndpoint,
          data: {"bottleHash": code});
      return response.statusCode == 200 ? "success" : "error";
    } catch (e) {
      return "error";
    }
  }

  Future<String> marketerReceiveFilledBottle(code) async {
    try {
      final response = await _httpClient.post(
          ApiConstants.marketerReceiveFilledBottleEndpoint,
          data: {"bottleHash": code});
      return response.statusCode == 200 ? "success" : "error";
    } catch (e) {
      return "error";
    }
  }

  Future<String> marketerReceiveEmptyBottle(code) async {
    try {
      final response = await _httpClient.post(
          ApiConstants.marketerReceiveEmptyBottleEndpoint,
          data: {"bottleHash": code});
      return response.statusCode == 200 ? "success" : "error";
    } catch (e) {
      return "error";
    }
  }

  Future<String> resellerReceiveFilledBottle(code) async {
    try {
      final response = await _httpClient.post(
          ApiConstants.resellerReceiveFilledBottleEndpoint,
          data: {"bottleHash": code});
      return response.statusCode == 200 ? "success" : "error";
    } catch (e) {
      return "error";
    }
  }

  Future<String> resellerReceiveEmptyBottleFromClient(
      bottleCode, clientCode) async {
    try {
      final response = await _httpClient.post(
          ApiConstants.resellerReceiveEmptyFromClientBottleEndpoint,
          data: {"bottleHash": bottleCode, "clientHash": clientCode});
      return response.statusCode == 200 ? "success" : "error";
    } catch (e) {
      return "error";
    }
  }

  Future<String> resellerSellFilledBottleToClient(
      bottleCode, clientCode, amount, mode, ref) async {
    try {
      final response = await _httpClient
          .post(ApiConstants.resellerSellFilledBottleToClientEndpoint, data: {
        "bottleHash": bottleCode,
        "clientHash": clientCode,
        "amount": int.parse(amount),
        "mode": "$mode - $ref"
      });
      return response.statusCode == 200 ? "success" : "error";
    } catch (e) {
      return "error";
    }
  }

  Future<String> resellerShipEmptyBottleToMarketer(bottleCode) async {
    try {
      final response = await _httpClient.post(
          ApiConstants.resellerShipEmptyBottleToMarketerEndpoint,
          data: {"bottleHash": bottleCode});
      return response.statusCode == 200 ? "success" : "error";
    } catch (e) {
      return "error";
    }
  }

  Future<bool> verifyBotteHash(bottleCode) async {
    try {
      final response = await _httpClient.get(
          "${ApiConstants.verifyBottleHashEndpoint}?q=${Uri.encodeComponent(bottleCode)}");
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
