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
}
