import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:call_console/call_state.dart';

class IdleState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final callState = Provider.of<CallStateNotifier>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 75,
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.account_circle,
            size: 100,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        Text('Idle', style: TextStyle(fontSize: 24)),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                callState.setCallType(CallType.Audio); // Set Audio call type
                callState.setState(CallState.Ringing);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.phone, size: 30, color: Colors.white),
                  ),
                  Text('Audio Call', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                callState.setCallType(CallType.Video); // Set Video call type
                callState.setState(CallState.Ringing);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.video_call, size: 30, color: Colors.white),
                  ),
                  Text('Video Call', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
