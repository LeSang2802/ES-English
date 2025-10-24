// lib/cores/services/cloudinary_service.dart

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class CloudinaryService {
  static const String _cloudName = "dy0abltgq";
  static const String _uploadPreset = "images_avatar_ES";

  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    _cloudName,
    _uploadPreset,
    cache: false,
  );

  Future<String?> uploadImage(String imagePath) async {
    try {
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(imagePath,
            resourceType: CloudinaryResourceType.Image),
      );
      if (response.secureUrl.isNotEmpty) {
        return response.secureUrl;
      }

      return null;

    } on CloudinaryException catch (e) {
      String displayError = 'Upload failed. Check logs.';
      try {
        final Map<String, dynamic> errorData = jsonDecode(e.message.toString());
        displayError = errorData['error']['message'] ?? 'Status ${e.statusCode} error.';
      } catch (_) {
        displayError = 'Error: ${e.message} (Status: ${e.statusCode})';
      }

      debugPrint(" Cloudinary Upload Failed:");
      debugPrint("  Status: ${e.statusCode}");
      debugPrint("  Detail: $displayError");

      return null;
    } catch (e) {
      debugPrint("Ngoại lệ chung khi tải ảnh lên: $e");
      return null;
    }
  }
}