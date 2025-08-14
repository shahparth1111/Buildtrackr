import 'dart:io';
import 'dart:convert';
import 'dart:async';

class JavaMethodsCustom {
  late String folderName, fileName;
  int oIntC = 0;
  static int counter = 0;
  Set<String> countryListA = {"Afghanistan~AF~93",
    "Albania~AL~355",
    "Algeria~DZ~213",
    "American Samoa~AS~1684",
    "Andorra~AD~376",
    "Angola~AO~244",
    "Anguilla~AI~1264",
    "Antarctica~AQ~672",
    "Antigua and Barbuda~AG~1268",
    "Argentina~AR~54",
    "Armenia~AM~374",
    "Aruba~AW~297",
    "Australia~AU~61",
    "Austria~AT~43",
    "Azerbaijan~AZ~994",
    "Bahamas~BS~1242",
    "Bahrain~BH~973",
    "Bangladesh~BD~880",
    "Barbados~BB~1246",
    "Belarus~BY~375",
    "Belgium~BE~32",
    "Belize~BZ~501",
    "Benin~BJ~229",
    "Bermuda~BM~1441",
    "Bhutan~BT~975",
    "Bolivia~BO~591",
    "Bosnia and Herzegovina~BA~387",
    "Botswana~BW~267",
    "Brazil~BR~55",
    "British Indian Ocean Territory~IO~246",
    "British Virgin Islands~VG~1284",
    "Brunei~BN~673",
    "Bulgaria~BG~359",
    "Burkina Faso~BF~226",
    "Burundi~BI~257",
    "Cambodia~KH~855",
    "Cameroon~CM~237",
    "Canada~CA~1",
    "Cape Verde~CV~238",
    "Cayman Islands~KY~1345",
    "Central African Republic~CF~236",
    "Chad~TD~235",
    "Chile~CL~56",
    "China~CN~86",
    "Christmas Island~CX~61",
    "Cocos Islands~CC~61",
    "Colombia~CO~57",
    "Comoros~KM~269",
    "Cook Islands~CK~682",
    "Costa Rica~CR~506",
    "Croatia~HR~385",
    "Cuba~CU~53",
    "Curacao~CW~599",
    "Cyprus~CY~357",
    "Czech Republic~CZ~420",
    "Democratic Republic of the Congo~CD~243",
    "Denmark~DK~45",
    "Djibouti~DJ~253",
    "Dominica~DM~1767",
    "East Timor~TL~670",
    "Ecuador~EC~593",
    "Egypt~EG~20",
    "El Salvador~SV~503",
    "Equatorial Guinea~GQ~240",
    "Eritrea~ER~291",
    "Estonia~EE~372",
    "Ethiopia~ET~251",
    "Falkland Islands~FK~500",
    "Faroe Islands~FO~298",
    "Fiji~FJ~679",
    "Finland~FI~358",
    "France~FR~33",
    "French Polynesia~PF~689",
    "Gabon~GA~241",
    "Gambia~GM~220",
    "Georgia~GE~995",
    "Germany~DE~49",
    "Ghana~GH~233",
    "Gibraltar~GI~350",
    "Greece~GR~30",
    "Greenland~GL~299",
    "Grenada~GD~1473",
    "Guam~GU~1671",
    "Guatemala~GT~502",
    "Guernsey~GG~441481",
    "Guinea~GN~224",
    "Guinea-Bissau~GW~245",
    "Guyana~GY~592",
    "Haiti~HT~509",
    "Honduras~HN~504",
    "Hong Kong~HK~852",
    "Hungary~HU~36",
    "Iceland~IS~354",
    "India~IN~91",
    "Indonesia~ID~62",
    "Iran~IR~98",
    "Iraq~IQ~964",
    "Ireland~IE~353",
    "Isle of Man~IM~441624",
    "Israel~IL~972",
    "Italy~IT~39",
    "Ivory Coast~CI~225",
    "Jamaica~JM~1876",
    "Japan~JP~81",
    "Jersey~JE~441534",
    "Jordan~JO~962",
    "Kazakhstan~KZ~7",
    "Kenya~KE~254",
    "Kiribati~KI~686",
    "Kosovo~XK~383",
    "Kuwait~KW~965",
    "Kyrgyzstan~KG~996",
    "Laos~LA~856",
    "Latvia~LV~371",
    "Lebanon~LB~961",
    "Lesotho~LS~266",
    "Liberia~LR~231",
    "Libya~LY~218",
    "Liechtenstein~LI~423",
    "Lithuania~LT~370",
    "Luxembourg~LU~352",
    "Macau~MO~853",
    "Macedonia~MK~389",
    "Madagascar~MG~261",
    "Malawi~MW~265",
    "Malaysia~MY~60",
    "Maldives~MV~960",
    "Mali~ML~223",
    "Malta~MT~356",
    "Marshall Islands~MH~692",
    "Mauritania~MR~222",
    "Mauritius~MU~230",
    "Mayotte~YT~262",
    "Mexico~MX~52",
    "Micronesia~FM~691",
    "Moldova~MD~373",
    "Monaco~MC~377",
    "Mongolia~MN~976",
    "Montenegro~ME~382",
    "Montserrat~MS~1664",
    "Morocco~MA~212",
    "Mozambique~MZ~258",
    "Myanmar~MM~95",
    "Namibia~NA~264",
    "Nauru~NR~674",
    "Nepal~NP~977",
    "Netherlands~NL~31",
    "Netherlands Antilles~AN~599",
    "New Caledonia~NC~687",
    "New Zealand~NZ~64",
    "Nicaragua~NI~505",
    "Niger~NE~227",
    "Nigeria~NG~234",
    "Niue~NU~683",
    "North Korea~KP~850",
    "Northern Mariana Islands~MP~1670",
    "Norway~NO~47",
    "Oman~OM~968",
    "Pakistan~PK~92",
    "Palau~PW~680",
    "Palestine~PS~970",
    "Panama~PA~507",
    "Papua New Guinea~PG~675",
    "Paraguay~PY~595",
    "Peru~PE~51",
    "Philippines~PH~63",
    "Pitcairn~PN~64",
    "Poland~PL~48",
    "Portugal~PT~351",
    "Qatar~QA~974",
    "Republic of the Congo~CG~242",
    "Reunion~RE~262",
    "Romania~RO~40",
    "Russia~RU~7",
    "Rwanda~RW~250",
    "Saint Barthelemy~BL~590",
    "Saint Helena~SH~290",
    "Saint Kitts and Nevis~KN~1869",
    "Saint Lucia~LC~1758",
    "Saint Martin~MF~590",
    "Saint Pierre and Miquelon~PM~508",
    "Saint Vincent and the Grenadines~VC~1784",
    "Samoa~WS~685",
    "San Marino~SM~378",
    "Sao Tome and Principe~ST~239",
    "Saudi Arabia~SA~966",
    "Senegal~SN~221",
    "Serbia~RS~381",
    "Seychelles~SC~248",
    "Sierra Leone~SL~232",
    "Singapore~SG~65",
    "Sint Maarten~SX~1721",
    "Slovakia~SK~421",
    "Slovenia~SI~386",
    "Solomon Islands~SB~677",
    "Somalia~SO~252",
    "South Africa~ZA~27",
    "South Korea~KR~82",
    "South Sudan~SS~211",
    "Spain~ES~34",
    "Sri Lanka~LK~94",
    "Sudan~SD~249",
    "Suriname~SR~597",
    "Svalbard and Jan Mayen~SJ~47",
    "Swaziland~SZ~268",
    "Sweden~SE~46",
    "Switzerland~CH~41",
    "Syria~SY~963",
    "Taiwan~TW~886",
    "Tajikistan~TJ~992",
    "Tanzania~TZ~255",
    "Thailand~TH~66",
    "Togo~TG~228",
    "Tokelau~TK~690",
    "Tonga~TO~676",
    "Trinidad and Tobago~TT~1868",
    "Tunisia~TN~216",
    "Turkey~TR~90",
    "Turkmenistan~TM~993",
    "Turks and Caicos Islands~TC~1649",
    "Tuvalu~TV~688",
    "U.S. Virgin Islands~VI~1340",
    "Uganda~UG~256",
    "Ukraine~UA~380",
    "United Arab Emirates~AE~971",
    "United Kingdom~GB~44",
    "United States~US~1",
    "Uruguay~UY~598",
    "Uzbekistan~UZ~998",
    "Vanuatu~VU~678",
    "Vatican~VA~379",
    "Venezuela~VE~58",
    "Vietnam~VN~84",
    "Wallis and Futuna~WF~681",
    "Western Sahara~EH~212",
    "Yemen~YE~967",
    "Zambia~ZM~260",
    "Zimbabwe~ZW~263"};

  List<String> delimitString(String toDelimit, String cDelimiter) {
    List<String> listD = <String>[];
    while (toDelimit.contains(cDelimiter)) {
      if(toDelimit.length != 1){
        listD.add(toDelimit.substring(0, toDelimit.indexOf(cDelimiter)));
        toDelimit = toDelimit.substring(toDelimit.indexOf(cDelimiter) + 1);
      }
      else{
        listD.add('#');
        toDelimit = toDelimit.substring(toDelimit.indexOf(cDelimiter) + 1);
      }
    }
    return listD;
  }
  Future<bool> checkFileExist(final pathR, String preFolderName, String folderName, String fileName) async {
    final path = await pathR;
    File fileToCheck = File('$path/$preFolderName/$folderName/$fileName');
    return fileToCheck.exists();
  }
  bool checkFileExistSync(final path, String preFolderName, String folderName, String fileName) {
    File fileToCheck;
    bool isExists=false;
    try{
      fileToCheck = File('$path/$preFolderName/$folderName/$fileName');
      isExists = fileToCheck.existsSync();
    }catch(exception){}
    return isExists;
  }
  Future<bool> writeCheckedFile(final getDirectory, String preFolderName, String folderName, String fileName, String content, bool cAppend) async {
    bool toRet = false;
    final path = await getDirectory;
    createDirectory(path, preFolderName, folderName).then((dir) async {
      final tDir = dir.path;
      createFile(tDir, fileName).then((file) async {
        bool isExist = file.existsSync();
        if (isExist) {
          if (!cAppend) {
            var sink = file.openWrite();
            sink.write(content);
            try {
              await sink.close();
            } catch (exception){}
          }
          else {
            var sink = file.openWrite(mode: FileMode.append);
            sink.add(utf8.encode('\n$content')); //Use newline as the delimiter
            try {
              await sink.flush();
              await sink.close();
            } catch (exception) {}
          }
        }
      });
    });
    toRet = true;
    return toRet;
  }
  void writeFilesRealtime(final path, String preFolderName, String folderName, String fileName, String content, bool cAppend) {
    Directory dirA = Directory('$path/$preFolderName');
    dirA.createSync();
    Directory dirB = Directory('$path/$preFolderName/$folderName');
    dirB.createSync();
    final tDir = dirB.path;
    bool justCreated=false;
    if(!File('$tDir/$fileName').existsSync()) {
      justCreated=true;
      File('$tDir/$fileName').createSync();
    }
    var file = File('$tDir/$fileName');
    if(justCreated || !cAppend || file.lengthSync()==0) {
      file.writeAsStringSync(content);
    }
    else{
      file.writeAsStringSync('\n$content', mode: FileMode.append);
    }
  }
  File createFileRealtime(final directory, fileName) {
    File fileToCreate = File('$directory/$fileName');
    fileToCreate.create(recursive: true);
    return fileToCreate;
  }
  Future<File> createFile(final directory, fileName) {
    return File('$directory/$fileName').create(recursive: true);
  }
  Future<Directory> createDirectory(final tempDirectory, String preFolderName, String folderName) {
    Directory dirA = Directory('$tempDirectory/$preFolderName');
    dirA.create(recursive: true);
    return Directory('$tempDirectory/$preFolderName/$folderName').create(recursive: true);
  }
  List<FileSystemEntity> getAllFilesDirectory(final directory, final folderName) {
    List<FileSystemEntity> toRet = <FileSystemEntity>[];
    try{
      Directory mainD = Directory('$directory/$folderName');
      toRet = mainD.listSync();
    }catch(exception){}
    return toRet;
  }
  List<FileSystemEntity> getAllFilesSubDirectory(final directory, final preFolderName, final folderName) {
    List<FileSystemEntity> toRet = <FileSystemEntity>[];
    try{
      Directory mainD = Directory('$directory/$preFolderName/$folderName');
      toRet = mainD.listSync();
    }catch(exception){}
    return toRet;
  }
  String getFirstLineSync(final path, String preFolderName, String folderName, String fileName) {
    String toRet = "#";
    try{
      var res = checkFileExistSync(path, preFolderName, folderName, fileName);
      if (res) {
        File file = File('$path/$preFolderName/$folderName/$fileName');
        toRet = file.readAsStringSync();
        toRet = toRet.trim();
      }
    }catch(exception){}
    return toRet;
  }
  Future<List<String>> readFileList(final getDirectory, String preFolderName, String folderName, String fileName)async {
    List<String> toRet = <String>[];
    final path = await getDirectory;
    await checkFileExist(path, preFolderName, folderName, fileName).then((checkExist) async {
      if(checkExist){
        File file= File('$path/$preFolderName/$folderName/$fileName');
        try {
          toRet = await file.readAsLines();
        }catch(exception){}
      }
    });
    return toRet;
  }
  deleteFile(final path, String preFolderName, String folderName, String fileName) {
    try {
      createDirectory(path, preFolderName, folderName);
      File toDelete = File('$path/$preFolderName/$folderName/$fileName');
      toDelete.deleteSync();
    } catch (exception) {}
  }
  void deleteDirectory(final tempDir, String preFolderName, String folderName){
    try{
      createDirectory(tempDir, preFolderName, folderName);
      final dir = Directory('$tempDir/$preFolderName/$folderName');
      dir.deleteSync(recursive: true);
    }catch(exception){}
  }
  void deleteFullDirectory(final tempDir, String preFolderName){
    try{
      Directory dirA = Directory('$tempDir/$preFolderName');
      dirA.create(recursive: true);
      final dir = Directory('$tempDir/$preFolderName');
      dir.deleteSync(recursive: true);
    }catch(exception){}
  }
}
class ItemStatus{
  final String iName, iQ, iP, iTotal, iSL;
  ItemStatus(this.iName, this.iQ, this.iP, this.iTotal, this.iSL);
}
class ItemUsage{
  final String iName, iQ, iP, iType, iSL, iUser, iDT, iInvoice, iC, iPictureName, iStatus, iKey;
  ItemUsage(this.iName, this.iQ, this.iP, this.iType, this.iSL, this.iUser, this.iDT, this.iInvoice,
      this.iC, this.iPictureName, this.iStatus, this.iKey);
}
class OrderList{
  final String oID, iName, suppName, iQuantity, iUnit, iPrice, iTime, iStatus;
  OrderList(this.oID, this.iName, this.suppName, this.iQuantity, this.iUnit, this.iPrice, this.iTime, this.iStatus);
}
class UserRights{
  final String uNumber, uRights;
  UserRights(this.uNumber, this.uRights);
}