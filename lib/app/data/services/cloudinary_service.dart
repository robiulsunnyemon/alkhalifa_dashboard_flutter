import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  final String cloudName = "dhjxwregt"; // Updated from your dashboard screenshot
  final String uploadPreset = "akfood_preset"; 

  Future<String?> uploadImage(XFile file) async {
    final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
    final request = http.MultipartRequest("POST", url);
    
    request.fields["upload_preset"] = uploadPreset;
    final bytes = await file.readAsBytes();
    request.files.add(http.MultipartFile.fromBytes("file", bytes, filename: file.name));

    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final responseString = utf8.decode(responseData);
    print("Cloudinary Response: ${response.statusCode} - $responseString");

    if (response.statusCode == 200) {
      final responseMap = jsonDecode(responseString);
      return responseMap["secure_url"];
    }
    return null;
  }
}
