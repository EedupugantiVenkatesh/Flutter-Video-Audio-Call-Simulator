// ignore_for_file: constant_identifier_names

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class CallStateNotifier extends ChangeNotifier {
  CallState _state = CallState.Idle;
  CallType _callType = CallType.Audio;
  final List<CameraDescription> cameras;
  CameraController? cameraController;

  CallStateNotifier(this.cameras);

  CallState get state => _state;
  CallType get callType => _callType;

  void setState(CallState state) {
    _state = state;
    notifyListeners();
  }

  void setCallType(CallType type) {
    _callType = type;
    notifyListeners();
  }

Future<void> initializeCamera() async {
  PermissionStatus cameraStatus = await Permission.camera.status;
  PermissionStatus microphoneStatus = await Permission.microphone.status;

  // Request permission if not granted
  if (!cameraStatus.isGranted) {
    cameraStatus = await Permission.camera.request();
  }

  if (!microphoneStatus.isGranted) {
    microphoneStatus = await Permission.microphone.request();
  }

  if (cameraStatus.isGranted && microphoneStatus.isGranted) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      try {
        // Get list of available cameras
        List<CameraDescription> cameras = await availableCameras();

        // Find the front camera
        CameraDescription? frontCamera;
        for (CameraDescription camera in cameras) {
          if (camera.lensDirection == CameraLensDirection.front) {
            frontCamera = camera;
            break;
          }
        }

        if (frontCamera == null) {
          print('No front camera found');
          Fluttertoast.showToast(msg: 'No front camera found');
          return;
        }

        // Initialize the camera with the front camera
        cameraController = CameraController(
          frontCamera,
          ResolutionPreset.medium,
        );

        await cameraController!.initialize();
        notifyListeners();
        print("Front camera initialized successfully");

      } catch (e) {
        print('Error initializing camera: $e');
      }
    }
  } else {
    print('Camera or Microphone permission not granted!');
    Fluttertoast.showToast(msg: 'Please grant camera and microphone permissions.');
  }
}

void disposeCamera() {
  cameraController?.dispose();
  cameraController = null;
  print('Camera disposed');
}

Future<void> stopRecording() async {
  if (cameraController == null) {
    print('CameraController is null!');
    return;
  }

  if (!cameraController!.value.isInitialized) {
    print('Camera is not initialized!');
    return;
  }

  if (!cameraController!.value.isRecordingVideo) {
    print('Camera is not recording!');
    return;
  }

  try {
    XFile videoFile = await cameraController!.stopVideoRecording();
    print('Video recorded to: ${videoFile.path}');
  } catch (e) {
    print('Error stopping video recording: $e');
  }
}

Future<void> startRecording() async {
  if (cameraController != null && cameraController!.value.isInitialized) {
    try {
      if (!cameraController!.value.isRecordingVideo) {
        await cameraController!.startVideoRecording();
        print('Recording started');
      }
    } catch (e) {
      print('Error starting video recording: $e');
    }
  } else {
    print('Camera is not initialized!');
  }
}
}

enum CallState {
  Idle,
  Ringing,
  InCall,
  CallEnded,
}

enum CallType {
  Audio,
  Video,
}
