import 'dart:io';

import 'package:http/http.dart' as http;
import 'data.dart';

Future<String> uploadtoCloudinary(File? selectedImage) async {
  String cloudname = cloudName;

  var uri = Uri.parse(
    'https://api.cloudinary.com/v1_1/$cloudname/image/upload',
  );
  var request = http.MultipartRequest('POST', uri);

  var fileBytes = await selectedImage?.readAsBytes();

  var multipartFile = http.MultipartFile.fromBytes(
    'file',
    fileBytes!,
    filename: selectedImage?.path.split('/').last,
  );

  request.files.add(multipartFile);
  request.fields['upload_preset'] = uploadPreset;
  request.fields['resource_type'] = 'image';

  var response = await request.send();
  var responseBody = await response.stream.bytesToString();

  print(responseBody);

  if (response.statusCode == 200) {
    var url = responseBody.split('"secure_url":"')[1].split('","')[0];
    return url;
  } else {
    return '';
  }
}
