import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '/colors/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/constant/Constants.dart';
import '/screens/authentication/LoginScreen.dart';
import '/screens/authentication/VerifyAccountScreen.dart';
import '/screens/products/VerifyCustomerScreen.dart';
import '/util/size_config.dart';
//import '/widgets/FullScreenPhotoView.dart';
import '/widgets/Styles.dart';
import '/util/Util.dart';
//import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:path/path.dart';
import '/widgets/multiselection.dart';
//import '/widgets/multiselection.dart'; //due to importing path, a lot of our context have to be change to this.context ,, this is due to the problem of importing path package itself. please note this.


//List<Item> itemList;
List selectedList = []; //purposely declare as global so that we can access from widget multiselection, for better coding this should be done, but due to this is a rapid development this have to be done.

class MySubmitFormScreen extends StatefulWidget {
  MySubmitFormScreen(this.supporticket);

  final supporticket;

  //item is for ticket details, we can also use riverpod family instead if we wish for later (for better state management rather)
  // for simplicity we purposely use statful widget and passing from screen to screen instead of using riverpod family (or anything that can store data like a repository like BLOC repository)

  @override
  _MySubmitFormScreenState createState() => _MySubmitFormScreenState();

  void isSelected(bool isSelected) {}
}

class _MySubmitFormScreenState extends State<MySubmitFormScreen> {
  TextEditingController followUp = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController validUntil = new TextEditingController();
  TextEditingController cvv = new TextEditingController();
  TextEditingController resolution = new TextEditingController();
  //TextEditingController resolutionTimer = new TextEditingController();
  TextEditingController problem = new TextEditingController();

  FocusNode focusNodeFollowUp = new FocusNode();
  FocusNode focusNodeDescription = new FocusNode();
  FocusNode focusNodeValidUntil = new FocusNode();
  FocusNode focusNodeCvv = new FocusNode();
  FocusNode focusNodeResolution = new FocusNode();
  //FocusNode focusNodeResolutionTimer = new FocusNode();
  FocusNode focusNodeErrorNotification = new FocusNode();
  FocusNode focusNodeProblem = new FocusNode();

  late File imageFile;


  late DateTime selectedCardExpiryDate;
  bool isSaveCardSelected = false,
      displaySuccessDialog = false,
      isDisplayErrorNotification = false;
  String errorMessage = '';
  var imagePicker = ImagePicker();
  List imageFileList = [];

  //var _imagecontroller;

  bool isSelected = false;
  bool _checkboxagree=false;
  bool _checkboxagree2=false;

  void _checkboxConfirmation() {

  }


  void selectImages() async {
    final List selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    print("Image List Length:" + imageFileList.length.toString());
    setState((){});
  }

  Future showImagePickerDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(imageDialogTitle),
        content: Text(imageDialogDesc),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await pickImageFromCamera(context);
              //selectImages();
            },

            child: Text(
              camera,
              style: TextStyle(
                fontSize: 14,
                fontFamily: poppinsFont,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              //await pickImageFromGallery(context);
              selectImages();
            },
            child: Text(
              gallery,
              style: TextStyle(
                fontSize: 14,
                fontFamily: poppinsFont,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future pickImageFromCamera(BuildContext context) async {
    try {
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 100,
      );

      if(pickedFile!= null)
        cropImage(context, pickedFile?.path ?? "");
      imageFileList.add(pickedFile);

    } catch (e) {
      // PlatformException exemption = e;

      showErrorToast(context, 'Error!');
    }
  }

  Future pickImageFromGallery(BuildContext context) async {
    try {
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 100,
      );

      if(pickedFile!= null)
        cropImage(context, pickedFile?.path     ?? "");

    } catch (e) {
      // PlatformException exemption = e;

      showErrorToast(context, 'Error!');
    }
  }

  Future cropImage(BuildContext context, String filePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatioPresets: setAspectRatios(),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop your image',
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,


          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop your image',
          minimumAspectRatio: 1.0,
        )],
    );
    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path ?? "");
      });
    }
  }

  void showErrorNotification(String message) {
    setState(() {
      isDisplayErrorNotification = true;
      errorMessage = message;
      FocusScope.of(this.context).requestFocus(focusNodeErrorNotification);
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
    focusNodeFollowUp.addListener(() => setState(() {}));
    focusNodeDescription.addListener(() => setState(() {}));
    focusNodeValidUntil.addListener(() => setState(() {}));
    focusNodeCvv.addListener(() => setState(() {}));
    focusNodeResolution.addListener(() => setState(() {}));
    //focusNodeResolutionTimer.addListener(() => setState(() {}));
    focusNodeProblem.addListener(() => setState(() {}));

  }

  @override
  void dispose() {
    focusNodeFollowUp.dispose();
    focusNodeDescription.dispose();
    focusNodeValidUntil.dispose();
    focusNodeCvv.dispose();
    focusNodeResolution.dispose();
    focusNodeErrorNotification.dispose();
    //focusNodeResolutionTimer.dispose();
    focusNodeProblem.addListener(() => setState(() {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _format = DateFormat("yyyy-MM-dd HH:mm:ss");

    return Scaffold(
      backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
      appBar: selectedList.length < 1 ?
      buildAppBar(context, "Job Details", onBackPress: () {
        Navigator.pop(context);
      })
          : getAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
                child: Card(
                  elevation: 6,
                  color: isDarkMode(context) ? Colors.white10 : Colors.white,
                  shadowColor: Colors.grey.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 22.0, right: 22.0, top: 8, bottom: 10),
                    child: Column(

                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Visibility(
                              visible: isDisplayErrorNotification,
                              child: buildErrorNotificationWithOption(
                                context,
                                errorMessage,
                                hideLabel,
                                isDarkMode(context)
                                    ? Colors.red[900]!
                                    : pinkishColor,
                                true,
                                focusNode: focusNodeErrorNotification,
                                onOptionTap: () {
                                  setState(
                                        () {
                                      isDisplayErrorNotification = false;
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset(
                            isDarkMode(context)
                                ? '$darkIconPath/task-list.svg'
                                : '$lightIconPath/task-list.svg',
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5.5,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // buildProblem(),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Resolution",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildResolutionName(),
                        SizedBox(
                          height: 10,
                        ),


                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Follow-up",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildAddFollowUp(),
                        SizedBox(
                          height: 10,
                        ),

                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Description",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildAddDescription(),
                        SizedBox(
                          height: 10,
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Upload proof of work (optional)",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        SizedBox(height: 10),


                        InkWell(
                          onTap: () => showImagePickerDialog(context),
                          child: Container(
                            child:  buildButtonWithSuffixIcon(
                              "Upload",
                              Icons.upload_file,
                              true,
                              isDarkMode(this.context) ? primaryColorDark : primaryColor,
                              isDarkMode(this.context)
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.white,
                              2,
                              2,
                              8,
                              onPressed: () {
                                showImagePickerDialog(context);
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Chosen Images",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onLongPress:() {
                              setState(() {
                                isSelected = !isSelected;
                                widget.isSelected(isSelected);
                              });
                            },
                            child:

                            GridView.builder(

                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: imageFileList.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                                itemBuilder: (BuildContext context, int index) {

                                  return GridItem(
                                      item: imageFileList[index].path,//Image.file(File(imageFileList[index].path), fit: BoxFit.cover,),
                                      isSelected: (bool value) {
                                        setState(() {
                                          if (value) {
                                            selectedList.add(imageFileList[index]);
                                          } else {
                                            selectedList.remove(imageFileList[index]);
                                          }
                                        });
                                        print("$index : $value");
                                      },
                                      key:  Key(imageFileList[index].toString())
                                    //Key(imageFileList[index].rank.toString())
                                  );
                                  //return Image.file(File(imageFileList[index].path), fit: BoxFit.cover,);
                                }),
                          ),
                        ),

                        SizedBox(height: 30,),
                        Container(
                          child: Row(
                            children: [
                              Material(
                                child: Checkbox(
                                  value: _checkboxagree2,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkboxagree2 = value ?? false;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: const Text(
                                  'Ticket In Progress',
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Material(
                                child: Checkbox(
                                  value: _checkboxagree,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkboxagree = value ?? false;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: const Text(
                                  'Ticket Closed',
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30)
                        //FlutterLogo(size: 160)
                      ],

                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: displaySuccessDialog,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black26,
                      ),
                      buildSuccessDialog(),
                    ],
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !displaySuccessDialog,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 16.0, left: 22, right: 22, bottom: 8.0),
          child: new Container(
            height: 56.0,
            alignment: Alignment.center,
            child: buildSBottomButtons(),
          ),
        ),
      ),
    );
  }

  Widget buildAddDescription() {
    return buildTextFieldExtraHeight(
      this.context,
      description,
      TextCapitalization.words,
      TextInputType.name,
      TextInputAction.done,
      false,
      primaryColor,
      10.0,
      primaryColor,
      primaryColor,
      primaryColor,
      focusNodeDescription.hasFocus
          ? primaryColor.withOpacity(0.15)
          : Colors.transparent,
      500,
      3,
      '',
      true,
      focusNode: focusNodeDescription,
      onChange: (value) {},
      onSubmit: () {},


    );

  }

  Widget buildAddFollowUp() {
    return buildTextFieldExtraHeight(
      this.context,
      followUp,
      TextCapitalization.words,
      TextInputType.name,
      TextInputAction.done,
      false,
      primaryColor,
      10.0,
      primaryColor,
      primaryColor,
      primaryColor,
      focusNodeFollowUp.hasFocus
          ? primaryColor.withOpacity(0.15)
          : Colors.transparent,
      500,
      3,
      '',
      true,
      focusNode: focusNodeFollowUp,
      onChange: (value) {},
      onSubmit: () {},


    );

  }

  Widget buildProblem() {
    return buildTextFieldExtraHeight(
        this.context,
        problem,
        TextCapitalization.words,
        TextInputType.name,
        TextInputAction.done,
        false,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeProblem.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        500,
        3,
        '',
        true,
        focusNode: focusNodeProblem,
        onChange: (value) {},
        onSubmit: () {});
  }


  Widget buildValidUntil() {
    return buildTextField(
        this.context,
        validUntil,
        TextCapitalization.none,
        TextInputType.number,
        TextInputAction.next,
        false,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeValidUntil.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        16,
        selectedCardExpiryDate != null
            ? '${selectedCardExpiryDate?.year}\/${selectedCardExpiryDate?.month}'
            : '',
        false,
        focusNode: focusNodeValidUntil,
        onChange: (value) {},
        onSubmit: () {});
  }

  Widget buildCvvNumber() {
    return buildTextField(
        this.context,
        cvv,
        TextCapitalization.none,
        TextInputType.number,
        TextInputAction.next,
        true,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeCvv.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        3,
        '',
        true,
        focusNode: focusNodeCvv,
        onChange: (value) {},
        onSubmit: () {});
  }

  Widget buildResolutionName() {
    return buildTextField(
        this.context,
        resolution,
        TextCapitalization.words,
        TextInputType.name,
        TextInputAction.done,
        false,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeResolution.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        500,
        '',
        true,
        focusNode: focusNodeResolution,
        onChange: (value) {},
        onSubmit: () {});
  }

  buildDatePicker(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );


    if (picked != null && picked != selectedCardExpiryDate)
      setState(
            () {
          selectedCardExpiryDate = picked;
        },
      );
  }

  Widget buildCheckBox() {
    return Row(
      children: [
        Checkbox(
          value: isSaveCardSelected,
          activeColor: primaryColor,
          onChanged: (b) {
            setState(() {
              isSaveCardSelected = b!;
            });
          },
        ),
        Expanded(
          child: Text(
            saveCardLabel,
            style: Theme.of(this.context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }

  Widget buildSuccessDialog() {
    return buildDialogWithAnimation(
      this.context,
      "'Jobs done!'- Bob The Builder",
      goBackLabel,
      onTap: () {
        SchedulerBinding.instance.addPostFrameCallback(
              (_) {
            Navigator.pop(this.context);
          },
        );
      },
    );
  }

  getAppBar() {
    return AppBar(
      title: Text(selectedList.length < 1
          ? "Multi Selection"
          : "${selectedList.length} item selected"),
      actions: <Widget>[
        selectedList.length < 1
            ? Container()
            : InkWell(
            onTap: () {
              setState(() {
                for (int i = 0; i < selectedList.length; i++) {
                  imageFileList.remove(selectedList[i]);
                }
                //selectedList = [];//List();
                selectedList.clear();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.delete),
            ))
      ],
    );
  }


  Widget buildSBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: buildButton(
              cancelLabel,
              true,
              secondaryColor,
              Colors.white,
              2,
              2,
              8,
              onPressed: () {
                Navigator.pop(this.context);
              },
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            child: buildButtonWithSuffixIcon(
              continueLabel,
              Icons.arrow_forward_rounded,
              true,
              isDarkMode(this.context) ? primaryColorDark : primaryColor,
              isDarkMode(this.context)
                  ? Colors.white.withOpacity(0.8)
                  : Colors.white,
              2,
              2,
              8,
              onPressed: () {
                checkValidations(); //should make if no error, then navigate push later for real scene

              },
            ),
          ),
        )
      ],
    );
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(this.context).removeCurrentSnackBar();
    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }



  void checkValidations() {

    if (description.text.isEmpty) {
      showErrorNotification('Please enter remarks for Description');
      //} else if (selectedCardExpiryDate == null) {
      //  showErrorNotification('Please select card expiry date');
      //} else if (cvv.text.isEmpty) {
      //  showErrorNotification('Please select country');
    }
    else if(_checkboxagree && _checkboxagree2) {
      showSnackBarText("You cannot tick both checkboxes!");
    }//else if (resolution.text.isEmpty) {
    //showErrorNotification('Please enter resolution');
    else {
      if (isDisplayErrorNotification == true) {
        hideErrorNotification();
      }
      hideKeyboard(this.context);

      if (_checkboxagree2 == true){
        try{
          saveToDatabase2(description, imageFileList, widget.supporticket.ticket_id, this.context); //save to backend
          setState(() {
            displaySuccessDialog = true;
          });

        }catch(e){

          buildErrorNotification(
            "Failed saving data, please try again",
            isDarkMode(this.context) ? Colors.red[900]! : pinkishColor,
          );
          return print(e.toString());
        }
        /*setState(() {
          displaySuccessDialog = true;
        });
        */
      }

      if (_checkboxagree == true){
        try{
          saveToDatabase(resolution,followUp, description, imageFileList, widget.supporticket.ticket_id, this.context); //save to backend
          setState(() {
            displaySuccessDialog = true;
          });

        }catch(e){

          buildErrorNotification(
            "Failed saving data, please try again",
            isDarkMode(this.context) ? Colors.red[900]! : pinkishColor,
          );
          return print(e.toString());
        }
        /*setState(() {
          displaySuccessDialog = true;
        });
        */
      }
      else if(_checkboxagree != true && _checkboxagree2 != true) {
        showSnackBarText("Please ensure you tick the confirmation checkbox!");
      }
    }
  }
}


Future<void> saveToDatabase(resolution,followup,description,imageFileList, ticket_id, context) async {

  //DateTime resolutionTimerDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(resolutionTimer.text);
  //resolutionTimerDate.subtract(Duration(hours: 8)); // we subtract 8 hours to convert MYT to GMT
  //String resolutionTimerUTC = resolutionTimerDate.toString();

  //here we combined problem,resolution and followup and save to database comment
  String comment = "Resolution: "+resolution.text+"\nFollow-up: "+followup.text;
  String comment2 = "Follow UP: "+description.text;
  //var attachment // for attachmenment we will upload the proof of work picture

  // First, get the ID of the 'Staff Closed' state
  var stateData = await globalClient.callKw({
    'model': 'website.supportzayd.ticket.states',
    'method': 'search_read',
    'args': [],
    'kwargs': {
      'domain': [['name', '=', 'Technician Closed']],
      'fields': ['id'],
    },
  });
  int stateId = stateData[0]['id'];

  await globalClient.callKw({

    'model': 'website.supportzayd.ticket',
    'method': 'write',
    'args': [
      [int.parse(ticket_id)], //update check_in data using ticket id
      {
        //'case_done': resolutionTimerUTC,
        'close_comment' : comment,
        'description' : comment2,
        'state' : stateId, // Use the state ID here
        //'check_out_long' : ,
        //'check_out_address' : address,
      },
    ],
    'kwargs': {},
  });

  if(imageFileList.isNotEmpty){

    for(int i=0;i<imageFileList.length;i++){
      List<int> imageBytes = await imageFileList[i].readAsBytes();
      String imageBase64 = base64Encode(imageBytes);
      //String fileName = imageFile.path.split(Platform.pathSeparator).last;
      // ignore: unnecessary_statements
      //print("file name after convert? : "+imageFile.toString());

      //final _filename = basename(imageFile.path);
      final _extension = extension(imageFileList[i].path).substring(1); // Remove the leading period
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
      //imageFile.rename ("TicketImage"+DateTime.now().toString() +_extension.toString());

      try{
        await globalClient.callKw({
          'model': 'ir.attachment',
          'method': 'create',
          'args': [
            {
              'res_model': 'website.supportzayd.ticket',
              'name': 'proofImage_'+now.toString(),
              'res_id':ticket_id,
              'type': 'binary',
              'mime_type' : 'image/$_extension',
              //'store_fname': _filename,
              'datas_fname':'proofImage_'+DateFormat('yyyyMMddHHmmss').format(date),
              'datas':imageBase64,
              //'datas':'base64.b64encode($imageBase64)'
            },
          ],
          'kwargs': {
          },
        });
      }catch(e){

        return Future.error(e.toString());
      }


      print("success uploading images[number: $i] ");
    }

  }
}
Future<void> saveToDatabase2(description,imageFileList, ticket_id, context) async {

  //DateTime resolutionTimerDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(resolutionTimer.text);
  //resolutionTimerDate.subtract(Duration(hours: 8)); // we subtract 8 hours to convert MYT to GMT
  //String resolutionTimerUTC = resolutionTimerDate.toString();

  //here we combined problem,resolution and followup and save to database comment
  String comment2 = "Follow UP: "+description.text;
  //var attachment // for attachmenment we will upload the proof of work picture

  // First, get the ID of the 'Staff Closed' state
  var stateData = await globalClient.callKw({
    'model': 'website.supportzayd.ticket.states',
    'method': 'search_read',
    'args': [],
    'kwargs': {
      'domain': [['name', '=', 'Open']],
      'fields': ['id'],
    },
  });
  int stateId = stateData[0]['id'];

  await globalClient.callKw({

    'model': 'website.supportzayd.ticket',
    'method': 'write',
    'args': [
      [int.parse(ticket_id)], //update check_in data using ticket id
      {
        //'case_done': resolutionTimerUTC,
        'description' : comment2,
        'state' : stateId, // Use the state ID here
        //'check_out_long' : ,
        //'check_out_address' : address,
      },
    ],
    'kwargs': {},
  });

  if(imageFileList.isNotEmpty){

    for(int i=0;i<imageFileList.length;i++){
      List<int> imageBytes = await imageFileList[i].readAsBytes();
      String imageBase64 = base64Encode(imageBytes);
      //String fileName = imageFile.path.split(Platform.pathSeparator).last;
      // ignore: unnecessary_statements
      //print("file name after convert? : "+imageFile.toString());

      //final _filename = basename(imageFile.path);
      final _extension = extension(imageFileList[i].path).substring(1); // Remove the leading period
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
      //imageFile.rename ("TicketImage"+DateTime.now().toString() +_extension.toString());

      try{
        await globalClient.callKw({
          'model': 'ir.attachment',
          'method': 'create',
          'args': [
            {
              'res_model': 'website.supportzayd.ticket',
              'name': 'proofImage_'+now.toString(),
              'res_id':ticket_id,
              'type': 'binary',
              'mime_type' : 'image/$_extension',
              //'store_fname': _filename,
              'datas_fname':'proofImage_'+DateFormat('yyyyMMddHHmmss').format(date),
              'datas':imageBase64,
              //'datas':'base64.b64encode($imageBase64)'
            },
          ],
          'kwargs': {
          },
        });
      }catch(e){

        return Future.error(e.toString());
      }


      print("success uploading images[number: $i] ");
    }

  }
}


