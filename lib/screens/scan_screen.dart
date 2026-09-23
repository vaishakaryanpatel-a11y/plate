import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/meal_entry.dart';
import '../services/food_recognition_service.dart';
import '../state/app_state.dart';
import '../widgets/calorie_overlay.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  FoodRecognitionResult? _result;
  File? _image;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras.first, ResolutionPreset.medium, enableAudio: false);
        await _controller!.initialize();
      }
    } catch (error) {
      _error = 'Camera unavailable. Choose an image from your gallery.';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked == null) return;
      final image = File(picked.path);
      final result = await FoodRecognitionService().recognize(image);
      if (mounted) setState(() { _image = image; _result = result; _error = null; });
    } catch (error) {
      if (mounted) setState(() => _error = 'Unable to analyze that image: $error');
    }
  }

  Future<void> _capture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final file = await _controller!.takePicture();
    final result = await FoodRecognitionService().recognize(File(file.path));
    if (mounted) setState(() { _image = File(file.path); _result = result; });
  }

  void _saveMeal() {
    final result = _result;
    if (result == null) return;
    final calories = result.items.fold(0, (sum, item) => sum + item.calories);
    context.read<AppState>().addMeal(MealEntry(name: 'Scanned plate', calories: calories, time: DateTime.now()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Meal saved')));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      appBar: AppBar(title: const Text('Scan a plate')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (controller != null && controller.value.isInitialized)
                  AspectRatio(aspectRatio: controller.value.aspectRatio, child: CameraPreview(controller))
                else if (_image != null)
                  Image.file(_image!, height: 260, fit: BoxFit.cover)
                else
                  const SizedBox(height: 180, child: Center(child: Text('Camera unavailable'))),
                const SizedBox(height: 16),
                if (_result != null) CalorieOverlay(items: _result!.items),
                if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  children: [
                    if (controller != null && controller.value.isInitialized)
                      FilledButton.icon(onPressed: _capture, icon: const Icon(Icons.camera_alt), label: const Text('Capture')),
                    OutlinedButton.icon(onPressed: () => _pick(ImageSource.gallery), icon: const Icon(Icons.photo_library), label: const Text('Gallery')),
                    if (_result != null)
                      FilledButton(onPressed: _saveMeal, child: const Text('Save meal')),
                  ],
                ),
              ],
            ),
    );
  }
}
