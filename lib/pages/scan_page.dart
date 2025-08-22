import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/analysis_args.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _picker = ImagePicker();
  bool _busy = false;

  Future<void> _pickAndAnalyze(ImageSource source) async {
    final xfile = await _picker.pickImage(source: source, imageQuality: 90);
    if (xfile == null) return;

    setState(() => _busy = true);
    try {
      final recognizer = TextRecognizer();
      final input = InputImage.fromFilePath(xfile.path);
      final res = await recognizer.processImage(input);
      await recognizer.close();

      if (!mounted) return;
      Navigator.pushNamed(
        context,
        '/analysis',
        arguments: AnalysisArgs(
          imagePath: xfile.path,
          ocrText: res.text,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('OCR hatası: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarama')),
      body: Center(
        child: _busy
            ? const CircularProgressIndicator()
            : Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickAndAnalyze(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_rounded),
                    label: const Text('Kamera ile Tara'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickAndAnalyze(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_rounded),
                    label: const Text('Galeriden Seç'),
                  ),
                ],
              ),
      ),
    );
  }
}