import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:call_console/call_state.dart';

import 'call_dialog.dart';
import 'endcall_screen.dart';
import 'idle_screen.dart';
import 'incall_screen.dart';

class CallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final callState = Provider.of<CallStateNotifier>(context);

    // Use WidgetsBinding to delay the dialog display until the build phase is finished
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (callState.state == CallState.Ringing) {
        _showIncomingCall(context); // Show incoming call dialog when in Ringing state
      }
    });

    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) {
            switch (callState.state) {
              case CallState.Idle:
                return IdleState();
              case CallState.Ringing:
                return Container();
              case CallState.InCall:
                return InCallState();
              case CallState.CallEnded:
                return EndCallState();
            }
          },
        ),
      ),
    );
  }

  // This method will show the incoming call dialog
  void _showIncomingCall(BuildContext context) {
    final callState = Provider.of<CallStateNotifier>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the dialog
      builder: (context) {
        return CallDialog(callState: callState);
      },
    );
  }
}
