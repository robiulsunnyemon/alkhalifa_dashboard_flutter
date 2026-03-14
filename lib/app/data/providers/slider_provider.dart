import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import '../api_constants.dart';

class SliderProvider {
  final _storage = GetStorage();

  String? get _token => _storage.read('token');

  Future<http.Response> getAllSliders() async {
    return await http.get(
      Uri.parse(ApiConstants.sliders),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
  }

  Future<http.StreamedResponse> createSlider({
    required String? title,
    required String? linkUrl,
    required List<int> imageBytes,
    required String fileName,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.sliders));
    
    request.headers.addAll({
      "Authorization": "Bearer $_token",
    });

    if (title != null) request.fields['title'] = title;
    if (linkUrl != null) request.fields['link_url'] = linkUrl;
    
    // Determine mime type from extension
    String mimeType = "image/jpeg"; // default
    if (fileName.toLowerCase().endsWith(".png")) mimeType = "image/png";
    if (fileName.toLowerCase().endsWith(".webp")) mimeType = "image/webp";
    if (fileName.toLowerCase().endsWith(".gif")) mimeType = "image/gif";

    request.files.add(http.MultipartFile.fromBytes(
      'image',
      imageBytes,
      filename: fileName,
      contentType: MediaType.parse(mimeType),
    ));

    return await request.send();
  }

  Future<http.Response> updateSlider(int id, Map<String, dynamic> data) async {
    return await http.put(
      Uri.parse("${ApiConstants.sliders}/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> deleteSlider(int id) async {
    return await http.delete(
      Uri.parse("${ApiConstants.sliders}/$id"),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
  }
}
