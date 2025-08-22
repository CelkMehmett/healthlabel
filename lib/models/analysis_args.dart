import 'package:flutter/foundation.dart';

@immutable
class AnalysisArgs {
  final String? imagePath;    // yerel yol veya network URL
  final String? ocrText;      // çıkarılan metin
  final String? productName;  // opsiyonel
  final String? barcode;      // opsiyonel

  const AnalysisArgs({
    this.imagePath,
    this.ocrText,
    this.productName,
    this.barcode,
  });
}