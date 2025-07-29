// 🎯 latihan_camera_controller.dart
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();

  final namaLatihan = ''.obs;
  final tipeModel = ''.obs;

  int selectedCameraIndex = 0;
  List<CameraDescription> cameras = [];

  DateTime lastPredictionTime = DateTime.now();
  DateTime? _poseDetectedAt;
  List<double>? _lastLandmarkSnapshot;

  final Duration _requiredStableDuration = Duration(seconds: 2);
  final double _stabilityThreshold = 0.02;
  final double _minAverageLikelihood = 0.85;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      namaLatihan.value = args['nama_latihan'] ?? '-';
      tipeModel.value = args['tipe_model'] ?? 'tidak diketahui';
    }

    poseDetector = PoseDetector(
      options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
    );

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
      ResolutionPreset.ultraHigh,
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

        final landmarkTypes = _getRelevantLandmarkTypes();
        final imageWidth = inputImage.metadata?.size.width ?? 1.0;
        final imageHeight = inputImage.metadata?.size.height ?? 1.0;

        final filteredLandmarks =
            landmarkTypes
                .map((type) {
                  final e = pose.landmarks[type];
                  if (e == null || e.likelihood < 0.1) {
                    return [0.0, 0.0, 0.0, 0.0];
                  }
                  final x = e.x / imageWidth;
                  final y = e.y / imageHeight;
                  final z = e.z / imageWidth;
                  return [x, y, z, e.likelihood];
                })
                .expand((e) => e)
                .toList();

        final expectedLength = landmarkTypes.length * 4;
        if (filteredLandmarks.length == expectedLength) {
          final allZero = filteredLandmarks.every((v) => v == 0.0);
          if (allZero) {
            _poseDetectedAt = null;
            return;
          }

          final isStable = _isPoseStable(filteredLandmarks);
          final isConfident = _hasHighConfidence(filteredLandmarks);
          final isMotion = _isMotionDetected(filteredLandmarks);

          if (isStable && isConfident && isMotion) {
            if (_poseDetectedAt == null) {
              _poseDetectedAt = DateTime.now();
              debugPrint("⏳ Pose stabil, confidence tinggi. Tunggu 2 detik...");
              return;
            }

            if (DateTime.now().difference(_poseDetectedAt!) >=
                _requiredStableDuration) {
              if (_canPredict()) {
                debugPrint("✅ Pose stabil 2 detik. Klasifikasi...");
                _runModel(filteredLandmarks);
                lastPredictionTime = DateTime.now();
                _poseDetectedAt = null;
              }
            }
          } else {
            _poseDetectedAt = null;
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Error deteksi pose: $e");
    } finally {
      isDetecting.value = false;
    }
  }

  bool _isPoseStable(List<double> current) {
    if (_lastLandmarkSnapshot == null) {
      _lastLandmarkSnapshot = current;
      return false;
    }

    double totalDiff = 0.0;
    for (int i = 0; i < current.length; i++) {
      totalDiff += (current[i] - _lastLandmarkSnapshot![i]).abs();
    }

    _lastLandmarkSnapshot = current;
    double avgDiff = totalDiff / current.length;
    return avgDiff < _stabilityThreshold;
  }

  bool _hasHighConfidence(List<double> landmarks) {
    final likelihoods = <double>[];
    for (int i = 3; i < landmarks.length; i += 4) {
      likelihoods.add(landmarks[i]);
    }

    final avg = likelihoods.reduce((a, b) => a + b) / likelihoods.length;
    debugPrint("🔍 Avg Likelihood: ${avg.toStringAsFixed(2)}");
    return avg >= _minAverageLikelihood;
  }

  bool _canPredict() {
    return DateTime.now().difference(lastPredictionTime) >
        Duration(milliseconds: 800);
  }

  bool _isMotionDetected(List<double> landmarks) {
    switch (tipeModel.value) {
      case 'pukulan':
      case 'tangkisan':
        final lShoulderY = landmarks[1 * 4 + 1];
        final lWristY = landmarks[5 * 4 + 1];
        final rShoulderY = landmarks[0 * 4 + 1];
        final rWristY = landmarks[4 * 4 + 1];
        return (lWristY - lShoulderY).abs() > 0.12 ||
            (rWristY - rShoulderY).abs() > 0.12;
      case 'tendangan':
        final lHipY = landmarks[1 * 4 + 1];
        final lAnkleY = landmarks[5 * 4 + 1];
        final rHipY = landmarks[0 * 4 + 1];
        final rAnkleY = landmarks[4 * 4 + 1];
        return (lAnkleY - lHipY).abs() > 0.15 || (rAnkleY - rHipY).abs() > 0.15;
      default:
        return true;
    }
  }

  void _runModel(List<double> input) async {
    final inputTensor = [input];
    final output = List.filled(2, 0.0).reshape([1, 2]);

    try {
      interpreter?.run(inputTensor, output);
      final result = List<double>.from(output[0]);
      final index = result.indexOf(result.reduce((a, b) => a > b ? a : b));
      final label = _getLabel(index);

      hasilKlasifikasi.value = label;

      final cocok = label.toLowerCase().contains(
        namaLatihan.value.toLowerCase(),
      );

      warnaKlasifikasi.value = cocok ? Colors.green : Colors.red;

      await _audioPlayer.stop();
      await _audioPlayer.play(
        AssetSource(
          cocok ? 'sounds/DeteksiBerhasil.mp3' : 'sounds/DeteksiGagal.mp3',
        ),
      );
    } catch (e) {
      debugPrint("❌ Gagal menjalankan model: $e");
    }
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

  List<PoseLandmarkType> _getRelevantLandmarkTypes() {
    switch (tipeModel.value) {
      case 'pukulan':
      case 'tangkisan':
        return [
          PoseLandmarkType.rightShoulder,
          PoseLandmarkType.leftShoulder,
          PoseLandmarkType.rightElbow,
          PoseLandmarkType.leftElbow,
          PoseLandmarkType.rightWrist,
          PoseLandmarkType.leftWrist,
        ];
      case 'tendangan':
        return [
          PoseLandmarkType.rightHip,
          PoseLandmarkType.leftHip,
          PoseLandmarkType.rightKnee,
          PoseLandmarkType.leftKnee,
          PoseLandmarkType.rightAnkle,
          PoseLandmarkType.leftAnkle,
        ];
      default:
        return PoseLandmarkType.values;
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
