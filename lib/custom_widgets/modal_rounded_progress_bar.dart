import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ModalRoundedProgressBar extends StatefulWidget {
  final Function handleCallBack;

  ModalRoundedProgressBar({required this.handleCallBack});
  @override
  State createState() => _ModalRoundedProgressBarState();
}

//StateClass ...
class _ModalRoundedProgressBarState extends State<ModalRoundedProgressBar> {
  bool _isShowing =
      false; // member that control if a rounded progressBar will be showing or not

  @override
  void initState() {
    super.initState();
    /* Here we create a handle object that will be sent for a widget that creates a ModalRounded      ProgressBar.*/
    ProgressBarHandler handler = ProgressBarHandler();

    handler.show = this.show; // handler show member holds a show() method
    handler.dismiss =
        this.dismiss; // handler dismiss member holds a dismiss method
  }

  @override
  Widget build(BuildContext context) {
    //return a simple stack if we don't wanna show a roundedProgressBar...
    if (!_isShowing) return Stack();

    // here we return a layout structre that show a roundedProgressBar with a simple text message
    return Material(
      color: Colors.blue,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.7,
            //ModalBarried used to make a modal effect on screen
            child: ModalBarrier(
              dismissible: false,
              color: Colors.blue,
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //  SpinKitWave(
                //    color: ColorData.appBarColor,
                //  ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // method do change state and show our CircularProgressBar
  void show() {
    if (!mounted) return;
    setState(() => _isShowing = true);
  }

  // method to change state and hide our CIrcularProgressBar
  void dismiss() {
    if (!mounted) return;
    setState(() => _isShowing = false);
  }
}

// handler class
class ProgressBarHandler {
  late Function show; //show is the name of member..can be what you want...
  late Function dismiss;
}
