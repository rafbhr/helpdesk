import 'package:flutter/material.dart';
import '/Data/ProductData.dart';
import '/OdooApiCall_DataMapping/SupportTicketandResPartner.dart';
import '/OdooApiCall_DataMapping/ToCheckIn_ToCheckOut_SupportTicket.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';
import '/widgets/MyCustomStepperHafiz.dart' as MyCustomStepper;
import '/util/Util.dart';

class TicketDetailScreen extends StatefulWidget {
  TicketDetailScreen(this.supportticket, this.respartner_id);

  //final SupportTicketResPartner supportticket;
  final ToCheckInOutSupportTicket supportticket;
  final respartner_id;

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  TextStyle orderStatusInfoTextStyle = TextStyle(
    fontSize: 11,
    fontFamily: poppinsFont,
    color: Colors.black.withOpacity(0.6),
  );

  double rowLineHeight = 8.0;

  @override
  Widget build(BuildContext context) {
    PreferredSize buildAppBar(BuildContext context, String title,
        {VoidCallback? onBackPress}) {
      return PreferredSize(
        preferredSize:
            Size.fromHeight(kToolbarHeight), // Set the height as needed
        child: AppBar(
            // Your AppBar code here
            ),
      );
    }

    return Scaffold(
      backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
      appBar: buildAppBar(context, 'Details', onBackPress: () {
        Navigator.pop(context);
      }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //buildDeliveryExpectCard(),
              buildStepper(),
              buildDetailScreen(),
              //buildHomeAddress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStepper() {
    List<MyCustomStepper.Step> orderSteps = [];
    int currentStep = 0;

    if (widget.supportticket.open_case != '') {
      orderSteps.add(MyCustomStepper.Step(
        title: Text(
          'Case Opened',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.filledCircle,
        subtitle: Text(
          widget.supportticket.open_case,
          style: Theme.of(context).textTheme.caption,
        ),
        content: Container(),
      ));
      currentStep++;
    }

    if (widget.supportticket.created_date != '') {
      orderSteps.add(MyCustomStepper.Step(
        title: Text(
          'Ticket Created',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.created,
        subtitle: Text(
          widget.supportticket.created_date,
          style: Theme.of(context).textTheme.caption,
        ),
        content: Container(),
      ));
      currentStep++;
    }

    if (widget.supportticket.check_in != '') {
      orderSteps.add(MyCustomStepper.Step(
        title: Text(
          'Technician Checked In',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.engineer_arrived,
        subtitle: Text(
          widget.supportticket.check_in,
          style: Theme.of(context).textTheme.caption,
        ),
        content: Container(),
      ));
      currentStep++;
    }

    if (widget.supportticket.check_out != '') {
      orderSteps.add(MyCustomStepper.Step(
        title: Text(
          'Technician Checked Out',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.complete,
        subtitle: Text(
          widget.supportticket.check_out,
          style: Theme.of(context).textTheme.caption,
        ),
        content: Container(),
      ));
      currentStep++;
    }

    if (widget.supportticket.close_comment != '') {
      orderSteps.add(MyCustomStepper.Step(
        title: Text(
          'Case Closed',
          style: Theme
              .of(context)
              .textTheme
              .subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.emptyCircle,
        subtitle: Container(),
        content: Container(),
      ));
      currentStep++;
    }


    return Theme(
      data: ThemeData(
        primaryColor: primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          elevation: 2,
          color: isDarkMode(context) ? darkGreyColor : Colors.white,
          shadowColor: Colors.grey.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: MyCustomStepper.MyCustomStepperHafiz(
            physics: ClampingScrollPhysics(),
            steps: orderSteps,
            currentStep: currentStep - 1, // subtract one because index starts from zero
            controlsBuilder:
                (BuildContext context, ControlsDetails controls) => Container(),
            key: UniqueKey(),
            onStepTapped: (int value) {},
            controls: ControlsDetails(
                currentStep: 0,
                stepIndex: 0), // Provide a valid ControlsDetails object here
          ),
        ),
      ),
    );
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
            child: widget.supportticket.itemname != null
                ? Text(
                    widget.supportticket.itemname,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                    softWrap: true,
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );

    var _RowEquipmentLocation = Row(
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
            child: widget.supportticket.equipment_location != ''
                ? Text(
                    widget.supportticket.equipment_location,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                    softWrap: true,
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );

    var _RowEquipmentUser = Row(
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
            child: widget.supportticket.equipment_user != ''
                ? Text(
                    widget.supportticket.equipment_user,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                    softWrap: true,
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );

    var _RowReportedBy = Row(
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
            child: widget.supportticket.reported_by != ''
                ? Text(
                    widget.supportticket.reported_by,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                    softWrap: true,
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );

    var _RowContactNumber = Row(
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
            child: widget.supportticket.contact_num != ''
                ? Text(
                    widget.supportticket.contact_num,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                    softWrap: true,
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );

    var _RowEmail = Row(
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
            child: widget.supportticket.email != ''
                ? Text(
                    widget.supportticket.email,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                    softWrap: true,
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );

    var _RowDepartment = Row(
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
            child: widget.supportticket.department != ''
                ? Text(
                    widget.supportticket.department,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                    softWrap: true,
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );

    var _RowAddress = Row(
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
            child: widget.supportticket.address != ''
                ? Text(
                    widget.supportticket.address,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                    softWrap: true,
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );

    var _RowCategory = Row(
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
            child: widget.supportticket.category_name != ''
                ? Text(
                    widget.supportticket.category_name,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                    softWrap: true,
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );

    var _RowSubCategory = Row(
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
            child: widget.supportticket.subcategory_name != ''
                ? Text(
                    widget.supportticket.subcategory_name,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                    softWrap: true,
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );

    var _RowProblem = Row(
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
            child: widget.supportticket.problem_name != ''
                ? Text(
                    widget.supportticket.problem_name,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                    softWrap: true,
                  )
                : const SizedBox(height: 0),
          ),
        ),
      ],
    );

    var _RowPriority = Row(
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
            child: widget.supportticket.problem_name != ''
                ? Text(
                    widget.supportticket.problem_name,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                    softWrap: true,
                  )
                : const SizedBox(height: 0),
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
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold),
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

  Widget buildBottomPart() {
    return Container(
      child: buildButton(
        'Continue Shopping',
        true,
        isDarkMode(context) ? primaryColorDark : primaryColor,
        isDarkMode(context) ? Colors.white.withOpacity(0.8) : Colors.white,
        2,
        2,
        8,
        onPressed: () {
          navigateHomeScreen(context);
        },
      ),
    );
  }
}
