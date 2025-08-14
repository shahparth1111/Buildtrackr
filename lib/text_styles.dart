import 'package:flutter/material.dart';
import 'home.dart';

const Color color = Color(0xff000026);
const Color darkGrey = Color(0xff717171);
const Color colorL = Color(0xffD2CDE7);
const Color nightModeGrey = Color(0xff2E2F31);
const Color chatModeGrey = Color(0xff3C3F41);
const Color darkBlue = Color(0xff000026);
const Color lightBlack = Color(0xff4D4D4D);
const Color darkGreen = Color(0xff2C7002);
const Color chatBackground = Color(0xffFAFAFC);
const Color veryLightGrey = Color(0xffCDCDCD);
const Color linkBlue = Color(0xff69BEE7);
const Color phoneBoxGrey = Color(0xffE8EAED);
const Color originalCodingGrey = Color(0xff5E5F60);
const Color darkRed = Color(0xffA60105);
Color lightOrange = const Color(0xff000026).withOpacity(0.6);
const Color vLightOrange = Color(0xffF3A183);
const Color darkOrange = Color(0xff000026);
const Color lG = Color(0xffCCCCCC);
const Color vLG = Color(0xffEBECEC);
const Color vVLG = Color(0xffFAFAFA);
const Color colorRed = Color(0xffA60105);
Color colorRatingOneStar = const Color(0xffA60105);
Color colorRatingTwoStar = const Color(0xffA60105);
Color colorRatingThreeStar = const Color(0xffA60105);
Color colorRatingFourStar = const Color(0xff2C7002);
Color colorRatingFiveStar = const Color(0xff2C7002);

double twelveFSize = 12.0 + HomePage.fontSizeAddition,
    thirteenFSize = 13.0 + HomePage.fontSizeAddition,
    fourteenFSize = 14.0 + HomePage.fontSizeAddition,
    fifteenFSize = 15.0 + HomePage.fontSizeAddition,
    sixteenFSize = 16.0 + HomePage.fontSizeAddition,
    seventeenFSize = 17.0 + HomePage.fontSizeAddition,
    eighteenFSize = 18.0 + (HomePage.fontSizeAddition*1.5),
    twentyOneFSize = 21.0 + (HomePage.fontSizeAddition*1.5),
    twentyFiveFSize = 25.0 + (HomePage.fontSizeAddition*1.5),
    twentySevenFSize = 27.0 + (HomePage.fontSizeAddition*2),
    thirtyFSize = 30.0 + (HomePage.fontSizeAddition*2),
    twentyFourFSize = 24.0 + (HomePage.fontSizeAddition*2),
    thirtySixFSize = 36.0 + (HomePage.fontSizeAddition*2),
    fortyEight = 48.0 + (HomePage.fontSizeAddition*3),
    fiftySix = 64.0 + (HomePage.fontSizeAddition*3),
    elevenFSize = 11.0 + HomePage.fontSizeAddition;

final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.transparent,
    textStyle: userSignOnText,
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
).copyWith(
    side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return const BorderSide(
                    color: Colors.white,
                    width: 0.1,
                );
            }
            return const BorderSide(
                color: Colors.white,
                width: 0.1,
            );// Defer to the widget's default.
        },
    ),
);

final ButtonStyle outlineButtonStyleS = OutlinedButton.styleFrom(
    foregroundColor: darkRed,
    backgroundColor: Colors.white,
    textStyle: userSignOnText,
    padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
    ),
).copyWith(
    side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
                return const BorderSide(
                    color: Colors.white,
                    width: 0.1,
                );
            }
            return const BorderSide(
                color: Colors.white,
                width: 0.1,
            );// Defer to the widget's default.
        },
    ),
);
final ButtonStyle outlineButtonStyleB = OutlinedButton.styleFrom(
    foregroundColor: darkRed,
    backgroundColor: Colors.white,
    textStyle: userSignOnText,
    padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
).copyWith(
    side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
                return const BorderSide(
                    color: Colors.white,
                    width: 0.1,
                );
            }
            return const BorderSide(
                color: Colors.white,
                width: 0.1,
            );// Defer to the widget's default.
        },
    ),
);
final ButtonStyle oKeyS = OutlinedButton.styleFrom(
    foregroundColor: darkRed,
    backgroundColor: Colors.white,
    textStyle: userSignOnText,
).copyWith(
    side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
                return const BorderSide(
                    color: Colors.white,
                    width: 0.1,
                );
            }
            return const BorderSide(
                color: Colors.white,
                width: 0.1,
            );// Defer to the widget's default.
        },
    ),
);

TextStyle headingTextTitlesD = TextStyle(
    fontSize: fiftySix,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle headingTextTitlesDB = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Gilroy',
    color: darkBlue,
);
TextStyle headingTextTitles = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle headingTextTitlesBGAA = TextStyle(
    fontSize: fortyEight,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle headingTextTitlesBGAAT = TextStyle(
    fontSize: thirtySixFSize,
    fontFamily: 'GilroyHeavy',
    color: Colors.black,
);
TextStyle headingTextTitlesBGAAST = TextStyle(
    fontSize: seventeenFSize,
    fontFamily: 'RobotoSlab-Thin',
    color: Colors.black26,
);
TextStyle headingTextTitlesBJT = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Bourbon',
    color: Colors.black,
);
TextStyle headingTextTitlesG = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Gilroy',
    color: darkGrey,
);
TextStyle headingTextTitlesGC = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: lG,
);
TextStyle headingTextTitlesGS = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Gilroy',
    color: darkGrey,
);
TextStyle headingTextTitlesGSR = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Gilroy',
    color: darkRed,
);
TextStyle headingTextTitlesGA = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Arial',
    color: darkGrey,
);
TextStyle headingTextTitlesGABG = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Arial',
    color: darkGrey,
);
TextStyle headingTextTitlesGABGR = TextStyle(
    fontSize: thirtyFSize,
    fontFamily: 'Gilroy',
    color: darkRed,
);
TextStyle headingTextTitlesGAB = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Arial',
    color: Colors.black,
);
TextStyle headingTextTitlesGEB = TextStyle(
    fontSize: thirtyFSize,
    fontFamily: 'Gilroy',
    color: darkGrey,
);
TextStyle headingTextTitlesWS = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'Gilroy',
    color: Colors.white
);
TextStyle headingTextTitlesWSLG = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'Gilroy',
    color: lG
);
TextStyle headingTextTitlesWSG = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: darkGrey
);
TextStyle headingTextTitlesWSA = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'Arial',
    color: Colors.white70
);
TextStyle headingTextTitlesW = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white
);
TextStyle headingTextTitlesWK = TextStyle(
    fontSize: eighteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white
);
TextStyle headingTextTitlesWKD = TextStyle(
    fontSize: seventeenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white
);
TextStyle headingTextTitlesO = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Gilroy',
    color: const Color(0xfff3a183),
);
TextStyle headingTextTitlesON = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Gilroy',
    color: darkGrey
);
TextStyle headingTextTitlesONTitle = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Gilroy',
    color: darkGrey
);
TextStyle headingTextTitlesONTitleLB = TextStyle(
    fontSize: thirtyFSize,
    fontFamily: 'Arial',
    color: darkGreen,
);
TextStyle headingTextTitlesONTitleLBC = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black
);
TextStyle headingTextTitlesONTitleDO = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Gilroy',
    color: darkOrange,
);
TextStyle headingTextTitlesKeyPadOTP = TextStyle(
    fontSize: twentyFourFSize,
    fontFamily: 'Gilroy',
    color: Colors.grey,
);
TextStyle cBoxMessagesKeypadW = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'Gilroy',
    color: Colors.grey,
);
TextStyle cBoxMessagesKeypad = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle settingsHeadingTitlesT = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle userSignOnTextField = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.grey,
);
TextStyle userSignOnTextFieldB = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle userSignOnTextFieldW = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle userSignOnOccupationTitleGreySLWN = TextStyle(
    fontSize: eighteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle fullyBookedFonts = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Gilroy',
    color: darkRed,
);
TextStyle progressDialogStyle = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Gilroy',
    color: color,
);
TextStyle monthDayTitle = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'GilroyHeavy',
    color: Colors.grey,
);
TextStyle phoneTitle = TextStyle(
    fontSize: twentyFiveFSize,
    fontFamily: 'Gilroy',
    color: darkOrange,
);
TextStyle phoneTitleS = TextStyle(
    fontSize: twentyOneFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle userRegistrationTitleU = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle userRegistrationTitleUDB = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: darkBlue,
);
TextStyle userRegistrationTitleUW = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle userSignOnOccupationTitle = TextStyle(
    fontSize: eighteenFSize,
    fontFamily: 'GilroyHeavy',
    color: Colors.black,
);
TextStyle matchTitle = TextStyle(
    fontSize: twentySevenFSize,
    fontFamily: 'GilroyHeavy',
    color: Colors.white,
);
TextStyle userSignOnOccupationTitleBig = TextStyle(
    fontSize: eighteenFSize,
    fontFamily: 'GilroyHeavy',
    color: Colors.black,
);
TextStyle userSignOnOccupationTitleWhite = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle headingTextTitlesCError = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle headingTextTitleLarge = TextStyle(
    fontSize: thirtySixFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle headingTextTitlesCErrorB = TextStyle(
    fontSize: eighteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle headingTextTitlesOverlay = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Bourbon',
    color: Colors.black,
);
TextStyle headingTextTitlesOverlayWhite = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Bourbon',
    color: Colors.white,
);
TextStyle settingsHeadingTitlesS = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Gilroy',
    color: darkGrey,
);
TextStyle settingsHeadingTitlesSR = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Gilroy',
    color: darkRed,
);
TextStyle headingTextTitlesB = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Bourbon',
    color: Colors.white,
);
TextStyle headingTextTitlesBG = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Bourbon',
    color: Colors.grey,
);
TextStyle headingTextTitlesKM = TextStyle(
    fontSize: thirtySixFSize,
    fontFamily: 'Bourbon',
    color: Colors.white,
);
TextStyle headingTextTitlesTime = TextStyle(
    fontSize: fiftySix,
    fontFamily: 'Bourbon',
    color: Colors.white,
);
TextStyle headingTextTitlesSTEPS = TextStyle(
    fontSize: eighteenFSize,
    fontFamily: 'Bourbon',
    color: Colors.white,
);
TextStyle headingTextTitlesSTEPSG = TextStyle(
    fontSize: twentyFourFSize,
    fontFamily: 'GilroyHeavy',
    color: Colors.white,
);
TextStyle headingTextTitlesSTEPSGL = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle headingTextTitlesSTEPSGLA = TextStyle(
    fontSize: eighteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle headingTextTitlesTI = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Bourbon',
    color: Colors.white,
);
TextStyle headingTextTitlesTITIME = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'GilroyHeavy',
    color: Colors.white,
);
TextStyle userSignOnOccupationTitleGrey = TextStyle(
    fontSize: eighteenFSize,
    fontFamily: 'GilroyHeavy',
    color: lightOrange,
);
TextStyle userSignOnOccupationTitleGreyS = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle userSignOnOccupationTitleGreySL = TextStyle(
    fontSize: eighteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle userSignOnOccupationTitleGreySLR = TextStyle(
    fontSize: eighteenFSize,
    fontFamily: 'Gilroy',
    color: darkRed,
);
TextStyle userSignOnOccupationTitleGreySLW = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle userSignOnOccupationTitleGreySLWB = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Gilroy',
    color: darkBlue,
);
TextStyle userSignOnOccupationTitleLight = TextStyle(
    fontSize: eighteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle userSignOnOccupationTitleG = TextStyle(
    fontSize: thirtySixFSize,
    fontFamily: 'GilroyHeavy',
    color: Colors.grey,
);
TextStyle userSignOnCountryList = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Arial',
    color: Colors.black,
);
TextStyle userSignOnText = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Arial',
    color: Colors.grey,
);
TextStyle userSignOnTextTC = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'Arial',
    color: Colors.grey,
);
TextStyle userSignOnTextTitle = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Arial',
    color: Colors.black,
);
TextStyle userSignOnTextTitleWhite = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Arial',
    color: Colors.white,
);
TextStyle userSignOnTextTitleBlack = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Arial',
    color: Colors.black,
);
TextStyle userSignOnTextTitleFeatures = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Arial',
    color: Colors.grey,
);
TextStyle userSignOnTextPhone = TextStyle(
    fontSize: fourteenFSize,
    color: originalCodingGrey,
);
TextStyle userSignOnTextPhoneS = TextStyle(
    fontSize: fifteenFSize,
    color: Colors.black,
);
TextStyle userSignOnTextBlue = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Arial',
    color: linkBlue,
);
TextStyle userSignOnTextBlueS = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'Arial',
    color: linkBlue,
);
TextStyle updateStockSelect = const TextStyle(
    fontSize: 15,
    fontFamily: 'Gilroy',
    color: Colors.grey,
);
TextStyle updateStockSelectBlack = const TextStyle(
    fontSize: 15,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle userSignOnTextTerms = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'Arial',
    color: Colors.grey,
);
TextStyle userSignOnPhoneVerificationTitle = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle userSignOnPhoneVerificationTitleSmall = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle userSignOnPhoneVerificationTitleBlack = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle userSignOnPhoneVerificationTitleBlackS = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle eachChatTime = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'Arial',
    color: originalCodingGrey,
);
TextStyle messageTextFont = TextStyle(
    fontSize: elevenFSize,
    fontFamily: 'Gilroy',
    color: Colors.grey,
);
TextStyle messageTextFontBlack = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Arial',
    color: Colors.black,
);
TextStyle messageTextFontWhite = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Arial',
    color: Colors.white,
);
TextStyle messageTextFontWhiteC = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Arial',
    color: Colors.white,
);
TextStyle messageTextFontWhiteCB = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Arial',
    color: darkBlue,
);
TextStyle messageTextFontWhiteOB = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.blue,
);
TextStyle eachChatNewMessageCount = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'Arial',
    color: Colors.white,
);
TextStyle eachChatContentF = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Arial',
    color: originalCodingGrey,
);
TextStyle userRegistrationTitle = const TextStyle(
    fontSize: 14,
    fontFamily: 'Gilroy',
    color: color,
);
TextStyle eachChatTitleF = TextStyle(
    fontSize: fifteenFSize,
    fontFamily: 'Gilroy',
    color: originalCodingGrey,
);
TextStyle eachChatTitleFE = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: originalCodingGrey,
);
TextStyle eachChatTitleFEG = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.grey,
);
TextStyle eachChatTitleFEGB = TextStyle(
    fontSize: thirteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.black,
);
TextStyle chatBoxTitleF = TextStyle(
    fontSize: seventeenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle chatBoxSubTitleF = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'Arial',
    color: lightBlack,
);
TextStyle chatBoxSubTitleFR = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'Gilroy',
    color: darkRed,
);
TextStyle chatBoxSubTitleFS = TextStyle(
    fontSize: elevenFSize,
    fontFamily: 'Gilroy',
    color: Colors.grey,
);
TextStyle chatBoxSubTitleFSW = TextStyle(
    fontSize: elevenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle userSignOnPhoneVerificationTitleActive = TextStyle(
    fontSize: sixteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);
TextStyle fridaySubT = TextStyle(
    fontSize: twentySevenFSize,
    fontFamily: 'Yantramanav Thin',
    color: Colors.white,
);
TextStyle homeTitleApp = TextStyle(
    fontSize: twentyFourFSize,
    fontFamily: 'GilroyHeavy',
    color: Colors.white,
);
TextStyle fridayTitle = TextStyle(
    fontSize: twentySevenFSize,
    fontFamily: 'Righteous',
    color: Colors.white,
);
TextStyle homeSubTitleApp = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'GilroyHeavy',
    color: Colors.grey,
);
TextStyle chatBoxTime = TextStyle(
    fontSize: twelveFSize,
    fontFamily: 'Gilroy',
    color: Colors.grey,
);
TextStyle userSignOnVerifyButton = TextStyle(
    fontSize: fourteenFSize,
    fontFamily: 'Gilroy',
    color: Colors.white,
);