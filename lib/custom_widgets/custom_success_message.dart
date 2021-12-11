import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSuccessDialog extends StatelessWidget {
  const CustomSuccessDialog({
    this.context,
    this.title,
    this.content,
    this.okButtonAction,
    this.cancelButtonAction,
    this.enableCloseButton,
    this.enableDoneButton,
    this.closeButtonAction,
    this.titleTextStyle,
    this.contentTextStyle,
    this.okButtonTextStyle,
    this.cancelButtonTextStyle,
    this.alertDialogBackgroundColor,
    this.okButtonBackgroundColor,
    this.cancelButtonBackgroundColor,
    this.singleBigButtonEnabled,
    this.okButtonText,
    this.cancelButtonText,
    this.doneButtonBackgroundColor,
    this.closeButtonBackgroundColor,
    this.cardColor,
    this.image,
  });

  final BuildContext? context;
  final String? title;
  final String? content;
  final Function? okButtonAction;
  final Function? cancelButtonAction;
  final bool? enableCloseButton;

  final bool? enableDoneButton;

  final Function? closeButtonAction;

  final Color? doneButtonBackgroundColor;
  final Color? closeButtonBackgroundColor;
  final Color? cardColor;

  final bool? singleBigButtonEnabled;

  final String? okButtonText;
  final String? cancelButtonText;
  final String? image;

  final TextStyle? titleTextStyle;
  final TextStyle? contentTextStyle;
  final TextStyle? okButtonTextStyle;
  final TextStyle? cancelButtonTextStyle;

  final Color? alertDialogBackgroundColor;
  final Color? okButtonBackgroundColor;
  final Color? cancelButtonBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      backgroundColor: Colors.transparent,
      content: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              top: Constants.avatarRadius + Constants.padding,
              left: 0,
              right: 0),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: cardColor,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Visibility(
                  visible: image != null ? true : false,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: SvgPicture.asset(
                          image!,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )),
              Visibility(
                visible: title != null ? true : false,
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 8.0, right: 8.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: titleTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: content != null ? true : false,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 5.0, left: 8.0, right: 8.0, bottom: 8.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        content!,
                        textAlign: TextAlign.center,
                        style:
                            contentTextStyle != null ? contentTextStyle : null,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          okButtonAction!(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: okButtonBackgroundColor
                          ),
                          child: Center(
                            child: Text(
                              okButtonText!,
                              style: okButtonTextStyle != null
                                  ? okButtonTextStyle
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
              Visibility(
                visible: title != null && content != null ? false : true,
                child: SizedBox(
                  height: 16,
                ),
              )
            ],
          ),
        ),
        Visibility(
          visible: true,
          child: Positioned(
            left: Constants.padding,
            right: Constants.padding,
            child: CircleAvatar(
              backgroundColor: doneButtonBackgroundColor != null
                  ? doneButtonBackgroundColor
                  : Colors.green,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                  )),
            ),
          ),
        ),
        Visibility(
          visible: false,
          child: Positioned(
            top: 2.0,
            right: 0.0,
            child: CircleAvatar(
              backgroundColor: closeButtonBackgroundColor != null
                  ? closeButtonBackgroundColor
                  : Colors.red,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: IconButton(
                    onPressed: () {
                      closeButtonAction!(context);
                    },
                    icon: Icon(Icons.close),
                    //icon :Icons.close,color: Colors.white,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();

  static const double padding = 14;
  static const double avatarRadius = 20;
  static const double containerPadding = 8;
  static const double smallPadding = 2;
}
