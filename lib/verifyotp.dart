import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'text_styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibration/vibration.dart';
import 'java_methods.dart';
import 'usersignon.dart';

class VerifyOTP extends StatefulWidget {
  static String verificationId="";
  static bool alreadyVerified=false;
  static FirebaseAuth auth = FirebaseAuth.instance;
  const VerifyOTP({Key? key}) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final Color nightModeGrey = const Color(0xff2E2F31);
  final Color colorB = const Color(0xff000000);
  String otpCA="*", otpCB="*", otpCC="*", otpCD="*", otpCE="*", otpCF="*", myName="";
  int charEnteredCount=0, tM=59;
  var path;
  JavaMethodsCustom sBase = JavaMethodsCustom();
  @override
  void initState() {
    super.initState();
    startInitialization();
  }
  @override
  void setState(VoidCallback fn){
    if(mounted){
      super.setState(fn);
    }
  }
  void startInitialization()async{
    path = await _localPath;
  }
  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }
  void slightVibrate(){
    try{
      Vibration.vibrate(duration: 5);
    }catch(exception){}
  }
  void registerOTPTap(String numberToTap){
    slightVibrate();
    if(charEnteredCount==0){
      setState(() {
        otpCA = numberToTap.toString();
        charEnteredCount++;
      });
    }
    else if(charEnteredCount==1){
      setState(() {
        otpCB = numberToTap.toString();
        charEnteredCount++;
      });
    }
    else if(charEnteredCount==2){
      setState(() {
        otpCC = numberToTap.toString();
        charEnteredCount++;
      });
    }
    else if(charEnteredCount==3){
      setState(() {
        otpCD = numberToTap.toString();
        charEnteredCount++;
      });
    }
    else if(charEnteredCount==4){
      setState(() {
        otpCE = numberToTap.toString();
        charEnteredCount++;
      });
    }
    else if(charEnteredCount==5){
      setState(() {
        otpCF = numberToTap.toString();
        charEnteredCount++;
      });
      if(otpCA!="*" && otpCB!="*" && otpCC!="*" && otpCD!="*" && otpCE!="*" && otpCF!="*"){
        charEnteredCount++;
        showDynamicMessage("Verifying..", false);
        checkForProceeding((otpCA+otpCB+otpCC+otpCD+otpCE+otpCF).toString());
      }
      else{
        showDynamicMessage("Wrong OTP..", true);
        Future.delayed(const Duration(milliseconds: 500), (){
          Navigator.pop(context);
        });
      }
    }
  }
  void showDynamicMessage(String messageText, bool isError){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(1, (index) =>
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setStateC) {
                      return Container(
                        decoration: BoxDecoration(
                          color: isError?darkRed:Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xff000026),
                              spreadRadius: 10,
                              blurRadius: 13,
                              offset: Offset(0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.remove,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(messageText, style: isError?userSignOnOccupationTitleGreySLW:userSignOnOccupationTitleGreySL,),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    })
            ),
          ),
        );
      },
    );
  }
  void checkForProceeding(String finalOTP)async{
    if(VerifyOTP.alreadyVerified){
      executeAfterVerification();
    }
    else{
      try{
        PhoneAuthCredential authCredential = PhoneAuthProvider.credential(verificationId: VerifyOTP.verificationId, smsCode: finalOTP);
        User? user = FirebaseAuth.instance.currentUser;
        try{
          await user!.linkWithCredential(authCredential);
        }on FirebaseAuthException catch(e){
          if(e.code == 'provider-already-linked'){
            await VerifyOTP.auth.signInWithCredential(authCredential);
          }
        }

        executeAfterVerification();
      }catch(exception){}
    }
  }
  void executeAfterVerification(){
    sBase.writeFilesRealtime(path, "User", "Details", "Verification", "Successful", false);
    sBase.writeFilesRealtime(path, "User", "Details", "PhoneNumber", UserSignOn.phoneNumber, false);
    _pushPage(context, const HomePage());
  }
  void removeOneChar(){
    if(charEnteredCount==1){
      setState(() {
        otpCA = "*";
        charEnteredCount--;
      });
    }
    else if(charEnteredCount==2){
      setState(() {
        otpCB = "*";
        charEnteredCount--;
      });
    }
    else if(charEnteredCount==3){
      setState(() {
        otpCC = "*";
        charEnteredCount--;
      });
    }
    else if(charEnteredCount==4){
      setState(() {
        otpCD = "*";
        charEnteredCount--;
      });
    }
    else if(charEnteredCount==5){
      setState(() {
        otpCE = "*";
        charEnteredCount--;
      });
    }
    else if(charEnteredCount>=6){
      setState(() {
        otpCF = "*";
        charEnteredCount=4;
      });
    }
  }
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: darkBlue,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xff000015),
    ));
    if(MediaQuery.of(context).orientation == Orientation.landscape){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              flex: 1,
              child: Text(""),
            ),
            const Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.keyboard_backspace_rounded,
                      color: Colors.black,
                      size: 35.0,
                      semanticLabel: 'Home',
                    ),
                  ),
                )
            ),
            const Expanded(
              flex: 4,
              child: Text(""),
            ),
            Expanded(
              flex: 7,
              child: Align(
                alignment: Alignment.center,
                child: Text("OTP Verification", style: phoneTitle,),
              ),
            ),
            Expanded(
              flex: 14,
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(""),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(otpCA, style: userSignOnOccupationTitleGrey,),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(otpCB, style: userSignOnOccupationTitleGrey,),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(otpCC, style: userSignOnOccupationTitleGrey,),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(otpCD, style: userSignOnOccupationTitleGrey,),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(otpCE, style: userSignOnOccupationTitleGrey,),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(otpCF, style: userSignOnOccupationTitleGrey,),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(""),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Please enter the 6-digit code sent", style: eachChatTitleFEG,),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("to you at ", style: eachChatTitleFEG,),
                        Text(UserSignOn.phoneNumber, style: eachChatTitleFEGB,)
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 34,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                    color: Colors.transparent,
                    border: Border.all(color: phoneBoxGrey, width: 1.5,),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 25,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: (){
                                  registerOTPTap("1");
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child:  Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.transparent,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('1', style: headingTextTitlesKeyPadOTP,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: (){
                                  registerOTPTap("2");
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child:  Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.transparent,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('2', style: headingTextTitlesKeyPadOTP,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: (){
                                  registerOTPTap("3");
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child:  Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('3', style: headingTextTitlesKeyPadOTP,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 25,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: (){
                                  registerOTPTap("4");
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child:  Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.transparent,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('4', style: headingTextTitlesKeyPadOTP,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: (){
                                  registerOTPTap("5");
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child:  Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.transparent,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('5', style: headingTextTitlesKeyPadOTP,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: (){
                                  registerOTPTap("6");
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child:  Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.transparent,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('6', style: headingTextTitlesKeyPadOTP,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 25,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: (){
                                  registerOTPTap("7");
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child:  Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.transparent,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('7', style: headingTextTitlesKeyPadOTP,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: (){
                                  registerOTPTap("8");
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child:  Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.transparent,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('8', style: headingTextTitlesKeyPadOTP,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: (){
                                  registerOTPTap("9");
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child:  Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.transparent,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('9', style: headingTextTitlesKeyPadOTP,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 25,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: (){
                                  registerOTPTap("*");
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child:  Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.transparent,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('*', style: headingTextTitlesKeyPadOTP,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: (){
                                  registerOTPTap("0");
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child:  Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.transparent,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('0', style: headingTextTitlesKeyPadOTP,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: (){
                                  registerOTPTap("#");
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child:  Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.transparent,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('#', style: headingTextTitlesKeyPadOTP,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Expanded(
              flex: 5,
              child: Text(""),
            ),
            Expanded(
              flex: 6,
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text("", style: headingTextTitles,),
                      ),
                    ),
                    const Expanded(
                      flex: 3,
                      child: Text(""),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Text(""),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: GestureDetector(
                          onTap: (){
                            removeOneChar();
                          },
                          child: Text("Delete", style: headingTextTitles,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
