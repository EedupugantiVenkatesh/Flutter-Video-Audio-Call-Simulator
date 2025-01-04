import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:call_console/call_state.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

class InCallState extends StatefulWidget {
  @override
  _InCallState createState() => _InCallState();
}

class _InCallState extends State<InCallState> {
  bool isMuted = false;
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  // Start a timer to track call duration
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  // Format time into hh:mm:ss format
  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final callState = Provider.of<CallStateNotifier>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (callState.callType == CallType.Video)
          callState.cameraController != null && callState.cameraController!.value.isInitialized
              ? SizedBox(
                  height: 300,
                  width: 300,
                  child: CameraPreview(callState.cameraController!),
                )
              : CircularProgressIndicator(), // Show loader until the camera is initialized
        if (callState.callType == CallType.Audio)
          CircleAvatar(
            radius: 100, // Size of the circle
            backgroundColor: Colors.blueGrey, // Background color of the circle
            child: Icon(
              Icons.phone, // Audio call icon
              size: 60, // Icon size
              color: Colors.white, // Icon color
            ),
          ),
        SizedBox(height: 20),
        Text(
          callState.callType == CallType.Video ? 'In Video Call' : 'In Audio Call',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Text(
          _formatTime(_seconds), // Display call duration
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isMuted = !isMuted;
                });
                Fluttertoast.showToast(msg: isMuted ? 'Muted' : 'Unmuted');
              },
              child: Icon(isMuted ? Icons.mic_off : Icons.mic),
            ),
            if (callState.callType == CallType.Video)
              ElevatedButton(
                onPressed: () {
                  callState.cameraController?.setDescription(
                    callState.cameras[callState.cameraController!.description == callState.cameras.first ? 1 : 0],
                  );
                  Fluttertoast.showToast(msg: 'Switched Camera');
                },
                child: Icon(Icons.switch_camera),
              ),
            ElevatedButton(
              onPressed: () {
                callState.setState(CallState.CallEnded);
                Fluttertoast.showToast(msg: 'Call Ended');
              },
              child: Icon(Icons.call_end),
            ),
          ],
        ),
      ],
    );
  }
}
