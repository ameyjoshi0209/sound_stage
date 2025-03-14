// This file contains the code to upload and delete images from Cloudinary.
// It uses the http package to send requests to the Cloudinary API.
// The uploadtoCloudinary function takes a File object as input and uploads the image to Cloudinary.
// The deleteFromCloudinary function takes the URL of the image to delete and deletes it from Cloudinary.
// The generateSignature function is a helper function to generate the signature required for deleting an image from Cloudinary.

import 'dart:io';

import 'package:http/http.dart' as http;
import 'data.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

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

Future deleteFromCloudinary(String imageLink) async {
  var publicId = imageLink.split('/').last.split('.')[0];

  String cloudname = cloudName;
  String apiKey = apikey; // Your Cloudinary API key
  String apiSecret = apiSecretKey; // Your Cloudinary API Secret

  var uri = Uri.parse(
    'https://api.cloudinary.com/v1_1/$cloudname/image/destroy',
  );

  var request = http.MultipartRequest('POST', uri);

  request.fields['public_id'] =
      publicId; // The public ID of the image you want to delete
  request.fields['api_key'] = apiKey; // Your Cloudinary API key
  request.fields['timestamp'] =
      DateTime.now().millisecondsSinceEpoch.toString();

  // Generate the signature using the public ID and timestamp
  String signature = generateSignature(publicId, apiSecret);
  request.fields['signature'] = signature;

  var response = await request.send();
  var responseBody = await response.stream.bytesToString();

  print(responseBody);
}

// Helper function to generate the signature
String generateSignature(String publicId, String apiSecret) {
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // Create the signature string
  String signatureString = 'public_id=$publicId&timestamp=$timestamp$apiSecret';

  // Generate the SHA-1 hash of the signature string
  var bytes = utf8.encode(signatureString); // Convert to bytes
  var hash = sha1.convert(bytes); // Generate SHA-1 hash

  return hash.toString(); // Return the hash as a string
}
