import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '/OdooApiCall_DataMapping/ToCheckIn_ToCheckOut_SupportTicket.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/screens/launch/HomeScreen.dart';
import '/screens/products/MySignatureScreen.dart';
import '/widgets/Styles.dart';
import '/util/Util.dart';

class VerifyCustomerScreen extends StatefulWidget {
  final ToCheckInOutSupportTicket supportticket;

  VerifyCustomerScreen({required Key key, required this.supportticket}) : super(key: key);
  
  @override
  _VerifyCustomerScreenState createState() => _VerifyCustomerScreenState();
}

class _VerifyCustomerScreenState extends State<VerifyCustomerScreen> {
  bool isDisplayErrorNotification = false;
  String errorMessage = "";
  late Timer _timer;
  int _start = 60;
  FirebaseAuth auth  = FirebaseAuth.instance;
  String demoPhone = "+"+"60128865095"; //test for demo phone number


  TextEditingController otpDigit1 = new TextEditingController();
  TextEditingController otpDigit2 = new TextEditingController();
  TextEditingController otpDigit3 = new TextEditingController();
  TextEditingController otpDigit4 = new TextEditingController();

  FocusNode focusNodeOtp1 = new FocusNode();
  FocusNode focusNodeOtp2 = new FocusNode();
  FocusNode focusNodeOtp3 = new FocusNode();
  FocusNode focusNodeOtp4 = new FocusNode();
  
  late String verID;
  late int screenState;
  late String otpPin;
  bool hasError = false;

  void showErrorNotification(String message) {
    setState(() {
      isDisplayErrorNotification = true;
      errorMessage = message;
    });
  }

  void hideErrorNotification() {
    setState(() {
      isDisplayErrorNotification = false;
      errorMessage = "";
    });
  }

  @override
  void initState() {
    super.initState();
    //focusNodeOtp1.addListener(() => setState(() {}));
    //focusNodeOtp2.addListener(() => setState(() {}));
    //focusNodeOtp3.addListener(() => setState(() {}));
    //focusNodeOtp4.addListener(() => setState(() {}));
    //dummy otp
    //otpDigit1.text = '1';
    //otpDigit2.text = '2';
    //otpDigit3.text = '3';
    //otpDigit4.text = '4';
    verifyPhone(demoPhone);
    startTimer();

  }




  @override
  void dispose() {
    //focusNodeOtp1.dispose();
    //focusNodeOtp2.dispose();
    //focusNodeOtp3.dispose();
    //focusNodeOtp4.dispose();
    _timer.cancel();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    PreferredSize buildAppBar(BuildContext context, String title, {VoidCallback? onBackPress}) {
      return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Set the height as needed
        child: AppBar(
          // Your AppBar code here
        ),
      );
    }


    return Scaffold(
      appBar: buildAppBar(context, "Verify Customer's Authority", onBackPress: () {

        Navigator.pop(context);
      }),

      backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(child: buildHeaderLayout()),
                        SizedBox(
                          height: 20,
                        ),
                                      Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
                        PinCodeTextField(
                          //autoFocus: true,
                          appContext: context,
                          length: 6,
                          onChanged: (value) {
                            setState(() {
                              otpPin = value;
                            });
                          },
                          pinTheme: PinTheme(
                            activeColor: primaryColor,
                            selectedColor: primaryColor,
                            inactiveColor: Colors.black26,
                          ),
                        ),

                        /*
                        buildOTPInputs(
                          otpDigit1,
                          otpDigit2,
                          otpDigit3,
                          otpDigit4,

                        ),
                        */
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: buildSessionPart(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
                          child: buildContinueButtons(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeaderLayout() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: isDisplayErrorNotification,
            child: buildErrorNotificationWithOption(
              context,
              errorMessage,
              '',
              isDarkMode(context) ? Colors.red[900]! : pinkishColor,
              false,
              onOptionTap: () {},
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            verifyLabel,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            accountLabel,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: enterOtp,
                    style: Theme.of(context).textTheme.bodyText2),
                TextSpan(
                  text: demoPhone,//demoEmail,
                  style: authScreensClickableLabelStyle,
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                TextSpan(
                //  textL
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOTPInputs(otpDigit1, otpDigit2, otpDigit3, otpDigit4) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 50,
          width: 70,
          child: buildTextField(
            context,
            otpDigit1,
            TextCapitalization.none,
            TextInputType.number,
            TextInputAction.next,
            false,
            lightGreyColor.withOpacity(0.5),
            8.0,
            lightGreyColor.withOpacity(0.2),
            primaryColor,
            primaryColor,
            focusNodeOtp1.hasFocus
                ? isDarkMode(context)
                    ? primaryColor.withOpacity(0.3)
                    : primaryColor.withOpacity(0.15)
                : isDarkMode(context)
                    ? primaryColor.withOpacity(0.15)
                    : Colors.white,
            1,
            '',
            true,
            focusNode: focusNodeOtp1,
            onChange: (value) {
              if (value.toString().length > 0)
                FocusScope.of(context).requestFocus(focusNodeOtp2);
            },
            onSubmit: null,
          ),
        ),
        Container(
          height: 50,
          width: 70,
          child: buildTextField(
            context,
            otpDigit2,
            TextCapitalization.none,
            TextInputType.number,
            TextInputAction.next,
            false,
            lightGreyColor.withOpacity(0.5),
            8.0,
            lightGreyColor.withOpacity(0.2),
            primaryColor,
            primaryColor,
            focusNodeOtp2.hasFocus
                ? isDarkMode(context)
                    ? primaryColor.withOpacity(0.3)
                    : primaryColor.withOpacity(0.15)
                : isDarkMode(context)
                    ? primaryColor.withOpacity(0.15)
                    : Colors.white,
            1,
            '',
            true,
            focusNode: focusNodeOtp2,
            onChange: (value) {
              if (value.toString().length > 0)
                FocusScope.of(context).requestFocus(focusNodeOtp3);
            },
            onSubmit: null,
          ),
        ),
        Container(
          height: 50,
          width: 70,
          child: buildTextField(
            context,
            otpDigit3,
            TextCapitalization.none,
            TextInputType.number,
            TextInputAction.next,
            false,
            lightGreyColor.withOpacity(0.5),
            8.0,
            lightGreyColor.withOpacity(0.2),
            primaryColor,
            primaryColor,
            focusNodeOtp3.hasFocus
                ? isDarkMode(context)
                    ? primaryColor.withOpacity(0.3)
                    : primaryColor.withOpacity(0.15)
                : isDarkMode(context)
                    ? primaryColor.withOpacity(0.15)
                    : Colors.white,
            1,
            '',
            true,
            focusNode: focusNodeOtp3,
            onChange: (value) {
              if (value.toString().length > 0)
                FocusScope.of(context).requestFocus(focusNodeOtp4);
            },
            onSubmit: null,
          ),
        ),
        Container(
          height: 50,
          width: 70,
          child: buildTextField(
            context,
            otpDigit4,
            TextCapitalization.none,
            TextInputType.number,
            TextInputAction.done,
            false,
            lightGreyColor.withOpacity(0.5),
            8.0,
            lightGreyColor.withOpacity(0.2),
            primaryColor,
            primaryColor,
            focusNodeOtp4.hasFocus
                ? isDarkMode(context)
                    ? primaryColor.withOpacity(0.3)
                    : primaryColor.withOpacity(0.15)
                : isDarkMode(context)
                    ? primaryColor.withOpacity(0.15)
                    : Colors.white,
            1,
            '',
            true,
            focusNode: focusNodeOtp4,
            onChange: (value) {
              if (value.toString().length > 0) hideKeyboard(context);
            },
            onSubmit: null,
          ),
        )
      ],
    );
  }

  Widget buildSessionPart() {
    return Container(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: sessionEndMessagePrefix,
                style: Theme.of(context).textTheme.bodyText2),
            TextSpan(
                text: '$_start', style: Theme.of(context).textTheme.bodyText2),
            TextSpan(
                text: sessionEndMessageSuffix,
                style: Theme.of(context).textTheme.bodyText2),
            TextSpan(
                text: didNotGetCode,
                style: Theme.of(context).textTheme.bodyText2),
            TextSpan(
              text: resendCode,
              style: authScreensClickableLabelStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (_start == 0)
                    setState(
                      () {
                        if (_timer != null) {
                          _timer.cancel();
                          _start = 60;
                        }
                        verifyPhone(demoPhone);
                        startTimer();
                      },
                    );
                },
            )
          ],
        ),
      ),
    );
  }

  Widget buildContinueButtons() {
    return Stack(
      children: [

        Container(
          child: Column(
            children: [
              /*
              GestureDetector(
                          onTap: () {
                            if(screenState == 0) {
                              //if(usernameController.text.isEmpty) {
                              //  showSnackBarText("Username is still empty!");
                              } if(phoneController.text.isEmpty) {
                                showSnackBarText("Phone number is still empty!");
                              } else {
                                verifyPhone(countryDial + phoneController.text);
                              }
                            } else {
                              if(otpPin.length >= 6) {
                                verifyOTP();
                              } else {
                                showSnackBarText("Enter OTP correctly!");
                              }
                            }
                          }),
              */
              buildButton(
                continueLabel,
                true,
                isDarkMode(context) ? primaryColorDark : primaryColor,
                isDarkMode(context)
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white,
                2,
                2,
                8,
                onPressed: () {
                  //checkValidations(); // this is for original shopping_app_ui layout
                  //ensure that otpPin is not empty

                    if (otpPin!=null){
                      checkOTPvalidations();  
                    }
                    verifyOTP();
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  void checkOTPvalidations(){


    
    if (otpPin.length != 6   )//|| currentText != "123456") 
    {
      setState(() => hasError = true);
    } 
    else
    {
      setState(() {
        hasError = false;
      });
    }
  }

  /*
  void checkValidations() {
    if (otpDigit1.text.isEmpty ||
        otpDigit2.text.isEmpty ||
        otpDigit3.text.isEmpty ||
        otpDigit3.text.isEmpty) {
      showErrorNotification(enterOTPError);
    } else {
      if (isDisplayErrorNotification == true) {
        hideErrorNotification();
      }
      hideKeyboard(context);
      showInfoToast(context, accountVerifiedLabel);
      Future.delayed(
        Duration(milliseconds: 200),
        (){
          Navigator.push(
            context,
            
            OpenUpwardsPageRoute(child: MySignatureScreen(), 
              direction: AxisDirection.right)
          );
        },
      );
    }
  }
  */

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(
            () {
              timer.cancel();
            },
          );
        } else {
          setState(
            () {
              _start--;
            },
          );
        }
      },
    );
  }


/*void verifyNumber (){
  auth.verifyPhoneNumber(
    phoneNumber: phoneController.text,
    verificationCompleted: ,
    verificationFailed: ,
    codeSent: ,
    codeAutoRetrievalTimeout: ,
  );
}*/

  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        //verifyOTP();
        showSnackBarText("Auth Completed!");
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBarText("Auth Failed!");
        print("failed"+e.toString());
        hasError = true;
      },
      codeSent: (String verificationId, int? resendToken) {
        showSnackBarText("OTP Sent!");
        verID = verificationId;
        //setState(() {
        //  screenState = 1;
        //});
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackBarText("Timeout!");
      },
    );
  }


    Future<void> verifyOTP() async {
    try{
    await FirebaseAuth.instance.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verID,
        smsCode: otpPin,
      ),
    );
    
    //.whenComplete(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MySignatureScreen(supportticket:widget.supportticket, key: UniqueKey()),
        ),
      );
    //});

    }catch (e){
      FocusScope.of(context).unfocus();
      showSnackBarText("Invalid OTP!");
    }
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  
}

