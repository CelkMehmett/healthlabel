import 'package:flutter/foundation.dart'; // WriteBuffer buradan gelir

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveOcrPage extends StatefulWidget {
  const LiveOcrPage({super.key});

  @override
  State<LiveOcrPage> createState() => _LiveOcrPageState();
}

class _LiveOcrPageState extends State<LiveOcrPage> {
  CameraController? _controller;
  late final TextRecognizer _textRecognizer;

  bool _initializing = true;
  bool _processing = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _textRecognizer = TextRecognizer();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // 1) Kamera izni
    final status = await Permission.camera.request();
    if (!mounted) return;
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamera izni reddedildi')),
      );
      setState(() => _initializing = false);
      return;
    }

    // 2) Uygun kamera var mı?
    final cams = await availableCameras();
    if (!mounted) return;
    if (cams.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamera bulunamadı')),
      );
      setState(() => _initializing = false);
      return;
    }

    // Arka kamerayı tercih et; yoksa ilkini al
    final CameraDescription cam =
        cams.firstWhere((c) => c.lensDirection == CameraLensDirection.back, orElse: () => cams.first);

    // 3) Controller
    final ctrl = CameraController(
      cam,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420, // Android için güvenli
      enableAudio: false,
    );

    try {
      await ctrl.initialize();
      if (!mounted) return;
      _controller = ctrl;
      setState(() => _initializing = false);

      // 4) Görüntü akışını başlat
      await _controller!.startImageStream(_onImage);
    } on CameraException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kamera hatası: ${e.code}')),
      );
      setState(() => _initializing = false);
    }
  }

  // Kamera frame -> ML Kit
  Future<void> _onImage(CameraImage image) async {
    if (_processing || _controller == null || !_controller!.value.isInitialized) return;
    _processing = true;

    try {
      // YUV420 -> tek byte dizisi
      final WriteBuffer buffer = WriteBuffer();
      for (final Plane p in image.planes) {
        buffer.putUint8List(p.bytes);
      }
      final Uint8List bytes = buffer.done().buffer.asUint8List();

      // Döndürme bilgisi
      final rotation = _rotationFromSensor(_controller!.description.sensorOrientation);

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21, // YUV420 için NV21
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final result = await _textRecognizer.processImage(inputImage);

      if (!mounted) return;
      setState(() => _recognizedText = result.text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OCR hatası: $e')),
        );
      }
    } finally {
      _processing = false;
    }
  }

  InputImageRotation _rotationFromSensor(int sensorOrientation) {
    switch (sensorOrientation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      case 0:
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  @override
  void dispose() {
    // Akışı güvenli kapat
    final c = _controller;
    if (c != null) {
      if (c.value.isStreamingImages) {
        c.stopImageStream();
      }
      c.dispose();
    }
    _textRecognizer.close();
    super.dispose();
  }

  // Basit toolbar: fener & kamera çevir
  Future<void> _toggleFlash() async {
    final c = _controller;
    if (c == null) return;
    try {
      final current = c.value.flashMode;
      final next = current == FlashMode.torch ? FlashMode.off : FlashMode.torch;
      await c.setFlashMode(next);
      setState(() {});
    } catch (_) {}
  }

  Future<void> _switchCamera() async {
    final c = _controller;
    if (c == null) return;
    if (c.value.isStreamingImages) {
      await c.stopImageStream();
    }
    await c.dispose();

    setState(() {
      _controller = null;
      _initializing = true;
      _recognizedText = '';
    });

    // Tekrar kur (mevcut lens yönünü tersine çevir)
    final cams = await availableCameras();
    if (!mounted || cams.isEmpty) return;

    final currentLens = c.description.lensDirection;
    final CameraDescription newCam = cams.firstWhere(
      (cam) => cam.lensDirection != currentLens,
      orElse: () => cams.first,
    );

    final ctrl = CameraController(
      newCam,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
      enableAudio: false,
    );

    try {
      await ctrl.initialize();
      if (!mounted) return;
      _controller = ctrl;
      setState(() => _initializing = false);
      await _controller!.startImageStream(_onImage);
    } on CameraException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kamera hatası: ${e.code}')),
      );
      setState(() => _initializing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ready = !_initializing && _controller != null && _controller!.value.isInitialized;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı OCR'),
        actions: [
          IconButton(
            tooltip: 'Fener',
            onPressed: _toggleFlash,
            icon: const Icon(Icons.flashlight_on_rounded),
          ),
          IconButton(
            tooltip: 'Kamera çevir',
            onPressed: _switchCamera,
            icon: const Icon(Icons.cameraswitch_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          if (ready)
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            )
          else
            const Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          const SizedBox(height: 12),
          Text('Tanımlanan Metin', style: Theme.of(context).textTheme.titleMedium),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: SelectableText(_recognizedText),
            ),
          ),
        ],
      ),
    );
  }
}