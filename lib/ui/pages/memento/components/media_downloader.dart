import 'dart:io';
import 'dart:html' as html; // For web support
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

class FileDownloader {
  static Future<void> downloadImage(String url, BuildContext context) async {
    try {
      if (kIsWeb) {
        // Extract filename from URL
        String filename = url.split('/').last.split('?').first;
        final response = await http.get(Uri.parse(url));
        final blob = html.Blob([response.bodyBytes]);
        final anchor =
            html.AnchorElement(href: html.Url.createObjectUrlFromBlob(blob))
              ..setAttribute('download', filename)
              ..click();
      } else {
        // Mobile-specific code to download the image
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var tempDir = Directory.systemTemp;
          String fileName = path.basename(url.split('/').last.split('?').first);
          String filePath = path.join(tempDir.path, fileName);
          File file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded to $filePath')),
          );
        } else {
          throw Exception('Failed to download image');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download image: $e')),
      );
    }
  }
}
