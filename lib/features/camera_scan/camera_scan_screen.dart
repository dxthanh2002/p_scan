import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScanScreen extends StatefulWidget {
  const CameraScanScreen({super.key});

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Check permission
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          _cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } else {
      // Handle permission denied
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required to scan documents.')),
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
      _isCameraInitialized = false;
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    try {
      _isFlashOn = !_isFlashOn;
      await _controller!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {});
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;

    try {
      final XFile image = await _controller!.takePicture();
      await _processImage(image.path);
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _processImage(image.path);
    }
  }

  Future<void> _processImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Document',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            hideBottomControls: false),
        IOSUiSettings(
          title: 'Crop Document',
        ),
      ],
    );

    if (croppedFile != null) {
      // Save to document directory
      final directory = await getApplicationDocumentsDirectory();
      final String newPath = '${directory.path}/scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(croppedFile.path).copy(newPath);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved to $newPath')),
        );
        // Optionally pop the screen or add it to a list
        // Navigator.pop(context, newPath);
      }
    }
  }

  Widget _buildCorner(Alignment alignment) {
    bool isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    bool isBottom = alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight;
    bool isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    bool isRight = alignment == Alignment.topRight || alignment == Alignment.bottomRight;

    return Align(
      alignment: alignment,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Stack(
          children: [
            if (isTop) Positioned(top: 0, left: 0, right: 0, child: Container(height: 4, decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(2)))),
            if (isBottom) Positioned(bottom: 0, left: 0, right: 0, child: Container(height: 4, decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(2)))),
            if (isLeft) Positioned(top: 0, bottom: 0, left: 0, child: Container(width: 4, decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(2)))),
            if (isRight) Positioned(top: 0, bottom: 0, right: 0, child: Container(width: 4, decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(2)))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // Dark background matching design
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ),
                    onPressed: _toggleFlash,
                  ),
                ],
              ),
            ),
            
            // Viewfinder
            Expanded(
              child: ClipRRect(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Camera Preview
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller!.value.previewSize?.height ?? 1,
                          height: _controller!.value.previewSize?.width ?? 1,
                          child: CameraPreview(_controller!),
                        ),
                      ),
                    ),
                    
                    // Reticle overlay
                    Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.all(24.0),
                        child: Stack(
                          children: [
                            _buildCorner(Alignment.topLeft),
                            _buildCorner(Alignment.topRight),
                            _buildCorner(Alignment.bottomLeft),
                            _buildCorner(Alignment.bottomRight),
                          ],
                        ),
                      ),
                    ),

                    // Aligning text pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(153), // 0.6 * 255 = 153
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'ALIGNING DOCUMENT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Bar
            Container(
              padding: const EdgeInsets.only(bottom: 32, top: 16),
              color: Colors.black,
              child: Column(
                children: [
                  const Text(
                    'SCAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 32,
                    height: 2,
                    color: Colors.blueAccent, // Blue underline
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: SizedBox()), // Spacer
                      // Shutter button
                      GestureDetector(
                        onTap: _takePicture,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blueAccent, width: 3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: GestureDetector(
                              onTap: _pickFromGallery,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(25), // 0.1 * 255 = 25
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.photo_library, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
