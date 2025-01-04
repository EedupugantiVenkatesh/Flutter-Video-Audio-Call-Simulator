
import 'package:flutter/material.dart';
import 'package:call_console/call_state.dart';

class CallDialog extends StatelessWidget {
  final CallStateNotifier callState;

  CallDialog({required this.callState});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.phone_in_talk, size: 150, color: Colors.green),
          SizedBox(height: 20),
          Text(
            'Incoming ${callState.callType == CallType.Video ? "Video" : "Audio"} Call',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await callState.initializeCamera();
            callState.setState(CallState.InCall);
          },
          child: Text('Accept'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            callState.setState(CallState.Idle);
          },
          child: Text('Reject'),
        ),
      ],
    );
  }
}
