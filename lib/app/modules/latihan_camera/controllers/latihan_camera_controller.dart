// 🎯 latihan_camera_controller.dart (optimalisasi untuk mencegah freeze & OOM)
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class LatihanCameraController extends GetxController {
  late CameraController cameraController;
  late final PoseDetector poseDetector;
  Interpreter? interpreter;

  final isCameraInitialized = false.obs;
  final isDetecting = false.obs;
  final hasilKlasifikasi = ''.obs;
  final warnaKlasifikasi = Rx<Color>(Colors.grey);

  final namaLatihan = ''.obs;
  final tipeModel = ''.obs;

  int selectedCameraIndex = 0;
  List<CameraDescription> cameras = [];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      namaLatihan.value = args['nama_latihan'] ?? '-';
      tipeModel.value = args['tipe_model'] ?? 'tidak diketahui';
    }

    poseDetector = PoseDetector(options: PoseDetectorOptions());
    _initCamera();
  }

  Future<void> _loadModel() async {
    try {
      final modelPath = 'assets/model/${tipeModel.value}.tflite';
      interpreter = await Interpreter.fromAsset(modelPath);
      debugPrint("✅ Model ${tipeModel.value} berhasil dimuat");
    } catch (e) {
      debugPrint("❌ Gagal memuat model: $e");
    }
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    selectedCameraIndex = cameras.indexWhere(
      (cam) => cam.lensDirection == CameraLensDirection.back,
    );
    if (selectedCameraIndex == -1) selectedCameraIndex = 0;
    await _startCamera();
  }

  Future<void> _startCamera() async {
    final selectedCamera = cameras[selectedCameraIndex];

    cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await cameraController.initialize();
    await _loadModel();

    isCameraInitialized.value = true;
    cameraController.startImageStream(_processCameraImage);
  }

  void switchCamera() async {
    isCameraInitialized.value = false;
    await cameraController.dispose();
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    await _startCamera();
  }

  void _processCameraImage(CameraImage image) async {
    if (isDetecting.value || interpreter == null) return;
    isDetecting.value = true;

    try {
      final inputImage = _convertCameraImage(
        image,
        cameraController.description.sensorOrientation,
      );

      final poses = await poseDetector.processImage(inputImage);
      if (poses.isNotEmpty) {
        final pose = poses.first;
        final landmarks =
            pose.landmarks.values
                .map((e) => [e.x, e.y, e.likelihood])
                .expand((e) => e)
                .toList();

        if (landmarks.length == 99) {
          _runModel(landmarks);
        }
      }
    } catch (e) {
      debugPrint("❌ Error deteksi pose: $e");
    } finally {
      isDetecting.value = false;
    }
  }

  void _runModel(List<double> input) {
    final inputTensor = [input];
    final output = List.filled(2, 0.0).reshape([1, 2]);
    interpreter?.run(inputTensor, output);

    final index = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
    final label = _getLabel(index);

    hasilKlasifikasi.value = label;
    warnaKlasifikasi.value =
        label.toLowerCase().contains(namaLatihan.value.toLowerCase())
            ? Colors.green
            : Colors.red;
  }

  String _getLabel(int index) {
    switch (tipeModel.value) {
      case 'tendangan':
        return index == 0 ? 'Tendangan Lurus' : 'Tendangan Sabit';
      case 'pukulan':
        return index == 0 ? 'Pukulan Lurus' : 'Pukulan Suwing';
      case 'tangkisan':
        return index == 0 ? 'Tangkisan Dalam' : 'Tangkisan Luar';
      default:
        return 'Tidak dikenali';
    }
  }

  InputImage _convertCameraImage(CameraImage image, int rotation) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation:
          InputImageRotationValue.fromRawValue(rotation) ??
          InputImageRotation.rotation0deg,
      format: InputImageFormat.nv21,
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  @override
  void onClose() {
    cameraController.dispose();
    poseDetector.close();
    interpreter?.close();
    super.onClose();
  }
}
