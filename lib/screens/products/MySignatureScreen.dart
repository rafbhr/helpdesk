import 'dart:ui';
import '/Api/PdfApi.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import '/OdooApiCall_DataMapping/ToCheckIn_ToCheckOut_SupportTicket.dart';
import '/util/Util.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../colors/Colors.dart';
import '../../constant/Constants.dart';

class MySignatureScreen extends StatefulWidget {
  final ToCheckInOutSupportTicket supportticket;

  const MySignatureScreen({required Key key, required this.supportticket}) : super(key: key);

  @override
  State<MySignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<MySignatureScreen> {
  final problem = TextEditingController();
  final keySignaturePad = GlobalKey<SfSignaturePadState>();

  @override
  Widget build(BuildContext context) {
  //setting up screensize mediaquery
  final screensize = MediaQuery.of(context).size;
  //setting up submit cmform button function
  return Scaffold(
        //   appBar: buildAppBar(context, "Get Signature", onBackPress: () {
        //   Navigator.pop(context);
        // }),
        body: Column(
          children: [
            SfSignaturePad(
              backgroundColor: Colors.grey.withOpacity((0.2)),
              key: keySignaturePad),  
                            
            Container(
              color: Colors.blueGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                    child: Text("Clear"),
                    onPressed: () async {
                      final image = keySignaturePad.currentState?.clear();
                    }),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: onSubmit, child: Text('Save as PDF')),
                  ),
                ],
              ),
            ),

            Expanded(
              flex:1,
              
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(left: 0.1* screensize.width, right:0.1* screensize.width, top: 0.05 *screensize.height, bottom: 0.05 *screensize.height),
                  child: Column(
                    children: [
                      buildDetailScreen(),
                      SizedBox(height:10),
                      buildResolutionDetails(),
                    ]),
                )
              ),
            ),
          ],
        ), 
          
  );
  
  }
  Future onSubmit() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context)=> Center(child: CircularProgressIndicator())
    );
    final image = await keySignaturePad.currentState?.toImage();
    final imageSignature = await image?.toByteData(format: ImageByteFormat.png);

    if (imageSignature != null) {
      final file = await PdfApi.generatePDF(
          imageSignature: imageSignature, supportticket: widget.supportticket );
      Navigator.of(context).pop();
      await OpenFile.open(file.path);
    }
  }


  Widget buildDetailScreen() {

      var _RowSerialNumber = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Equipment Serial Number: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              widget.supportticket.itemname != null ?
              Text(
                widget.supportticket.itemname,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ): const SizedBox(height:0)  ,            
            ),
          ),
        ],
      );
                   
      var _RowEquipmentLocation = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Equipment Location: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.equipment_location !='' ?
              Text(
                widget.supportticket.equipment_location,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0)  ,            
            ),
          ),
        ],
      );
                    
      var _RowEquipmentUser = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Equipment User: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.equipment_user != '' ?
              Text(
                widget.supportticket.equipment_user,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowReportedBy = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Reported By: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.reported_by != '' ?
              Text(
                widget.supportticket.reported_by,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );
                  
      var _RowContactNumber = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Contact Number: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
                    ),
                    ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.contact_num != '' ?
              Text(
                widget.supportticket.contact_num,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );
                   
      var _RowEmail = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Email: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.email != '' ?
              Text(
                widget.supportticket.email,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );
                    
      var _RowDepartment = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Department: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.department != '' ?
              Text(
                widget.supportticket.department,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );
                  
      var _RowAddress = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Address: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
                    ),
                    ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.address != '' ?
              Text(
                widget.supportticket.address,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
                  )
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowCategory = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Category: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.category_name != '' ?
              Text(
                widget.supportticket.category_name,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowSubCategory = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Subcategory: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
                ),                  
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.subcategory_name != '' ?
              Text(
                widget.supportticket.subcategory_name,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
                )
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowProblem = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Problem: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.problem_name != '' ?
              Text(
                widget.supportticket.problem_name,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );
          
      var _RowPriority = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Priorty: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.problem_name != '' ?
              Text(
                widget.supportticket.problem_name,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
  );
  
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(14),
        vertical: getProportionateScreenWidth(8),
      ),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: getProportionateScreenWidth(8),
                  left: getProportionateScreenWidth(12)),
              child: Text(
                detailsLabel,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Divider(),
            _RowSerialNumber,
            _RowEquipmentLocation,
            _RowEquipmentUser,
            _RowReportedBy,
            _RowContactNumber,
            _RowEmail,
            _RowDepartment,
            _RowAddress,
            _RowCategory,
            _RowSubCategory,
            _RowProblem,
            SizedBox(
              height: SizeConfig.screenHeight * 0.015,
            )
          ],
        ),
      ),
  ); 
  }
  
  Widget buildResolutionDetails() {
    var _RowSerialNumber = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Comment: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.close_comment != '' ?
              Text(
                widget.supportticket.close_comment,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );


    //var _RowEquipmentLocation;
    //var _RowEquipmentUser;


    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(14),
        vertical: getProportionateScreenWidth(8),
      ),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: getProportionateScreenWidth(8),
                  left: getProportionateScreenWidth(12)),
              child: Text(
                "Ticket's Job Details",
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Divider(),
            _RowSerialNumber,
            //_RowEquipmentLocation,
            //_RowEquipmentUser,
            SizedBox(
              height: SizeConfig.screenHeight * 0.015,
            )
          ],
        ),
      ),
    );
  }

}

