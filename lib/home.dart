import 'dart:io';
import 'dart:math';
import 'restartapp.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:photo_view/photo_view.dart';
import 'usersignon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'text_styles.dart';
import 'java_methods.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  static double fontSizeAddition=2;
  static String themeMode="original", activeScreen="Home";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> with WidgetsBindingObserver, SingleTickerProviderStateMixin{
  String message = '';
  String eventToken = 'not yet';
  FirebaseApp defaultApp = Firebase.app();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController controller = TextEditingController();
  JavaMethodsCustom sBase = JavaMethodsCustom();
  dynamic path;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController newUserController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController challanController = TextEditingController();
  final TextEditingController phoneNumberControllerPhone = TextEditingController();
  final TextEditingController phoneNumberControllerGroupPassword = TextEditingController();
  final TextEditingController itemUsageListController = TextEditingController();
  final TextEditingController itemStatusListController = TextEditingController();
  final TextEditingController companyAuthCode = TextEditingController();
  final TextEditingController orderID = TextEditingController();
  ScrollController scrollController = ScrollController();
  ScrollController settingsControllerS = ScrollController();
  late FirebaseDatabase database;
  late File iF;
  String selectedItem="Select Item", selectedSite="Site Location",
      selectedUnit="Unit", phoneNumber="", appVersion="v1.0.1", cBoxText="Smatter",
      numTyp="", myPicture="", selectedFileType="", companyCode="Default",
      userPictureName="", companyA="Auth: ", userRights="None", selectedUpdate="None",
      deliverySelection="DeliveryDebit", selectedCompany="Select Company", showDList="None",
      _dropDownValue="";
  double separatorWidth = 0;
  int checkDeletePhotoDuplicate=0, duplicateCounter=0;
  dynamic dBRef13, dBRef15, dBRef16, dBRef18, dBRef9, dBRef11, dBRef12, dBRef17, dBRef20, dBRef21;
  dynamic subscription;
  bool isNotificationsOn=true, isSearchTyped=false, isSearchStatus=false, showMainSearch=false,
      isFromPrivate=false, isTyped=false, showAccountSearch=false, keyboardFocus=false,
      isCAPON=false, isCAPOnF=false, isAlphaNumericK=true, showError=false, imageFound=false,
      isSearchTypedStatus=false, isOrder=false;
  List<String> finalLanguageList = <String>[];
  List<String> groupSelect = <String>[];
  List<String> itemList=<String>[];
  List<String> filteredItemList=<String>[];
  List<String> unitList=<String>[];
  List<String> filteredUnitList=<String>[];
  List<String> siteLocationList=<String>[];
  List<String> filteredSiteLocationList=<String>[];
  List<String> companyList=<String>[];
  List<String> filteredCompanyList=<String>[];
  List<ItemStatus> iS = <ItemStatus>[];
  List<ItemStatus> iSFiltered = <ItemStatus>[];
  List<ItemUsage> iUsage = <ItemUsage>[];
  List<ItemUsage> iUsageFiltered = <ItemUsage>[];
  List<OrderList> oList = <OrderList>[];
  List<OrderList> oListFiltered = <OrderList>[];
  List<UserRights> userRightsL = <UserRights>[];
  final snackBarA = const SnackBar(
    content: Text('Deleting Item..'),
  );

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }
  @override
  void initState(){
    if (!kDebugMode){
      //appCheck.onTokenChange.listen(setEventToken);
    }
    super.initState();
    if (!kDebugMode){
      //appCheck.getToken(true);
    }
    database = FirebaseDatabase.instanceFor(app: defaultApp, databaseURL: 'https://buildtrackr-opensource-default-rtdb.firebaseio.com');
    //database = Firebase$companyCode/Database.instance;
    //initAnimationBackground();
    initializeVariables();
  }
  void setMessage(String message) {
    setState(() {
      message = message;
    });
  }
  void setEventToken(String? token) {
    eventToken = token ?? 'not yet';
  }
  @override
  void setState(VoidCallback fn){
    if(mounted){
      super.setState(fn);
    }
  }
  void initializeVariables()async{
    if (!kDebugMode){
      //await appCheck.setTokenAutoRefreshEnabled(true);
    }
    path = await _localPath;
    if(sBase.checkFileExistSync(path, "User", "Details", "Verification")){
      loadInBackground();
    }
    else{
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          FirebaseAuth fAuth = FirebaseAuth.instance;
          fAuth.signInAnonymously().then((uC) {
            transferToVerification();
          });
        }
        else{
          transferToVerification();
        }
      });
    }
  }
  void transferToVerification(){
    _pushPage(context, const UserSignOn());
  }
  void loadItemNames(){
    itemList.clear();
    sBase.getAllFilesSubDirectory(path, "Data", "ItemName").forEach((itemKeys) {
      //File: '/data/user/0/com.smatter.buildtrackr/cache/Data/ItemName/I1'
      String iK = itemKeys.toString();
      iK = iK.substring(iK.lastIndexOf("/")+1, iK.length-1);
      String itemName = sBase.getFirstLineSync(path, "Data", "ItemName", iK);
      String toAdd = "$iK-$itemName";
      itemList.add(toAdd);
    });
  }
  void loadCompanyNames(){
    companyList.clear();
    sBase.getAllFilesSubDirectory(path, "Data", "CompanyName").forEach((itemKeys) {
      String iK = itemKeys.toString();
      iK = iK.substring(iK.lastIndexOf("/")+1, iK.length-1);
      String itemName = sBase.getFirstLineSync(path, "Data", "CompanyName", iK);
      String toAdd = "$iK-$itemName";
      companyList.add(toAdd);
    });
  }
  void loadUnitNames(){
    unitList.clear();
    sBase.getAllFilesSubDirectory(path, "Data", "UnitName").forEach((unitKeys) {
      String uK = unitKeys.toString();
      uK = uK.substring(uK.lastIndexOf("/")+1, uK.length-1);
      String unitName = sBase.getFirstLineSync(path, "Data", "UnitName", uK);
      String toAdd = "$uK-$unitName";
      unitList.add(toAdd);
    });
  }
  void loadSiteNames(){
    siteLocationList.clear();
    sBase.getAllFilesSubDirectory(path, "Data", "SiteName").forEach((siteKeys) {
      String sK = siteKeys.toString();
      sK = sK.substring(sK.lastIndexOf("/")+1, sK.length-1);
      String siteName = sBase.getFirstLineSync(path, "Data", "SiteName", sK);
      String toAdd = "$sK-$siteName";
      siteLocationList.add(toAdd);
    });
  }
  void loadItemUsageList(){
    iUsage.clear();
    sBase.getAllFilesSubDirectory(path, "LiveEachItem", "Database").forEach((itemKeys) {
      //File: '/data/user/0/com.smatter.buildtrackr/cache/Data/ItemName/I1'
      String iK = itemKeys.toString();
      iK = iK.substring(iK.lastIndexOf("/")+1, iK.length-1);
      String eachItemUsageDetails = sBase.getFirstLineSync(path, "LiveEachItem", "Database", iK);
      int eC=0;
      String iName="", iQ="", iP="", iType="", iSL="", iUser="", iDT="", iInvoice="", iC="",
          iPictureName="", iStatus="";
      sBase.delimitString(eachItemUsageDetails, "~").forEach((element) {
        if(eC==0){
          iName=element;
        }
        else if(eC==1){
          iQ=element;
        }
        else if(eC==2){
          iP=element;
        }
        else if(eC==3){
          iType=element;
        }
        else if(eC==4){
          iSL=element;
        }
        else if(eC==5){
          iUser=element;
        }
        else if(eC==6){
          iDT=element;
        }
        else if(eC==7){
          iInvoice=element;
        }
        else if(eC==8){
          iC=element;
        }
        else if(eC==9){
          iPictureName=element;
          String imageURL = iPictureName;
          String pY="", pM="", pD="", pT="";
          //sBase.deleteFile(path, 'UserPicture','Success', imageURL);
          //print(sBase.checkFileExistSync(path, 'UserPicture','Success', imageURL));
          if(!sBase.checkFileExistSync(path, 'UserPicture','Success', imageURL) && imageURL!='#'){
            int eP=0;
            sBase.delimitString(imageURL, "-").forEach((element) {
              if(eP==0){
                pY=element;
              }
              else if(eP==1){
                pM=element;
              }
              else if(eP==2){
                pD=element;
              }
              else if(eP==3){
                pT=element;
              }
              eP++;
            });
            pT = imageURL.substring(imageURL.lastIndexOf("-")+1, imageURL.indexOf("."));
            String cPN = "$pY/$pM/$pD/$pT";
            downloadProfilePicture(cPN, imageURL);
          }
        }
        else if(eC==10){
          iStatus=element;
        }
        eC++;
      });
      setState(() {
        iUsage.add(getObjectWithItemUsage(iName, iQ, iP, iType, iSL, iUser, iDT, iInvoice,
            iC, iPictureName, iStatus, iK));
      });
    });
  }
  void loadItemOrderList(){
    oList.clear();
    sBase.getAllFilesSubDirectory(path, "LiveEachOrder", "Database").forEach((itemKeys) {
      //File: '/data/user/0/com.smatter.buildtrackr/cache/Data/ItemName/I1'
      String iK = itemKeys.toString();
      iK = iK.substring(iK.lastIndexOf("/")+1, iK.length-1);
      String eachItemUsageDetails = sBase.getFirstLineSync(path, "LiveEachOrder", "Database", iK);
      int eC=0;
      String oID="", iName="", suppName="", iQuantity="", iUnit="", iPrice="", iTime="", iStatus="";
      sBase.delimitString(eachItemUsageDetails, "~").forEach((element) {
        if(eC==0){
          oID=element;
        }
        else if(eC==1){
          iName=element;
        }
        else if(eC==2){
          iQuantity=element;
        }
        else if(eC==3){
          iPrice=element;
        }
        else if(eC==4){
          iUnit=element;
        }
        else if(eC==5){
          suppName=element;
        }
        else if(eC==6){
          iTime=element;
        }
        else if(eC==7){
          iStatus=element;
        }
        eC++;
      });
      setState(() {
        oList.add(getObjectWithItemOrder(oID, iName, suppName, iQuantity, iUnit, iPrice, iTime, iStatus));
      });
    });
  }
  void loadItemStatusList(){
    iS.clear();
    sBase.getAllFilesSubDirectory(path, "LiveStock", "Database").forEach((itemKeys) {
      //File: '/data/user/0/com.smatter.buildtrackr/cache/Data/ItemName/I1'
      String iK = itemKeys.toString();
      iK = iK.substring(iK.lastIndexOf("/")+1, iK.length-1);
      String eachItemUsageDetails = sBase.getFirstLineSync(path, "LiveStock", "Database", iK);
      int eC=0;
      String iName="", iQ="", iP="", iTotal="", iSL="";
      sBase.delimitString(eachItemUsageDetails, "~").forEach((element) {
        if(eC==0){
          iName=element;
        }
        else if(eC==1){
          iQ=element;
        }
        else if(eC==2){
          iP=element;
        }
        else if(eC==3){
          iTotal=element;
        }
        else if(eC==4){
          iSL=element;
        }
        eC++;
      });
      setState(() {
        iS.add(getObjectWithItemStatus(iName, iQ, iP, iTotal, iSL));
      });
    });
  }
  UserRights getObjectWithUserRights(String uNumber, uRights) {
    return UserRights(uNumber, uRights);
  }
  ItemStatus getObjectWithItemStatus(String iName, iQ, iP, iTotal, iSL) {
    return ItemStatus(iName, iQ, iP, iTotal, iSL);
  }
  ItemUsage getObjectWithItemUsage(String iName, iQ, iP, iType, iSL, iUser, iDT, iInvoice,
      iC, iPictureName, iStatus, iKey) {
    return ItemUsage(iName, iQ, iP, iType, iSL, iUser, iDT, iInvoice, iC, iPictureName, iStatus, iKey);
  }
  OrderList getObjectWithItemOrder(String oID, iName, suppName, iQuantity, iUnit, iPrice, iTime, iStatus) {
    return OrderList(oID, iName, suppName, iQuantity, iUnit, iPrice, iTime, iStatus);
  }
  void updateNewLiveData(){
    database.ref('$companyCode/Database/LastUpdated').onValue.listen((event) {
      var sValue = event.snapshot.value;
      if(sValue!=null){
        String lastUpdatedDate = sValue.toString();
        if(checkDateLocalIsOld(lastUpdatedDate, false)){
          DateTime today = DateTime.now();
          String dateStr = "${today.year}-${today.month}-${today.day}-${today.hour}-${today.minute}-${today.second}";
          sBase.writeFilesRealtime(path, "LiveData", "DateUpdated", "Latest", dateStr, false);
          updateDynamicDataNodes();
        }
      }
    });
  }
  void updateUserRights(){
    database.ref('$companyCode/Database/UserRights').onValue.listen((event) {
      var sValue = event.snapshot.value;
      userRightsL.clear();
      if(sValue!=null){
        Map<dynamic, dynamic> mapUserData = sValue as Map;
        mapUserData.forEach((keyOData, valueOData){
          if(keyOData==phoneNumber){
            setState(() {
              userRights = valueOData.toString();
              if(userRights.contains("order") || userRights.contains("Order")){
                showDList="Order";
              }
              else if(userRights.contains("delivery") || userRights.contains("Delivery")){
                showDList="Delivery";
              }
              else if(userRights==("Admin")){
                showDList="Order";
              }
            });
            sBase.writeFilesRealtime(path, "UserRights", "RestrictedAccess", companyCode, valueOData.toString(), false);
          }
          else{
            setState(() {
              userRightsL.add(getObjectWithUserRights(keyOData, valueOData));
            });
          }
        });
      }
    });
  }
  void updateNewLiveDataItem(){
    database.ref('$companyCode/Database/LastUpdatedItem').onValue.listen((event) {
      var sValue = event.snapshot.value;
      if(sValue!=null){
        String lastUpdatedDate = sValue.toString();
        if(checkDateLocalIsOld(lastUpdatedDate, true)){
          DateTime today = DateTime.now();
          String dateStr = "${today.year}-${today.month}-${today.day}-${today.hour}-${today.minute}-${today.second}";
          sBase.writeFilesRealtime(path, "LiveData", "DateUpdatedItem", "Latest", dateStr, false);
          updateNewItemWiseLiveData();
          loadLiveItemStatus();
        }
      }
    });
  }
  void updateOrderListLive(){
    database.ref('$companyCode/Database/OrderIDS').onValue.listen((event) {
      var sValue = event.snapshot.value;
      sBase.deleteDirectory(path, "LiveEachOrder", "Database");
      if(sValue!=null){
        Map<dynamic, dynamic> mapUserData = sValue as Map;
        mapUserData.forEach((keyOData, valueOData){
          sBase.writeFilesRealtime(path, "LiveEachOrder", "Database", keyOData, valueOData, false);
        });
      }
    });
  }
  void updateNewItemWiseLiveData(){
    database.ref('$companyCode/Database/DateWiseEntries').once().then((dValue)async{
      var sValue = dValue.snapshot.value;
      sBase.deleteDirectory(path, "LiveEachItem", "Database");
      if(sValue!=null){
        Map<dynamic, dynamic> mapUserData = sValue as Map;
        mapUserData.forEach((keyOData, valueOData){
          Map<dynamic, dynamic> eachItem = valueOData as Map;
          eachItem.forEach((eachItemRandom, itemData){
            sBase.writeFilesRealtime(path, "LiveEachItem", "Database", eachItemRandom, itemData, false);
          });
        });
        loadItemUsageList();
      }
    }, onError: (error) {
    });
  }
  void updateDynamicDataNodes(){
    database.ref('$companyCode/Database/DynamicAddOn').once().then((dValue)async{
      var sValue = dValue.snapshot.value;
      if(sValue!=null){
        Map<dynamic, dynamic> mapUserData = sValue as Map;
        mapUserData.forEach((keyOData, valueOData){
          if(keyOData=="ItemName"){
            Map<dynamic, dynamic> mapUserItemName = valueOData as Map;
            mapUserItemName.forEach((itemKey, itemValue){
              sBase.writeFilesRealtime(path, "Data", "ItemName", itemKey, itemValue, false);
              loadItemNames();
            });
          }
          if(keyOData=="CompanyName"){
            Map<dynamic, dynamic> mapUserItemName = valueOData as Map;
            mapUserItemName.forEach((itemKey, itemValue){
              sBase.writeFilesRealtime(path, "Data", "CompanyName", itemKey, itemValue, false);
              loadCompanyNames();
            });
          }
          if(keyOData=="Units"){
            Map<dynamic, dynamic> mapUserUnitName = valueOData as Map;
            mapUserUnitName.forEach((unitKey, unitValue){
              sBase.writeFilesRealtime(path, "Data", "UnitName", unitKey, unitValue, false);
              loadUnitNames();
            });
          }
          if(keyOData=="SiteName"){
            Map<dynamic, dynamic> mapUserSiteName = valueOData as Map;
            mapUserSiteName.forEach((siteKey, siteValue){
              sBase.writeFilesRealtime(path, "Data", "SiteName", siteKey, siteValue, false);
              loadSiteNames();
            });
          }
          if(keyOData=="LatestItemID"){
            sBase.writeFilesRealtime(path, "LiveData", "ItemID", "Latest", valueOData.toString(), false);
          }
          if(keyOData=="LatestSiteID"){
            sBase.writeFilesRealtime(path, "LiveData", "SiteID", "Latest", valueOData.toString(), false);
          }
          if(keyOData=="AuthCode"){
            sBase.writeFilesRealtime(path, "User", "Company", "AuthCode", valueOData.toString(), false);
          }
        });
      }
    },onError: (error) {
    });
  }
  void loadLiveItemStatus(){
    database.ref('$companyCode/Database/StockLive').once().then((dValue)async{
      var sValue = dValue.snapshot.value;
      sBase.deleteDirectory(path, "LiveStock", "Database");
      if(sValue!=null){
        Map<dynamic, dynamic> mapUserData = sValue as Map;
        mapUserData.forEach((keyOData, valueOData){
           sBase.writeFilesRealtime(path, "LiveStock", "Database", keyOData, valueOData, false);
        });
        loadItemStatusList();
      }
    }, onError: (error) {
        });
  }
  bool checkDateLocalIsOld(String dateToCheck, bool isItem){
    String getLocalDateLatest = isItem?sBase.getFirstLineSync(path, "LiveData", "DateUpdatedItem", "Latest"):
    sBase.getFirstLineSync(path, "LiveData", "DateUpdated", "Latest");
    late Duration duration;
    if(getLocalDateLatest.isNotEmpty && getLocalDateLatest!="#"){
      DateTime localDate = getInitialisedLocalDate(getLocalDateLatest);
      DateTime toCheckDate = getInitialisedLocalDate(dateToCheck);
      duration = toCheckDate.difference(localDate);
    }
    if((getLocalDateLatest.isEmpty || getLocalDateLatest=="#") || duration.inSeconds>0){
      return true;
    }
    else{
      return false;
    }
  }
  DateTime getInitialisedLocalDate(String dateL){
    dateL = "$dateL-";
    int count=0;
    String yy="", mm="", dd="", hh="", min="", sec="";
    sBase.delimitString(dateL, "-").forEach((element) {
      if(count==0){
        yy=element;
      }
      else if(count==1){
        mm=element;
      }
      else if(count==2){
        dd=element;
      }
      else if(count==3){
        hh=element;
      }
      else if(count==4){
        min=element;
      }
      else if(count==5){
        sec=element;
      }
      count++;
    });
    return DateTime(int.parse(yy), int.parse(mm), int.parse(dd), int.parse(hh), int.parse(min), int.parse(sec));
  }
  void pickDynamicInput(BuildContext context, List<String> nList,
      List<String> newFilteredList, String dynamicTitle) {
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
                                    newFilteredList = nList
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
                                  hintText: 'Search $dynamicTitle',
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
                                  itemCount: newFilteredList.isEmpty?nList.length:newFilteredList.length,
                                  itemBuilder: (_, index) {
                                    String fItem="", itemName="", itemNumber="";
                                    if(newFilteredList.isEmpty){
                                      newFilteredList = nList;
                                    }
                                    fItem = newFilteredList[index];
                                    itemNumber = fItem.substring(0, fItem.indexOf("-"));
                                    itemName = (fItem.substring(fItem.indexOf("-")+1)).toLowerCase();
                                    return GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: (){
                                        if(Navigator.canPop(context)){
                                          Navigator.pop(context);
                                        }
                                        setState(() {
                                          if(dynamicTitle.contains("Item")){
                                            selectedItem = "$itemNumber-$itemName";
                                          }
                                          else if(dynamicTitle.contains("Site")){
                                            selectedSite="$itemNumber-$itemName";
                                          }
                                          else if(dynamicTitle.contains("Company")){
                                            selectedCompany="$itemNumber-$itemName";
                                          }
                                          else{
                                            selectedUnit="$itemNumber-$itemName";
                                          }
                                          isSearchTyped=false;
                                          phoneNumberController.clear();
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                                child: Text(itemNumber, style: userSignOnOccupationTitleGreySL,),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 7,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                    child: Text(itemName, style: userSignOnOccupationTitleGreySL,),
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
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
  void loadInBackground()async{
    companyCode = sBase.getFirstLineSync(path, "User", "Company", "Code");
    //await appCheck.setTokenAutoRefreshEnabled(true);
    if(companyCode!="#"){
      setState(() {
        phoneNumber = sBase.getFirstLineSync(path, "User", "Details", "PhoneNumber");
        userRights = sBase.getFirstLineSync(path, "UserRights", "RestrictedAccess", companyCode);
      });
      if(userRights.contains("order") || userRights.contains("Order")){
        setState(() {
          showDList="Order";
        });
      }
      else if(userRights.contains("delivery") || userRights.contains("Delivery")){
        setState(() {
          showDList="Delivery";
        });
      }
      else if(userRights==("Admin")){
        setState(() {
          companyA = "Auth: ${sBase.getFirstLineSync(path, "User", "Company", "AuthCode")}";
          showDList="Order";
        });
      }
      loadItemNames();
      loadUnitNames();
      loadSiteNames();
      loadCompanyNames();
      loadItemUsageList();
      loadItemOrderList();
      loadItemStatusList();
      updateNewLiveData();
      updateNewLiveDataItem();
      updateOrderListLive();
      updateNewItemWiseLiveData();
      updateUserRights();
    }
  }
  void newDynamicNodeInput(String dNode){
    String siteOrItemName="", dateStr="";
    if(newUserController.text.isNotEmpty){
      siteOrItemName = newUserController.text.toString();
      String latestSiteItemCompanyID = sBase.getFirstLineSync(path, "LiveData", "${dNode}ID", "Latest");
      if(latestSiteItemCompanyID=="#"){
        if(dNode.contains("Site")){
          latestSiteItemCompanyID="S1";
        }
        else if(dNode.contains("Item")){
          latestSiteItemCompanyID="I1";
        }
        else if(dNode.contains("Company")){
          latestSiteItemCompanyID="C1";
        }
      }
      String nodeInitial = "";
      if(dNode=="Site"){
        nodeInitial="S";
      }
      else if(dNode=="Item"){
        nodeInitial="I";
      }
      else if(dNode=="Company"){
        nodeInitial="C";
      }
      database.ref('$companyCode/Database/DynamicAddOn/${dNode}Name/$latestSiteItemCompanyID').set(siteOrItemName);
      int newIDToBeUpdated = int.parse(latestSiteItemCompanyID.substring(1).toString());
      newIDToBeUpdated++;
      database.ref('$companyCode/Database/DynamicAddOn/Latest${dNode}ID').set("$nodeInitial$newIDToBeUpdated");
      sBase.writeFilesRealtime(path, "LiveData", "${dNode}ID", "Latest", "$nodeInitial$newIDToBeUpdated", false);
      DateTime today = DateTime.now();
      dateStr = "${today.year}-${today.month}-${today.day}-${today.hour}-${today.minute}-${today.second}";
      Future.delayed(const Duration(seconds: 1)).then((value) {
        database.ref("$companyCode/Database/LastUpdated").set(dateStr);
      });
      newUserController.clear();
      Navigator.pop(context);
    }
  }
  void onNewClickDyn(String dType){
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(35.0))),
        backgroundColor: darkBlue,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal:18 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 16,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(dType, style: userSignOnOccupationTitleGreySLWN),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () async {
                        newDynamicNodeInput(dType);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            10, 0, 0, 0),
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            color: darkGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 22.0,
                                      semanticLabel: 'Friends',
                                    ),
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
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xffffffff),
                          Color(0xffffffff),
                        ],
                      )
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: TextField(
                        style: settingsHeadingTitlesS,
                        decoration: InputDecoration(
                          hintText: 'Please Enter New Input',
                          hintStyle: settingsHeadingTitlesS,
                        ),
                        controller: newUserController,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        )
    );
  }
  String replaceInitialisation(var tV){
    if(tV=='#'){
      return '';
    }
    else{
      return tV;
    }
  }
  String getDatabaseFilteredSt(String originalSt){
    String sTRet="";
    for(int i=0; i<originalSt.length; i++){
      var c = originalSt[i];
      if(c!="." && c!="\$" && c!="#" && c!="," && c!="[" && c!="]" && c!="/" && c!=":"){
        sTRet+=c.toString();
      }
    }
    return sTRet;
  }
  String getDatabaseFilteredTimeStamp(){
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-ddHH-mm-ss');
    return formatter.format(now);
  }
  int getWeekNumber(DateTime date){
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }
  void showCustomDialogLogOut(String headerMessage, String buttonMessage, String subTitle){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(1, (index) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateC) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: darkBlue,
                          spreadRadius: 10,
                          blurRadius: 13,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async{
                        if(headerMessage.contains('Delete')){
                          executeDeleteAccount();
                        }
                        else{
                          executeLogOut();
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(headerMessage, style: userSignOnOccupationTitle, textAlign: TextAlign.center,),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text(subTitle, style: headingTextTitlesG, textAlign: TextAlign.center,),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Container(
                                      height: 50,
                                      width: 220,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.topRight,
                                            colors: [
                                              darkBlue,
                                              darkBlue,
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
                                                  Icons.logout_rounded,
                                                  color: Colors.white,
                                                  size: 22.0,
                                                  semanticLabel: 'Friends',
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Text(buttonMessage, style: headingTextTitlesW),
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
            ),
          ),
        );
      },
    );
  }
  void executeLogOut(){
    deleteAllFiles();
    transferToVerification();
  }
  void executeDeleteAccount(){
    transferToVerification();
  }
  String getRandomNumber(){
    var rndNumber="";
    var rnd= Random();
    for (var i = 0; i < 6; i++) {
      rndNumber = rndNumber + rnd.nextInt(9).toString();
    }
    return rndNumber;
  }
  void selectImage(String imageCategory, String tYear, String tMonth, String tDay){
    pickImageFromGallery(imageCategory, tYear, tMonth, tDay);
  }
  Future<firebase_storage.UploadTask> uploadProfilePicture(File file, String imageCategory, String tYear,
      String tMonth, String tDay)async {
    firebase_storage.UploadTask uploadTask;
    String contentType="", pictureType="";
    if(file.path.contains("jpg")) {
      contentType = "image/jpeg";
      pictureType = "jpg";
    }
    else if(file.path.contains("jpeg")){
      contentType = "image/jpeg";
      pictureType = "jpeg";
    }
    else if(file.path.contains("png")) {
      contentType = "image/png";
      pictureType = "png";
    }
    else if(file.path.contains("gif")) {
      contentType = "image/gif";
      pictureType = "gif";
    }
    else if(file.path.contains("webp")) {
      contentType = "image/webp";
      pictureType = "webp";
    }
    else if(file.path.contains("bmp")) {
      contentType = "image/bmp";
      pictureType = "bmp";
    }
    selectedFileType=pictureType;
    userPictureName = "$tYear-$tMonth-$tDay-$imageCategory.$pictureType";
    try{
      Directory dirA = Directory('$path/DownloadedUserPicturesLocal');
      dirA.createSync();
      final tDir = dirA.path;
      if(!File('$tDir/$userPictureName').existsSync()) {
        File('$tDir/$userPictureName').createSync();
      }
      await file.copy('$tDir/$userPictureName');
    }catch(exception){}
    firebase_storage.Reference ref = firebase_storage
        .FirebaseStorage.instanceFor(app: defaultApp, bucket: "gs://buildtrackr-app.appspot.com").ref('UserPictures/$tYear/$tMonth/$tDay/$imageCategory/$userPictureName');
    final metadata = firebase_storage.SettableMetadata(contentType: contentType, customMetadata: {'picked-file-path': file.path});
    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(file, metadata);
    }
    return Future.value(uploadTask);
  }
  void pickImageFromGallery(String imageCategory, String tYear, String tMonth, String tDay)async{
    checkDeletePhotoDuplicate=0;
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
      maxHeight: 720,
    );
    if(pickedFile!=null){
      await uploadProfilePicture(File(pickedFile.path), imageCategory, tYear, tMonth, tDay).then((value)async{
        Future.delayed(const Duration(seconds: 2)).then((value) {
          setState((){

          });
        });
      });
    }
  }
  void showItemDeleteOption(String iKey, iName, iSL, iType, iQ, iP){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(1, (index) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateC) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: darkBlue,
                          spreadRadius: 10,
                          blurRadius: 13,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async{
                        String itemID = iName.substring(0, iName.indexOf("-"));
                        String siteID = iSL.substring(0, iSL.indexOf("-"));
                        updateLiveItemStatusDirectly(iName, iSL, itemID, siteID, iType, iQ, iP, true);
                        database.ref('$companyCode/Database/DateWiseEntries/$itemID/$iKey').remove();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(snackBarA);
                        updateLastTimeServer();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Delete Item", style: userSignOnOccupationTitle, textAlign: TextAlign.center,),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text("Items once deleted cannot be recovered", style: headingTextTitlesG, textAlign: TextAlign.center,),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Container(
                                      height: 50,
                                      width: 220,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.topRight,
                                            colors: [
                                              darkBlue,
                                              darkBlue,
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
                                                  Icons.remove_circle,
                                                  color: Colors.white,
                                                  size: 22.0,
                                                  semanticLabel: 'Friends',
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Text("Delete", style: headingTextTitlesW),
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
            ),
          ),
        );
      },
    );
  }
  void showOrderDeleteOption(String orderI){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(1, (index) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateC) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: darkBlue,
                          spreadRadius: 10,
                          blurRadius: 13,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async{
                        database.ref('$companyCode/Database/OrderIDS/${getDatabaseCorrectedName(orderI)}').remove();
                        updateLastTimeServer();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(snackBarA);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Delete Order", style: userSignOnOccupationTitle, textAlign: TextAlign.center,),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text("Items once deleted cannot be recovered", style: headingTextTitlesG, textAlign: TextAlign.center,),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Container(
                                      height: 50,
                                      width: 220,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.topRight,
                                            colors: [
                                              darkBlue,
                                              darkBlue,
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
                                                  Icons.remove_circle,
                                                  color: Colors.white,
                                                  size: 22.0,
                                                  semanticLabel: 'Friends',
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Text("Delete", style: headingTextTitlesW),
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
            ),
          ),
        );
      },
    );
  }
  Future<void> downloadProfilePicture(String fileStorageFBasePath, String fileFinalName)async{
    if(fileFinalName!="."){
      String downloadPathNode='DownloadedUserPictures';
      String cBucket = sBase.getFirstLineSync(path, "User", "Bucket", "Current");
      if(cBucket=='#'){
        cBucket='gs://buildtrackr-app.appspot.com';
      }
      final ref = FirebaseStorage.instanceFor(app: defaultApp,
          bucket: cBucket).ref('UserPictures/$fileStorageFBasePath/$fileFinalName');
      try {
        bool isEmptyP = true;
        Directory dir = Directory('$path/$downloadPathNode');
        dir.createSync(recursive: true);
        final tDir = dir.path;
        if(!File('$tDir/$fileFinalName').existsSync()) {
          File('$tDir/$fileFinalName').createSync();
        }
        final file = File('$tDir/$fileFinalName');
        if(file.existsSync()){
          isEmptyP=false;
          final downloadTask = ref.writeToFile(file);
          downloadTask.snapshotEvents.listen((taskSnapshot) {
            switch (taskSnapshot.state) {
              case TaskState.running:
                sBase.writeFilesRealtime(path, 'UserPicture','Success', fileFinalName, 'Downloaded', false);
                break;
              case TaskState.paused:
                break;
              case TaskState.success:
                sBase.writeFilesRealtime(path, 'UserPicture','Success', fileFinalName, 'Downloaded', false);
                try{
                  setState((){
                  });
                }catch(exception){}
                break;
              case TaskState.canceled:
                break;
              case TaskState.error:
                break;
            }
          });
        }
        if(isEmptyP){
          sBase.writeFilesRealtime(path, 'UserPicture', 'Success', fileFinalName, 'Failed', false);
        }
      } on FirebaseException catch (e) {
        sBase.writeFilesRealtime(path, 'UserPicture', 'Success', fileFinalName, 'Failed', false);
      }
    }

  }
  Widget showItemUsageList(double screenHeight, double screenWidth, List<ItemUsage> gI){
    return MediaQuery.removePadding(
      context: context,
      removeTop: true, removeLeft: true,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, position) {
          String iName = gI[position].iName;
          String iQ = gI[position].iQ;
          String iP = gI[position].iP;
          String iType = gI[position].iType;
          String iSL = gI[position].iSL;
          String iUser = gI[position].iUser;
          String iDT = gI[position].iDT;
          String iInvoice = gI[position].iInvoice;
          String iC = gI[position].iC;
          String iStatus = gI[position].iStatus;
          String imageURL = gI[position].iPictureName;
          String iKey=gI[position].iKey;
          bool doesPictureExist= File('$path/DownloadedUserPictures/$imageURL').existsSync() &&
              File('$path/DownloadedUserPictures/$imageURL').readAsBytesSync().isNotEmpty;
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: OutlinedButton(
              style: outlineButtonStyleB,
              onLongPress: (){
                if(userRights=="Admin"){
                  showItemDeleteOption(iKey, iName, iSL, iType, iQ, iP);
                }
              },
              onPressed: () {  },
              child: SizedBox(
                height: screenHeight/3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Text("Item : $iName"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Quantity : $iQ"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Price : $iP"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Type : $iType"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Site : $iSL"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("User : $iUser"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("TimeStamp : $iDT"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Invoice : $iInvoice"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Challan : $iC"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            String imageURLLocal = gI[position].iPictureName;
                            bool doesPictureExistL= File('$path/DownloadedUserPictures/$imageURLLocal').existsSync() &&
                                File('$path/DownloadedUserPictures/$imageURLLocal').readAsBytesSync().isNotEmpty;
                            imageFound = doesPictureExistL;
                            iF=File('$path/DownloadedUserPictures/$imageURLLocal');
                            HomePage.activeScreen="IView";
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (imageURL=='#' || !doesPictureExist)?
                              Image.asset(
                                "assets/graphics/placeholder.png",
                                width: screenWidth/3.5,
                                fit: BoxFit.fitWidth,
                              ):
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.file(
                                    File('$path/DownloadedUserPictures/$imageURL'),
                                    width: screenHeight/3,
                                    fit: BoxFit.cover,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: gI.length,
      ),
    );
  }
  Widget showItemOrderList(double screenHeight, double screenWidth, List<OrderList> gI){
    return MediaQuery.removePadding(
      context: context,
      removeTop: true, removeLeft: true,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, position) {
          String iName = gI[position].iName;
          String iQ = gI[position].iQuantity;
          String iP = gI[position].iPrice;
          String oID = gI[position].oID;
          String iUnit = gI[position].iUnit;
          String suppName = gI[position].suppName;
          String iTime = gI[position].iTime;
          String iStatus = gI[position].iStatus;

          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: OutlinedButton(
              style: outlineButtonStyleB,
              onLongPress: (){
                if(userRights=="Admin"){
                  showOrderDeleteOption(iQ);
                }
              },
              onPressed: () {  },
              child: SizedBox(
                height: screenHeight/3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Text("Item : $iName"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Quantity : $iQ"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Price : $iP"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Unit : $iUnit"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Order ID : $oID"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Supplied NameID : $suppName"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("OrderTimeStamp : $iTime"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Status : $iStatus"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: gI.length,
      ),
    );
  }
  Widget showUserRightsList(double screenHeight, double screenWidth, List<UserRights> gI){
    return MediaQuery.removePadding(
      context: context,
      removeTop: true, removeLeft: true,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, position) {
          String uNumber = gI[position].uNumber;
          String uRights = gI[position].uRights;
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: OutlinedButton(
              style: outlineButtonStyleB,
              onLongPress: (){

              },
              onPressed: () {  },
              child: SizedBox(
                height: screenHeight/3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Text("UserNumber : $uNumber"),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: DropdownButton(
                          hint: _dropDownValue.isEmpty
                              ? Text(uRights, style: headingTextTitlesGSR,)
                              : Text(
                            _dropDownValue,
                            style: headingTextTitlesGSR,
                          ),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: headingTextTitlesGSR,
                          items: ['Admin', 'Order', 'Delivery'].map(
                                (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(
                                  () {
                                  _dropDownValue = val.toString();
                                  database.ref('$companyCode/Database/UserRights/$uNumber').set(_dropDownValue);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: gI.length,
      ),
    );
  }
  Widget showItemStatusList(double screenHeight, double screenWidth, List<ItemStatus> gI){
    return MediaQuery.removePadding(
      context: context,
      removeTop: true, removeLeft: true,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, position) {
          String iName = gI[position].iName;
          String iTotal = gI[position].iTotal;
          String iQ = gI[position].iQ;
          String iP = gI[position].iP;
          String iSL = gI[position].iSL;
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: OutlinedButton(
              style: outlineButtonStyleB,
              onPressed: () {
              },
              child: SizedBox(
                height: screenHeight/5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Text("Item : $iName"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Quantity : $iQ"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Price : $iP"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Site : $iSL"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Text("Total : $iTotal"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: gI.length,
      ),
    );
  }
  void deleteAllFiles() {
    sBase.deleteFullDirectory(path, "Data");
    sBase.deleteFullDirectory(path, "LiveEachItem");
    sBase.deleteFullDirectory(path, "UserPicture");
    sBase.deleteFullDirectory(path, "LiveStock");
    sBase.deleteFullDirectory(path, "LiveData");
  }
  void setupRegistration(String realCompanyName, String companyDatabaseID){
    sBase.writeFilesRealtime(path, "User", "Company", "Code", companyDatabaseID, false);
    sBase.writeFilesRealtime(path, "User", "Company", "Verification", "Successful", false);
    database.ref('$companyDatabaseID/Database/DynamicAddOn/Units/UnitA').set("Kg");
    database.ref('$companyDatabaseID/Database/DynamicAddOn/Units/UnitB').set("Nos");
    database.ref('$companyDatabaseID/Database/DynamicAddOn/Units/UnitC').set("Ton");
    database.ref('$companyDatabaseID/Database/DynamicAddOn/Units/UnitC').set("Quintal");
    DateTime today = DateTime.now();
    String dateStr = "${today.year}-${today.month}-${today.day}-${today.hour}-${today.minute}-${today.second}";
    database.ref('$companyDatabaseID/Database/LastUpdated').set(dateStr);
    deleteAllFiles();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      RestartWidget.restartApp(context);
    });
  }
  String generateSixR(){
    var rndNumber="";
    var rnd= Random();
    for (var i = 0; i < 6; i++) {
      rndNumber = rndNumber + rnd.nextInt(9).toString();
    }
    return rndNumber;
  }
  String getPlainCorrectedName(String newName){
    String rN="";
    int lC=0;
    for(int i=0; i<newName.length; i++){
      final validCharacters = RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$');
      if(validCharacters.hasMatch(newName[i]) && lC<3){
        rN+=newName[i];
      }
      lC++;
    }
    String uniqueT = DateTime.now().millisecondsSinceEpoch.toString();
    String toR = rN+uniqueT;
    return toR;
  }
  String getDatabaseCorrectedName(String newName){
    String rN="";
    for(int i=0; i<newName.length; i++){
      final validCharacters = RegExp(r'^[a-zA-Z0-9]');
      if(validCharacters.hasMatch(newName[i])){
        rN+=newName[i];
      }
    }
    return rN;
  }
  void getNewCompanyName(){
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(35.0))),
        backgroundColor: darkBlue,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal:18 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 16,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text("New Company", style: userSignOnOccupationTitleGreySLWN),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () async {
                        String newCompanyName="";
                        if(newUserController.text.isNotEmpty && newUserController.text.length>3){
                          newCompanyName = newUserController.text.toString();
                          String aC = generateSixR();
                          String correctedName = getPlainCorrectedName(newCompanyName);
                          sBase.writeFilesRealtime(path, "User", "Company", "AuthCode", aC, false);
                          companyA=aC;
                          database.ref('AuthCode/$aC').set(correctedName);
                          database.ref('UI/$correctedName').set(newCompanyName);
                          String lPN = sBase.getFirstLineSync(path, "User", "Details", "PhoneNumber");
                          database.ref('$correctedName/Database/UserRights/$lPN').set("Admin");
                          database.ref('$correctedName/Database/DynamicAddOn/AuthCode').set(aC);
                          setupRegistration(newCompanyName, correctedName);
                          setState(() {});
                          newUserController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            10, 0, 0, 0),
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            color: darkGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 22.0,
                                      semanticLabel: 'Friends',
                                    ),
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
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xffffffff),
                          Color(0xffffffff),
                        ],
                      )
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: TextField(
                        style: settingsHeadingTitlesS,
                        decoration: InputDecoration(
                          hintText: 'Please Enter New Input',
                          hintStyle: settingsHeadingTitlesS,
                        ),
                        controller: newUserController,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        )
    );
  }
  Widget createDisplayDynamicSelect(BuildContext context, IconData iD, String newDataInputCategoryType,
      List<String> oList, List<String> fList, String dynamicInputTitle, String selectedIT,
      String selectedITEmptyValue, TextStyle selectedITTextStyle, TextStyle selectedITTextStyleEmpty,
      double left, double top, double right, double bottom){
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: Container(
          height: 55,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40.0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    setState(() {

                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          iD,
                          color: darkRed,
                          size: 23,
                          semanticLabel: 'Home',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 28,
                child: Padding(
                    padding: const EdgeInsets.only(left: 0, right: 25, top: 3),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        pickDynamicInput(context, oList, fList, dynamicInputTitle);
                      },
                      child: Text(selectedIT, style: selectedIT.contains(selectedITEmptyValue)?selectedITTextStyle:selectedITTextStyleEmpty,),
                    )
                ),
              ),
              Expanded(
                flex: 8,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    onNewClickDyn(newDataInputCategoryType);
                  },
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_rounded,
                          color: darkRed,
                          size: 25,
                          semanticLabel: 'Home',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
  Widget createOnlyDisplayDynamicSelect(BuildContext context, List<String> oList, List<String> fList,
      String dynamicInputTitle, String selectedIT,
      String selectedITEmptyValue, TextStyle selectedITTextStyle, TextStyle selectedITTextStyleEmpty,
      double left, double top, double right, double bottom){
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: Container(
          height: 55,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40.0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 25, top: 3),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        pickDynamicInput(context, oList, fList, dynamicInputTitle);
                      },
                      child: Text(selectedIT, style: selectedIT.contains(selectedITEmptyValue)?selectedITTextStyle:selectedITTextStyleEmpty,),
                    )
                ),
              ),
            ],
          )
      ),
    );
  }
  Widget createDynamicTextField(TextInputType inpT, String hText, TextEditingController localControllerT){
    return Container(
      height: 55,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(40.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 25, top: 3),
        child: TextField(
          style: userRegistrationTitleUDB,
          textAlign: TextAlign.start,
          cursorColor: darkBlue,
          keyboardType: inpT,
          onChanged: (text) {
          },
          autocorrect: false,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
            hintText: hText,
            filled: true,
            fillColor: Colors.white,
            hintStyle: userSignOnTextField,
            border: InputBorder.none,
          ),
          controller: localControllerT,
        ),
      ),
    );
  }
  void displaySelection(){
    //selectedUpdate
    //scaffoldKey.currentState!.openEndDrawer();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(1, (index) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateC) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: darkBlue,
                          spreadRadius: 10,
                          blurRadius: 13,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Select Option", style: userSignOnOccupationTitle, textAlign: TextAlign.center,),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text("Selective Access", style: headingTextTitlesG, textAlign: TextAlign.center,),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    setState(() {
                                      selectedUpdate="Order";
                                    });
                                    Navigator.pop(context);
                                    scaffoldKey.currentState!.openEndDrawer();
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
                                              darkBlue,
                                              darkBlue,
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
                                                  Icons.offline_bolt_rounded,
                                                  color: Colors.white,
                                                  size: 22.0,
                                                  semanticLabel: 'Friends',
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Text("Update Order", style: headingTextTitlesW),
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    Navigator.pop(context);
                                    displayDeliverySelection();
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
                                              darkBlue,
                                              darkBlue,
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
                                                  Icons.fire_truck_outlined,
                                                  color: Colors.white,
                                                  size: 22.0,
                                                  semanticLabel: 'Friends',
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Text("Update Delivery", style: headingTextTitlesW),
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
            ),
          ),
        );
      },
    );
  }
  void displayDeliverySelection(){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(1, (index) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateC) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: darkBlue,
                          spreadRadius: 10,
                          blurRadius: 13,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Credit/Debit", style: userSignOnOccupationTitle, textAlign: TextAlign.center,),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: (){
                                      Navigator.pop(context);
                                      setState(() {
                                        selectedUpdate="Delivery";
                                        deliverySelection="DeliveryCredit";
                                      });
                                      scaffoldKey.currentState!.openEndDrawer();
                                    },
                                    child: Container(
                                      width: 170,
                                      height: 48,
                                      decoration: const BoxDecoration(
                                        color: darkGreen,
                                        borderRadius: BorderRadius.all(Radius.circular(40.0),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 18,
                                            child: GestureDetector(
                                              child: const Padding(
                                                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add_circle_rounded,
                                                      color: Colors.white,
                                                      size: 23,
                                                      semanticLabel: 'Home',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 36,
                                            child: Padding(
                                                padding: const EdgeInsets.only(left: 0, right: 25, top: 3),
                                                child: GestureDetector(
                                                  child: Text("Credit", style: userSignOnTextFieldW,),
                                                )
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: (){
                                      Navigator.pop(context);
                                      setState(() {
                                        selectedUpdate="Delivery";
                                        deliverySelection="DeliveryDebit";
                                      });
                                      scaffoldKey.currentState!.openEndDrawer();
                                    },
                                    child: Container(
                                      width: 170,
                                      height: 48,
                                      decoration: const BoxDecoration(
                                        color: darkRed,
                                        borderRadius: BorderRadius.all(Radius.circular(40.0),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 18,
                                            child: GestureDetector(
                                              child: const Padding(
                                                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.white,
                                                      size: 23,
                                                      semanticLabel: 'Home',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 36,
                                            child: Padding(
                                                padding: const EdgeInsets.only(left: 0, right: 25, top: 3),
                                                child: GestureDetector(
                                                  child: Text("Debit", style: userSignOnTextFieldW,),
                                                )
                                            ),
                                          ),
                                        ],
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
                  );
                })
            ),
          ),
        );
      },
    );
  }
  bool checkOrderInput(){
    if(orderID.text=="" || selectedItem=="Select Item" ||
        quantityController.text=="" ||  priceController.text==""
        || selectedUnit=="Unit" || selectedCompany=="Select Company"){
      return false;
    }
    else{
      return true;
    }
  }
  bool checkCreditInput(){
    if(challanController.text=="" || selectedItem=="Select Item" || selectedSite=="Site Location" || selectedSite=="Select Company" ||
        quantityController.text=="" ||  selectedUnit=="Unit" || userPictureName==""){
      return false;
    }
    else{
      return true;
    }
  }
  bool checkDebitInput(){
    if(selectedUnit=="Unit" || selectedItem=="Select Item" ||
        quantityController.text=="" ||  selectedSite=="Site Location"){
      return false;
    }
    else{
      return true;
    }
  }
  void updateLiveItemStatusDirectly(String itemL, siteL, itemID, siteID, processStatus, iQ, String iP,bool isDelete){
    String itemSiteID = "$itemID-$siteID";
    String lD = sBase.getFirstLineSync(path, "LiveStock", "Database", itemSiteID);
    if(lD.isEmpty || lD=="#"){
      lD="$itemL~0~0~0~$siteL~";
    }
    int count=0, pQ=0, newPQ=0;
    sBase.delimitString(lD, "~").forEach((element) {
      if(count==1){
        pQ=int.parse(element);
      }
      count++;
    });
    if(processStatus=="Debit"){
      if(isDelete){
        newPQ = pQ + int.parse(iQ);
      }
      else{
        newPQ = pQ - int.parse(iQ);
      }
    }
    else{
      if(isDelete){
        newPQ = pQ - int.parse(iQ);
      }
      else{
        newPQ = pQ + int.parse(iQ);
      }
    }
    if(iP.isEmpty){
      iP="0";
    }
    double nP = double.parse(iP);
    String newI = "$itemL~$newPQ~$nP~${newPQ*nP}~$siteL~";
    database.ref('$companyCode/Database/StockLive/$itemSiteID').set(newI);
  }
  void updateOrderQuantityStatusIfReq(String sItem, String sCompany, String sQuantity){
    database.ref('$companyCode/Database/OrderQuantitySQ/${getDatabaseCorrectedName("$sItem¬$sCompany")}/Pending').once().
    then((dValue)async{
      var sValue = dValue.snapshot.value;
      if(sValue!=null){
        bool isDone=false; double leftO=double.parse(sQuantity); String eNode="";
        Map<dynamic, dynamic> mapUserData = sValue as Map;
        mapUserData.forEach((keyOData, valueOData){
          if(!isDone){
            try{
              double cQ = double.parse(valueOData);
              double qToD = double.parse(sQuantity);
              leftO = cQ-qToD;
              eNode=keyOData.toString();
              if(cQ-qToD>0){
                double lO=cQ-qToD;
                database.ref('$companyCode/Database/OrderQuantitySQ/${getDatabaseCorrectedName("$sItem¬$sCompany")}/Pending/$keyOData').set(lO.toString());
                isDone=true;
              }
              else if(cQ-qToD==0){
                database.ref('$companyCode/Database/OrderQuantitySQ/${getDatabaseCorrectedName("$sItem¬$sCompany")}/Pending/$keyOData').remove();
                database.ref('$companyCode/Database/OrderQuantitySQ/${getDatabaseCorrectedName("$sItem¬$sCompany")}/Completed/$keyOData').set("0");
                updateLiveOrderListComplete(keyOData);
                isDone=true;
              }
              else if(cQ-qToD<0){
                database.ref('$companyCode/Database/OrderQuantitySQ/${getDatabaseCorrectedName("$sItem¬$sCompany")}/Pending/$keyOData').remove();
                database.ref('$companyCode/Database/OrderQuantitySQ/${getDatabaseCorrectedName("$sItem¬$sCompany")}/Completed/$keyOData').set("0");
                updateLiveOrderListComplete(keyOData);
              }
            }catch(exception){}
          }
        });
        if(leftO<0){
          database.ref('$companyCode/Database/OrderQuantitySQ/${getDatabaseCorrectedName("$sItem¬$sCompany")}/Error/$eNode').set(leftO.toString());
        }
      }
    }, onError: (error) {
    });
  }
  void updateLiveOrderListComplete(String orderI){
    database.ref('$companyCode/Database/OrderIDS/$orderI').once().then((dValue)async{
      var sValue = dValue.snapshot.value;
      if(sValue!=null){
         String cV = sValue.toString();
         cV = cV.replaceAll("~Pending", "~Completed");
         database.ref('$companyCode/Database/OrderIDS/$orderI').set(cV);
      }
    },
        onError: (error) {
    });
  }
  void updateLastTimeServer(){
    DateTime today = DateTime.now();
    String dateStr = "${today.year}-${today.month}-${today.day}-${today.hour}-${today.minute}-${today.second}";
    Future.delayed(const Duration(seconds: 1)).then((value) {
      database.ref("$companyCode/Database/LastUpdatedItem").set(dateStr);
    });
  }
  void loadFS(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Please Wait", style: headingTextTitlesGSR),
        );
      },
    );
  }
  void processItemSubmission(String processStatus){
    loadFS();
    Future.delayed(const Duration(seconds: 5)).then((value) {
      Navigator.pop(context);
      String tS = DateTime.now().toString();
      String uniqueT = DateTime.now().millisecondsSinceEpoch.toString();
      String uP = userPictureName;
      if(uP.isEmpty){
        uP = "#";
      }
      String itemUpdate = "$selectedItem~${quantityController.text}~${priceController.text}~$processStatus~$selectedSite~$phoneNumber~$tS~${orderID.text}~${challanController.text}~$uP~Unauthorised~";
      String itemID = selectedItem.substring(0, selectedItem.indexOf("-"));
      String siteID = selectedSite.substring(0, selectedSite.indexOf("-"));
      updateLiveItemStatusDirectly(selectedItem, selectedSite, itemID, siteID, processStatus,
          quantityController.text.toString(), priceController.text.toString(), false);
      if(processStatus=="Credit"){
        updateOrderQuantityStatusIfReq(selectedItem, selectedCompany, quantityController.text.toString());
      }
      database.ref('$companyCode/Database/DateWiseEntries/$itemID/$uniqueT').set(itemUpdate);
      updateLastTimeServer();
      setState(() {
        selectedSite="Site Location";
        selectedItem="Select Item";
        selectedUnit="Unit";
        userPictureName="";
        quantityController.text="";
        challanController.text="";
        priceController.text="";
        orderID.text="";
      });
      Navigator.pop(context);
    });
  }
  void processOrderInput(){
    String orderIDL = orderID.text.toString();
    String quantityL = quantityController.text.toString();
    String priceL = priceController.text.toString();
    String tS = DateTime.now().toString();
    String orderContent="$orderIDL~$selectedItem~$quantityL~$priceL~$selectedUnit~$selectedCompany~$tS~Pending~";
    database.ref('$companyCode/Database/OrderQuantitySQ/${getDatabaseCorrectedName("$selectedItem¬$selectedCompany")}/Pending/${getDatabaseCorrectedName(orderIDL)}').set(quantityL);
    database.ref('$companyCode/Database/OrderIDS/${getDatabaseCorrectedName(orderIDL)}').set(orderContent);
    updateLastTimeServer();
    Navigator.pop(context);
  }
  void clearAllInputs(){
    setState(() {
      phoneNumberController.clear();
      newUserController.clear();
      quantityController.clear();
      priceController.clear();
      challanController.clear();
      phoneNumberControllerPhone.clear();
      phoneNumberControllerGroupPassword.clear();
      itemUsageListController.clear();
      itemStatusListController.clear();
      companyAuthCode.clear();
      orderID.clear();
      selectedItem="Select Item";
      selectedSite="Site Location";
      selectedUnit="Unit";
      selectedUpdate="None";
      deliverySelection="DeliveryDebit";
      selectedCompany="Select Company";
    });
  }
  void onMenuClick(){
    clearAllInputs();
    if(userRights=="Admin" || (userRights=="Order" && userRights=="Delivery")){
      displaySelection();
    }
    else{
      if(userRights.contains("Order")){
        setState(() {
          selectedUpdate="Order";
        });
      }
      else if(userRights.contains("Delivery")){
        setState(() {
          selectedUpdate="Delivery";
        });
      }
      scaffoldKey.currentState!.openEndDrawer();
    }
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    separatorWidth = screenWidth/6;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
        onWillPop: ()async {
      if (HomePage.activeScreen!="Home") {
        if(HomePage.activeScreen=="CBox"){
          if(keyboardFocus){
            setState((){
              keyboardFocus=false;
            });
          }
          else{
            setState((){
              HomePage.activeScreen="Home";
            });
          }
        }
        else{
          setState((){
            HomePage.activeScreen="Home";
          });
        }
        return false;
      }
      else{
        final result = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(1, (index) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setStateC) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: darkRed,
                              spreadRadius: 10,
                              blurRadius: 13,
                              offset: Offset(0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Exit BuildTrackr?", style: userSignOnOccupationTitle, textAlign: TextAlign.center,),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      child: Text("Pressing the back button twice prompts the exit option.", style: headingTextTitlesG, textAlign: TextAlign.center,),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                        SystemNavigator.pop();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Container(
                                          height: 50,
                                          width: 200,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  darkBlue,
                                                  darkBlue
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
                                                      Icons.exit_to_app_rounded,
                                                      color: Colors.white,
                                                      size: 22.0,
                                                      semanticLabel: 'Friends',
                                                    ),
                                                    const SizedBox(
                                                      width: 7,
                                                    ),
                                                    Text("Exit", style: headingTextTitlesW),
                                                  ],
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                ),
              ),
            );
          },
        );
        return result;
      }
    },
    child: SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: phoneBoxGrey,
        resizeToAvoidBottomInset: HomePage.activeScreen=="CBox"?true:false,
        drawerEdgeDragWidth: 0,
        floatingActionButton: HomePage.activeScreen!="Home"?
        FloatingActionButton(
          onPressed: ()async{
            setState(() {
              HomePage.activeScreen="Home";
            });
          },
          backgroundColor: darkRed,
          child: const Icon(Icons.keyboard_backspace_rounded),
        ):HomePage.activeScreen=="Home"?
        userRights.contains("Admin")?FloatingActionButton(
          onPressed: ()async{
            setState(() {
              HomePage.activeScreen="UserRights";
            });
          },
          backgroundColor: darkRed,
          child: const Icon(Icons.supervised_user_circle_rounded),
        ):const Text(""):const Text(""),
        endDrawer: selectedUpdate=="Order"?
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Opacity(
            opacity: 1.0,
            child: Container(
              width: (screenWidth/2)+(screenWidth/3),
              decoration: BoxDecoration(
                color: const Color(0xffF1F2F5),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0)
                ),
                boxShadow: [
                  BoxShadow(
                    color: lightOrange,
                    spreadRadius: 10,
                    blurRadius: 13,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                        child: Text("Add Order", style: phoneTitle,)
                    ),
                  ),
                  Expanded(
                    flex: 22,
                    child: ListView.builder(
                      controller: settingsControllerS,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        if(index==0){
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 15, 10),
                              child: createDynamicTextField(TextInputType.text, "Order ID", orderID),
                          );
                        }
                        else if(index==1){
                          return createDisplayDynamicSelect(context, Icons.drive_folder_upload_outlined,
                              "Item", itemList, filteredItemList, "Item Name", selectedItem, "Select",
                              userSignOnTextField, userSignOnTextFieldB, 15, 0, 15, 10);
                        }
                        else if(index==2){
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 15, 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: createDynamicTextField(TextInputType.number,
                                      "Quantity", quantityController),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: createDynamicTextField(TextInputType.number,
                                      "Price", priceController),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: createOnlyDisplayDynamicSelect(context, unitList, filteredUnitList, "Unit Name", selectedUnit, "Unit",
                                      userSignOnTextField, userSignOnTextFieldB, 10, 0, 0, 0),
                                ),
                              ],
                            ),
                          );
                        }
                        else if(index==3){
                          return createDisplayDynamicSelect(context, Icons.work,
                              "Company", companyList, filteredCompanyList, "Company Name", selectedCompany,
                              "Select", userSignOnTextField, userSignOnTextFieldB, 15, 0, 15, 10);
                        }
                        else if(index==4){
                          return Row(
                            children: [
                              const Expanded(
                                flex: 4,
                                child: Text(""),
                              ),
                              Expanded(
                                flex: 8,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 20, 0, 10),
                                  child: Container(
                                      width: 170,
                                      height: 48,
                                      decoration: const BoxDecoration(
                                        color: darkGreen,
                                        borderRadius: BorderRadius.all(Radius.circular(40.0),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 18,
                                            child: GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                              onTap: (){
                                                setState(() {

                                                });
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add_circle_rounded,
                                                      color: Colors.white,
                                                      size: 23,
                                                      semanticLabel: 'Home',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ),
                                          Expanded(
                                            flex: 36,
                                            child: Padding(
                                                padding: const EdgeInsets.only(left: 0, right: 25, top: 3),
                                                child: GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: (){
                                                    if(checkOrderInput()){
                                                      processOrderInput();
                                                    }
                                                    else{
                                                      setState((){
                                                        showError=true;
                                                      });
                                                    }
                                                  },
                                                  child: Text("New Order", style: userSignOnTextFieldW,),
                                                ),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                              const Expanded(
                                flex: 4,
                                child: Text(""),
                              ),
                            ],
                          );
                        }
                        else if(index==5){
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text(showError?"Error":"", style: fullyBookedFonts,)
                          );
                        }
                        else{
                          return const Text("");
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                        child: GestureDetector(
                          onTap: (){
                            showCustomDialogLogOut("Log Out?", "Log Out", "All your data will be stored locally until you delete your account");
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Container(
                              height: 63,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.logout_rounded,
                                      color: darkRed,
                                      size: 25.0,
                                      semanticLabel: 'Friends',
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Text("Log Out", style: headingTextTitles),
                                    ),
                                    const Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(""),
                                      ),
                                    ),
                                  ],
                                ),
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
        ):selectedUpdate=="Delivery"?deliverySelection=="DeliveryDebit"?
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Opacity(
            opacity: 1.0,
            child: Container(
              width: (screenWidth/2)+(screenWidth/3),
              decoration: BoxDecoration(
                color: const Color(0xffF1F2F5),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0)
                ),
                boxShadow: [
                  BoxShadow(
                    color: lightOrange,
                    spreadRadius: 10,
                    blurRadius: 13,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                        child: Text("Debit Item", style: phoneTitle,)
                    ),
                  ),
                  Expanded(
                    flex: 22,
                    child: ListView.builder(
                      controller: settingsControllerS,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        if(index==0){
                          return createDisplayDynamicSelect(context, Icons.drive_folder_upload_outlined,
                              "New Item", itemList, filteredItemList, "Item Name", selectedItem, "Select",
                              userSignOnTextField, userSignOnTextFieldB, 15, 0, 15, 10);
                        }
                        else if(index==1){
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 15, 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: createDynamicTextField(TextInputType.number,
                                      "Quantity", quantityController),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: createOnlyDisplayDynamicSelect(context, unitList, filteredUnitList, "Unit Name", selectedUnit, "Unit",
                                      userSignOnTextField, userSignOnTextFieldB, 10, 0, 0, 0),
                                ),
                              ],
                            ),
                          );
                        }
                        else if(index==2){
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: Container(
                                height: 55,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(40.0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: (){
                                          setState(() {

                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_location_alt,
                                                color: darkRed,
                                                size: 23,
                                                semanticLabel: 'Home',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ),
                                    Expanded(
                                      flex: 28,
                                      child: Padding(
                                          padding: const EdgeInsets.only(left: 0, right: 25, top: 3),
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: (){
                                              pickDynamicInput(context, siteLocationList, filteredSiteLocationList, "Site Location");
                                            },
                                            child: Text(selectedSite, style: selectedSite.contains("Location")?userSignOnTextField:userSignOnTextFieldB,),
                                          )
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: (){
                                          onNewClickDyn("Site");
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_circle_rounded,
                                                color: darkRed,
                                                size: 25,
                                                semanticLabel: 'Home',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ),
                                  ],
                                )
                            ),
                          );
                        }
                        else if(index==3){
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                            child: Container(
                                width: 200,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: darkRed,
                                  borderRadius: BorderRadius.all(Radius.circular(40.0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 18,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: (){
                                          setState(() {

                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.remove_circle,
                                                color: Colors.white,
                                                size: 23,
                                                semanticLabel: 'Home',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ),
                                    Expanded(
                                      flex: 36,
                                      child: Padding(
                                          padding: const EdgeInsets.only(left: 0, right: 25, top: 3),
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: (){
                                              if(checkDebitInput()){
                                                processItemSubmission("Debit");
                                              }
                                              else{
                                                setState((){
                                                  showError=true;
                                                });
                                              }
                                            },
                                            child: Text("Debit", style: userSignOnTextFieldW,),
                                          )
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          );
                        }
                        else if(index==4){
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text(showError?"Error":"", style: fullyBookedFonts,)
                          );
                        }
                        else{
                          return const Text("");
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: GestureDetector(
                        onTap: (){
                          showCustomDialogLogOut("Log Out?", "Log Out", "All your data will be stored locally until you delete your account");
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                          child: Container(
                            height: 63,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.logout_rounded,
                                    color: darkRed,
                                    size: 25.0,
                                    semanticLabel: 'Friends',
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Text("Log Out", style: headingTextTitles),
                                  ),
                                  const Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Text(""),
                                    ),
                                  ),
                                ],
                              ),
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
        ):deliverySelection=="DeliveryCredit"?Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Opacity(
            opacity: 1.0,
            child: Container(
              width: (screenWidth/2)+(screenWidth/3),
              decoration: BoxDecoration(
                color: const Color(0xffF1F2F5),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0)
                ),
                boxShadow: [
                  BoxShadow(
                    color: lightOrange,
                    spreadRadius: 10,
                    blurRadius: 13,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                        child: Text("Add Order", style: phoneTitle,)
                    ),
                  ),
                  Expanded(
                    flex: 22,
                    child: ListView.builder(
                      controller: settingsControllerS,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        if(index==0){
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 15, 10),
                              child: createDynamicTextField(TextInputType.text, "Challan ID", challanController),
                          );
                        }
                        else if(index==1){
                          return createDisplayDynamicSelect(context, Icons.drive_folder_upload_outlined,
                              "New Item", itemList, filteredItemList, "Item Name", selectedItem, "Select",
                              userSignOnTextField, userSignOnTextFieldB, 15, 0, 15, 10);
                        }
                        else if(index==2){
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 15, 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: createDynamicTextField(TextInputType.number,
                                      "Quantity", quantityController),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: createOnlyDisplayDynamicSelect(context, unitList, filteredUnitList, "Unit Name", selectedUnit, "Unit",
                                      userSignOnTextField, userSignOnTextFieldB, 10, 0, 0, 0),
                                ),
                              ],
                            ),
                          );
                        }
                        else if(index==3){
                          return createDisplayDynamicSelect(context, Icons.work,
                              "Company", companyList, filteredCompanyList, "Company Name", selectedCompany,
                              "Select", userSignOnTextField, userSignOnTextFieldB, 15, 0, 15, 10);
                        }
                        else if(index==4){
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: Container(
                                height: 55,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(40.0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: (){
                                          setState(() {

                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_location_alt,
                                                color: darkRed,
                                                size: 23,
                                                semanticLabel: 'Home',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ),
                                    Expanded(
                                      flex: 28,
                                      child: Padding(
                                          padding: const EdgeInsets.only(left: 0, right: 25, top: 3),
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: (){
                                              pickDynamicInput(context, siteLocationList, filteredSiteLocationList, "Site Location");
                                            },
                                            child: Text(selectedSite, style: selectedSite.contains("Location")?userSignOnTextField:userSignOnTextFieldB,),
                                          )
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: (){
                                          onNewClickDyn("Site");
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_circle_rounded,
                                                color: darkRed,
                                                size: 25,
                                                semanticLabel: 'Home',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ),
                                  ],
                                )
                            ),
                          );
                        }
                        else if(index==5){
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
                            child: Container(
                                width: 160,
                                height: 52,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(40.0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 15,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: (){
                                          setState(() {

                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.upload,
                                                color: darkRed,
                                                size: 23,
                                                semanticLabel: 'Home',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ),
                                    Expanded(
                                      flex: 36,
                                      child: Padding(
                                          padding: const EdgeInsets.only(left: 0, right: 25, top: 3),
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: (){
                                              DateTime nowT = DateTime.now();
                                              String tYear = nowT.year.toString();
                                              String tMonth = nowT.month.toString();
                                              String tDay = nowT.day.toString();
                                              String uniqueT = DateTime.now().millisecondsSinceEpoch.toString();
                                              pickImageFromGallery(uniqueT, tYear, tMonth, tDay);
                                            },
                                            child: Text(selectedFileType.isEmpty?"Site Image":userPictureName, style: userSignOnTextField,),
                                          )
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          );
                        }
                        else if(index==6){
                          return Row(
                            children: [
                              const Expanded(
                                flex: 3,
                                child: Text(""),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 15, 0, 10),
                                  child: Container(
                                      width: 170,
                                      height: 48,
                                      decoration: const BoxDecoration(
                                        color: darkGreen,
                                        borderRadius: BorderRadius.all(Radius.circular(40.0),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 18,
                                            child: GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                              onTap: (){
                                                setState(() {

                                                });
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add_circle_rounded,
                                                      color: Colors.white,
                                                      size: 23,
                                                      semanticLabel: 'Home',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ),
                                          Expanded(
                                            flex: 36,
                                            child: Padding(
                                                padding: const EdgeInsets.only(left: 0, right: 25, top: 3),
                                                child: GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: (){
                                                    if(checkCreditInput()){
                                                      processItemSubmission("Credit");
                                                    }
                                                    else{
                                                      setState((){
                                                        showError=true;
                                                      });
                                                    }
                                                  },
                                                  child: Text("Credit", style: userSignOnTextFieldW,),
                                                )
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                              const Expanded(
                                flex: 3,
                                child: Text(""),
                              ),
                            ],
                          );
                        }
                        else if(index==7){
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text(showError?"Error":"", style: fullyBookedFonts,)
                          );
                        }
                        else{
                          return const Text("");
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: GestureDetector(
                        onTap: (){
                          showCustomDialogLogOut("Log Out?", "Log Out", "All your data will be stored locally until you delete your account");
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                          child: Container(
                            height: 63,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.logout_rounded,
                                    color: darkRed,
                                    size: 25.0,
                                    semanticLabel: 'Friends',
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Text("Log Out", style: headingTextTitles),
                                  ),
                                  const Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Text(""),
                                    ),
                                  ),
                                ],
                              ),
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
        ):const Text(""):const Text(""),
        body: HomePage.activeScreen=="Home"?
        Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 8,
                      child: GestureDetector(
                        onTap: (){
                          if(phoneNumber=="+919099050332"){
                            setState(() {
                              HomePage.activeScreen="Status";
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                              child: Image.asset(
                                "assets/graphics/smatter-logo-c.png",
                                height: 85,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                child: const Icon(
                                  Icons.add_business,
                                  color: darkBlue,
                                  size: 40.0,
                                  semanticLabel: 'Home',
                                ),
                                onTap: () {
                                  onMenuClick();
                                },
                              ),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              )
            ),
            const SizedBox(
              height: 8.0,
            ),
            sBase.checkFileExistSync(path, "User", "Company", "Verification")?Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xffffffff),
                        Color(0xffffffff),
                      ],
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: TextField(
                    style: userRegistrationTitleUDB,
                    textAlign: TextAlign.start,
                    cursorColor: darkBlue,
                    onChanged: (text) {
                      if(text.isEmpty){
                        setState(() {
                          isSearchTyped=false;
                        });
                      }
                      if(showDList==("Delivery")){
                        isSearchTyped=true;
                        setState(() {
                          iUsageFiltered = iUsage
                              .where((u) => (
                              u.iName.toLowerCase()
                                  .contains(text.toLowerCase()) ||
                                  u.iSL.toLowerCase()
                                      .contains(text.toLowerCase()) ||
                                  u.iStatus.toLowerCase()
                                      .contains(text.toLowerCase()) ||
                                  u.iInvoice.toLowerCase()
                                      .contains(text.toLowerCase()) ||
                                  u.iUser.toLowerCase()
                                      .contains(text.toLowerCase()) ||
                                  u.iDT.toLowerCase()
                                      .contains(text.toLowerCase()) ||
                                  u.iType.toLowerCase()
                                      .contains(text.toLowerCase()) ||
                                  u.iC.toLowerCase()
                                      .contains(text.toLowerCase())
                          )).toList();
                        });
                      }
                      else if(showDList==("Order")){
                        isSearchTyped=true;
                        setState(() {
                          oListFiltered = oList
                              .where((u) => (
                              u.iName.toLowerCase()
                                  .contains(text.toLowerCase()) ||
                                  u.iPrice.toLowerCase()
                                      .contains(text.toLowerCase()) ||
                                  u.iStatus.toLowerCase()
                                      .contains(text.toLowerCase()) ||
                                  u.iQuantity.toLowerCase()
                                      .contains(text.toLowerCase()) ||
                                  u.iTime.toLowerCase()
                                      .contains(text.toLowerCase()) ||
                                  u.suppName.toLowerCase()
                                      .contains(text.toLowerCase()) ||
                                  u.oID.toLowerCase()
                                      .contains(text.toLowerCase())

                          )).toList();
                        });
                      }
                    },
                    autocorrect: false,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                      hintText: 'Search Items',
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: userSignOnTextField,
                      border: InputBorder.none,
                    ),
                    controller: itemUsageListController,
                  ),
                ),
              ),
            ):const Text(""),
            userRights.contains("Admin")?Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: GestureDetector(
                            onTap:(){
                              setState(() {
                                isSearchTyped=false;
                                showDList="Order";
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                height: 50,
                                width: 220,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.topRight,
                                      colors: [
                                        darkBlue,
                                        darkBlue,
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
                                            Icons.reorder_rounded,
                                            color: Colors.white,
                                            size: 22.0,
                                            semanticLabel: 'Friends',
                                          ),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Text("Order", style: headingTextTitlesW),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: GestureDetector(
                              onTap:(){
                                setState(() {
                                  isSearchTyped=false;
                                  showDList="Delivery";
                                });
                              },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Container(
                              height: 50,
                              width: 220,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      darkBlue,
                                      darkBlue,
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
                                          Icons.fire_truck_rounded,
                                          color: Colors.white,
                                          size: 22.0,
                                          semanticLabel: 'Friends',
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        Text("Delivery", style: headingTextTitlesW),
                                      ],
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                        )
                      ),
                    ],
                ),
            ):const Text(""),
            Expanded(
              flex: 18,
              child: !sBase.checkFileExistSync(path, "User", "Company", "Verification")?
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text("Select/Create Company", style: headingTextTitlesGSR,),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 5),
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color(0xffffffff),
                              Color(0xffffffff),
                            ],
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: TextField(
                          style: userRegistrationTitleUDB,
                          textAlign: TextAlign.start,
                          cursorColor: darkBlue,
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            if(text.length==6){
                              database.ref('AuthCode/${text.toString()}').once().then((dValue)async{
                                var companyDatabaseID = dValue.snapshot.value;
                                if(companyDatabaseID!=null){
                                  database.ref('UI/${companyDatabaseID.toString()}').once().then((dValueN)async{
                                    var realName = dValueN.snapshot.value;
                                    if(realName!=null){
                                      String dName = realName.toString();
                                      setupRegistration(dName, companyDatabaseID.toString());
                                      setState(() {});
                                    }
                                  },onError: (error) {
                                  });
                                }
                              },onError: (error) {
                                  });
                            }
                          },
                          autocorrect: false,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                            hintText: 'Company Auth Code',
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: userSignOnTextField,
                            border: InputBorder.none,
                          ),
                          controller: companyAuthCode,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: (){
                          getNewCompanyName();
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
                                        Icons.add_circle_rounded,
                                        color: Colors.white,
                                        size: 22.0,
                                        semanticLabel: 'Friends',
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text("Create New", style: headingTextTitlesW),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ):
              showDList==("Delivery")?iUsage.isEmpty?Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: (){
                          onMenuClick();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                            height: 50,
                            width: 210,
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
                                        Icons.add_circle_rounded,
                                        color: Colors.white,
                                        size: 22.0,
                                        semanticLabel: 'Friends',
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text("New Item", style: headingTextTitlesW),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ):isSearchTyped?showItemUsageList(screenHeight, screenWidth, iUsageFiltered):
              showItemUsageList(screenHeight, screenWidth, iUsage):showDList=="Order"?oList.isEmpty?Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: (){
                          onMenuClick();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                            height: 50,
                            width: 210,
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
                                        Icons.add_circle_rounded,
                                        color: Colors.white,
                                        size: 22.0,
                                        semanticLabel: 'Friends',
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text("New Item", style: headingTextTitlesW),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ):isSearchTyped?showItemOrderList(screenHeight, screenWidth, oListFiltered):
              showItemOrderList(screenHeight, screenWidth, oList):const Text(""),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(companyA, style: headingTextTitlesGSR,)
              ),
            )
          ],
        ):HomePage.activeScreen=="Status"?
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xffffffff),
                        Color(0xffffffff),
                      ],
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: TextField(
                    style: userRegistrationTitleUDB,
                    textAlign: TextAlign.start,
                    cursorColor: darkBlue,
                    onChanged: (text) {
                      isSearchStatus=true;
                      setState(() {
                        iSFiltered = iS
                            .where((u) => (
                            u.iName.toLowerCase()
                                .contains(text.toLowerCase()) ||
                                u.iSL.toLowerCase()
                                    .contains(text.toLowerCase()) ||
                                u.iQ.toLowerCase()
                                    .contains(text.toLowerCase()) ||
                                u.iP.toLowerCase()
                                    .contains(text.toLowerCase()) ||
                                u.iTotal.toLowerCase()
                                    .contains(text.toLowerCase())
                        )).toList();
                      });
                      if(text.isEmpty){
                        setState(() {
                          isSearchStatus=false;
                        });
                      }
                    },
                    autocorrect: false,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                      hintText: 'Search Items',
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: userSignOnTextField,
                      border: InputBorder.none,
                    ),
                    controller: itemStatusListController,
                  ),
                ),
              ),
            ),
            Expanded(
              child: isSearchStatus?showItemStatusList(screenHeight, screenWidth, iSFiltered):showItemStatusList(screenHeight, screenWidth, iS),
            )
          ],
        ):HomePage.activeScreen=="UserRights"?
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xffffffff),
                        Color(0xffffffff),
                      ],
                    )
                ),
                child: Center(
                  child: Text("User Rights", style: headingTextTitles,),
                ),
              ),
            ),
            Expanded(
              child: showUserRightsList(screenWidth, screenHeight, userRightsL),
            )
          ],
        ):HomePage.activeScreen=="IView"?
        imageFound?PhotoView(
          minScale: 0.3,
          initialScale: PhotoViewComputedScale.contained * 0.95,
          imageProvider: FileImage(iF),
        ):
        Column(
          children: [
            Image.asset(
              "assets/graphics/placeholder.png",
              width: screenWidth,
              fit: BoxFit.fitWidth,
            )
          ],
        ): const Text(""),
      ),
    ),
    );
  }
  Widget appSignature(int type){
    return Column(
      children: [
        type==0?Image.asset(
          "assets/graphics/app_icon_d.png",
          fit: BoxFit.cover,
          width: 70,
          height: 70,
        ):Image.asset(
          "assets/graphics/app_icon_db.png",
          fit: BoxFit.cover,
          width: 70,
          height: 70,
        ),
        const SizedBox(
          height: 3.0,
        ),
        Center(
          child: Text("Version $appVersion", style: userSignOnTextField,),
        ),
        const SizedBox(
          height: 3.0,
        ),
        Center(
          child: Text("©2018-2023 Smatter LLP", style: userSignOnTextField,),
        ),
      ],
    );
  }
}
class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}
class ProgressBar extends StatelessWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      backgroundColor: Colors.white,
      strokeWidth: 5,);
  }
}