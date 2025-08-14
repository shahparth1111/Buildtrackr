import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'text_styles.dart';
import 'java_methods.dart';
import 'verifyotp.dart';

class UserSignOn extends StatefulWidget {
  static String phoneNumber="";
  static bool isTestAccount = false;
  const UserSignOn({Key? key}) : super(key: key);

  @override
  State<UserSignOn> createState() => _UserSignOnState();
}
class _UserSignOnState extends State<UserSignOn> {
  String initialCountry="in", selectedCountryCode="+91";
  bool isSearchTyped=false, isPhoneNumberCorrect=false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  JavaMethodsCustom sBase = JavaMethodsCustom();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController phoneNumberControllerPhone = TextEditingController();
  List<String> filteredList=<String>[];
  List<String> newFilteredList=<String>[];
  dynamic path;
  final TextEditingController manualOTPController = TextEditingController();
  final otpController = TextEditingController();

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }
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
    sBase.writeFilesRealtime(path, "User", "Details", "ICountryCode", selectedCountryCode, false);
    checkInternetConnection();
    loadFilteredList();
  }
  void checkInternetConnection()async{
    bool networkAvailable = await checkNetworkConnectivity();
    if(!networkAvailable) {
      showDynamicMessage("No Internet Connection", false);
    }
  }
  void loadCountryCode()async{
    Locale? l = await Devicelocale.currentAsLocale;
    setState(() {
      initialCountry = l!.countryCode.toString();
      for (var countryLine in filteredList) {
        String imageName = (countryLine.substring(countryLine.indexOf("~")+1, countryLine.lastIndexOf("~"))).toLowerCase();
        if(imageName==initialCountry.toLowerCase()){
          selectedCountryCode = "+${countryLine.substring(countryLine.lastIndexOf("~")+1)}";
        }
      }
    });
  }
  void loadFilteredList(){
    filteredList = sBase.countryListA.toList();
    loadCountryCode();
  }
  Future<bool> checkNetworkConnectivity()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    else{
      return false;
    }
  }
  void _selectCountryCode(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.001),
            child: DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              maxChildSize: 1.0,
              builder: (_, controller) {
                return StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateC) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,
                            right: 20,
                          ),
                          child: TextField(
                            style: userRegistrationTitleU,
                            autofocus: isSearchTyped?true:false,
                            textAlign: TextAlign.start,
                            onChanged: (text) {
                              isSearchTyped=true;
                              setStateC((){
                                newFilteredList = filteredList
                                    .where((u) => (u
                                    .toLowerCase()
                                    .contains(text.toLowerCase())
                                )).toList();
                              });
                              setState(() {
                              });
                            },
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Search Country',
                              hintStyle: userSignOnTextField,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            controller: phoneNumberController,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: ListView.builder(
                              controller: controller,
                              itemCount: newFilteredList.isEmpty?sBase.countryListA.length:newFilteredList.length,
                              itemBuilder: (_, index) {
                                String countryLine="", countryName="", imageName="", countryCode="";
                                if(newFilteredList.isNotEmpty){
                                  countryLine = newFilteredList[index];
                                  countryName = countryLine.substring(0, countryLine.indexOf("~"));
                                  imageName = (countryLine.substring(countryLine.indexOf("~")+1, countryLine.lastIndexOf("~"))).toLowerCase();
                                  countryCode = "+${countryLine.substring(countryLine.lastIndexOf("~")+1)}";
                                }
                                else{
                                  countryLine = sBase.countryListA.elementAt(index);
                                  countryName = countryLine.substring(0, countryLine.indexOf("~"));
                                  imageName = (countryLine.substring(countryLine.indexOf("~")+1, countryLine.lastIndexOf("~"))).toLowerCase();
                                  countryCode = "+${countryLine.substring(countryLine.lastIndexOf("~")+1)}";
                                }
                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    if(Navigator.canPop(context)){
                                      Navigator.pop(context);
                                    }
                                    setState(() {
                                      if(newFilteredList.isNotEmpty){
                                        countryLine = newFilteredList[index];
                                      }
                                      else {
                                        countryLine = sBase.countryListA.elementAt(index);
                                      }
                                      isSearchTyped=false;
                                      try{
                                        countryName = countryLine.substring(0, countryLine.indexOf("~"));
                                        initialCountry = (countryLine.substring(countryLine.indexOf("~")+1, countryLine.lastIndexOf("~"))).toLowerCase();
                                        selectedCountryCode = "+${countryLine.substring(countryLine.lastIndexOf("~")+1)}";
                                      }catch(exception){}
                                      sBase.writeFilesRealtime(path, "User", "Details", "ICountryCode", selectedCountryCode, false);
                                      newFilteredList.clear();
                                      phoneNumberController.clear();
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                              "assets/flags/$imageName.png",
                                            ),
                                            radius: 27,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: Text(countryName, style: userSignOnCountryList,),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: Text(countryCode),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
              },
            ),
          ),
        );
      },
    );
  }
  void hideKeyboard(){
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }catch(exception){}
  }
  void openPrivacyPolicy()async {
    const url = 'https://smatter.app/legal/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Container(
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text('Unknown Error', style: userSignOnPhoneVerificationTitle, textAlign: TextAlign.center,),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          },
        );
    }
  }
  void openTerms()async {
    const url = 'https://smatter.app/legal/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text('Unknown Error', style: userSignOnPhoneVerificationTitle, textAlign: TextAlign.center,),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        },
      );
    }
  }
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
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
        body: Container(
          color: const Color(0xffF1F2F5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Expanded(
                flex: 1,
                child: Text(""),
              ),
              const Expanded(
                flex: 2,
                child: Icon(
                  Icons.remove,
                  color: nightModeGrey,
                  size: 20.0,
                  semanticLabel: 'Home',
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.security,
                            color: Colors.white,
                            size: 20.0,
                            semanticLabel: 'Home',
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("Phone Number Verification", style: userSignOnPhoneVerificationTitle),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 60,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffF1F2F5),
                    borderRadius: BorderRadius.only(
                        topLeft:  Radius.circular(40.0),
                        topRight: Radius.circular(40.0)
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Image.asset(
                          "assets/graphics/otpbannericon.png",
                          width: 130.0,
                          height: 130.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("Add your phone number. We'll send you a", style: userSignOnText,),
                      Text("verification code so we know you're real.", style: userSignOnText,),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: phoneBoxGrey,
                            borderRadius: BorderRadius.all(Radius.circular(8.0)
                            ),
                          ),
                          width: double.infinity,
                          height: 55,
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    height: 50,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/flags/${initialCountry.toLowerCase()}.png",
                                            width: 25.0,
                                            height: 20.0,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(selectedCountryCode),
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black,
                                            size: 20.0,
                                            semanticLabel: 'Drop-down arrow',
                                          ),
                                        ],
                                      ),
                                    )),
                                onTap: (){
                                  _selectCountryCode(context);
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 8,
                                  child: SizedBox(
                                      height: 50,
                                      child: TextField(
                                        controller: phoneNumberControllerPhone,
                                        keyboardType: TextInputType.number,
                                        onChanged: (text){
                                          if(text.length==10){
                                            setState(() {
                                              hideKeyboard();
                                              isPhoneNumberCorrect=true;
                                            });
                                          }
                                          else{
                                            setState(() {
                                              isPhoneNumberCorrect=false;
                                            });
                                          }
                                        },
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Mobile Number",
                                            labelStyle: TextStyle(fontSize: 24)),
                                      ))),
                              Expanded(
                                flex: 2,
                                child: isPhoneNumberCorrect?const Center(
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    color: darkGreen,
                                    size: 22.0,
                                    semanticLabel: 'Correct',
                                  ),
                                ):const Icon(
                                  Icons.highlight_remove_outlined,
                                  color: darkRed,
                                  size: 22.0,
                                  semanticLabel: 'Cross',
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Read our ", style: userSignOnTextTerms,),
                          GestureDetector(
                            onTap: (){
                              openPrivacyPolicy();
                            },
                            child: Text("Privacy Policy ", style: userSignOnTextBlue,),
                          ),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.only(right: 0.0),
                              child: Text(
                                "Tap \"Agree and Continue\" to",
                                overflow: TextOverflow.ellipsis,
                                style: userSignOnTextTerms,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("accept the ", style: userSignOnTextTerms,),
                          GestureDetector(
                            onTap: (){
                              openTerms();
                            },
                            child: Text("Terms of Service", style: userSignOnTextBlue,),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: (){
                            String finalPhoneNumber= selectedCountryCode + phoneNumberControllerPhone.text;
                            UserSignOn.phoneNumber = finalPhoneNumber;
                            if(isPhoneNumberCorrect) {
                              if(finalPhoneNumber=="+919099050332"){
                                UserSignOn.isTestAccount=true;
                              }
                              showDynamicMessage("Sending OTP..", false);
                              executeVerification(finalPhoneNumber);
                            }
                            else{
                              showDynamicMessage("Incorrect Phone Number..", true);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Container(
                              height: 50,
                              width: 250,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Color(0xff000026),
                                      Color(0xff000026),
                                    ],
                                  )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Center(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.white,
                                          size: 22.0,
                                          semanticLabel: 'Friends',
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        Text("Agree and Continue", style: headingTextTitlesW),
                                      ],
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: const Color(0xffF1F2F5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: Text("Step 1/2", style: userSignOnTextTerms,),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: Text("Step 2/2", style: userSignOnTextTerms,),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Container(
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: darkBlue,
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: Container(
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: phoneBoxGrey,
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    controller.dispose();
    phoneNumberController.dispose();
    phoneNumberControllerPhone.dispose();
    super.dispose();
  }
  void executeVerification(String finalPhoneNumber)async{
    await phoneSignIn(phoneNumber: UserSignOn.phoneNumber, );
  }
  Future<void> phoneSignIn({required String phoneNumber}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 10),
      verificationCompleted: (PhoneAuthCredential credential) {
        _onVerificationCompleted(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        _onVerificationFailed(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        _onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        VerifyOTP.verificationId = verificationId;
      },
    );
  }
  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (authCredential.smsCode != null) {
      try{
        await user!.linkWithCredential(authCredential);
      }on FirebaseAuthException catch(e){
        if(e.code == 'provider-already-linked'){
          await VerifyOTP.auth.signInWithCredential(authCredential);
        }
      }
      if(Navigator.canPop(context)){
        Navigator.pop(context);
      }
      VerifyOTP.alreadyVerified=true;
      _pushPage(context, VerifyOTP());
    }
  }
  _onVerificationFailed(FirebaseAuthException exception) {
  }
  _onCodeSent(String verificationId, int? forceResendingToken) {
    VerifyOTP.verificationId = verificationId;
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }
    _pushPage(context, const VerifyOTP());
  }
}