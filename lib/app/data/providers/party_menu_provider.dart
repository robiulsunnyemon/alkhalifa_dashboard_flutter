import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class PartyMenuProvider {
  final _storage = GetStorage();

  String? get _token => _storage.read('token');

  Future<http.Response> getPartyMenus({int page = 1, int size = 21}) async {
    return await http.get(
      Uri.parse("${ApiConstants.partyMenu}?page=$page&size=$size"),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
  }

  Future<http.Response> getPartyMenu(int id) async {
    return await http.get(
      Uri.parse("${ApiConstants.partyMenu}/$id"),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
  }

  Future<http.Response> createPartyMenu(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse(ApiConstants.partyMenu),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> updatePartyMenu(int id, Map<String, dynamic> data) async {
    return await http.put(
      Uri.parse("${ApiConstants.partyMenu}/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> deletePartyMenu(int id) async {
    return await http.delete(
      Uri.parse("${ApiConstants.partyMenu}/$id"),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
  }
}
