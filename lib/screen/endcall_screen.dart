import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:call_console/call_state.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EndCallState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final callState = Provider.of<CallStateNotifier>(context, listen: false);
    Future.delayed(Duration(seconds: 3), () {
      callState.setState(CallState.Idle);
      Fluttertoast.showToast(msg: 'Back to Idle');
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 75,
          backgroundColor: Colors.red,
          child: Icon(Icons.call_end, size: 100, color: Colors.white),
        ),
        SizedBox(height: 20),
        Text('Call Ended', style: TextStyle(fontSize: 24)),
      ],
    );
  }
}
