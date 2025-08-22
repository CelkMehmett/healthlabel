import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/analysis_args.dart';

class BarcodeScanPage extends StatefulWidget {
  const BarcodeScanPage({super.key});

  @override
  State<BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [BarcodeFormat.all],
  );

  bool _hasPermission = false;
  String? _lastCode;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _askPermission();
  }

  Future<void> _askPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    setState(() => _hasPermission = status.isGranted);
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_hasPermission) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || code.isEmpty) return;

    // basit debounce (aynı barkodu peş peşe okuma)
    if (_lastCode == code) return;
    _lastCode = code;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      await _controller.stop();
      if (!mounted) return;
      if (!context.mounted) return;
      Navigator.pushNamed(
        context,
        '/analysis',
        arguments: AnalysisArgs(
          barcode: code,
          // İstersen productName veya imagePath gibi alanları da doldur
          // ürün sorgusu burada yapılacaksa FutureBuilder/await ile ekleyebilirsin.
        ),
      ).then((_) {
        // geri dönünce taramayı tekrar başlat
        _controller.start();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(title: const Text('Barkod Tara')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Kamera izni gerekli'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _askPermission,
                child: const Text('İzin İste'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barkod Tara'),
        actions: [
          IconButton(
            tooltip: 'Fener',
            onPressed: () => _controller.toggleTorch(),
            icon: const Icon(Icons.flashlight_on_rounded),
          ),
          IconButton(
            tooltip: 'Kamera çevir',
            onPressed: () => _controller.switchCamera(),
            icon: const Icon(Icons.cameraswitch_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => Center(
              child: Text('Kamera hatası: $error'),
            ),
          ),
          // Basit nişangâh
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 3,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: .8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}