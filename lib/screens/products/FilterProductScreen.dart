import 'package:flutter/material.dart';
import '/Data/filter_products.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/util/Util.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';

class FilterProductScreen extends StatefulWidget {
  @override
  _FilterProductScreenState createState() => _FilterProductScreenState();
}

class _FilterProductScreenState extends State<FilterProductScreen> {
  TextEditingController searchController = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  bool isSelected = false;
  String dropdownValue = 'Relevance';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      // appBar: buildAppBar(context, filter, onBackPress: () {
      //   Navigator.pop(context);
      // }),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 16),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        sortByLabel,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildDropDown(sortFilters),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        categoryLabel,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildFilterChip(categoryFilters, categoryFilterSelected),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          height:  getProportionateScreenWidth(56),
          alignment: Alignment.center,
          child: buildBottomButton(),
        ),
      ),
    );
  }

  Widget buildDropDown(List<String> value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: primaryColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton(
        value: dropdownValue,
        items: value.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          },
        ).toList(),
        dropdownColor: isDarkMode(context) ? Colors.grey[800] : Colors.white,
        iconSize: 24,
        elevation: 16,
        style: Theme.of(context).textTheme.bodyText1,
        icon: Icon(
          Icons.arrow_drop_down,
          color: isDarkMode(context) ? Colors.white70 :Theme.of(context).textTheme.bodyText1?.color,
        ),
        underline: Container(),
        onChanged: (value) {
          setState(
            () {
              dropdownValue = value.toString();
            },
          );
        },
      ),
    );
  }

  Widget buildFilterChip(List<String> filterTitles, List<bool> _selected) {
    List<Widget> chips = [];

    for (int i = 0; i < filterTitles.length; i++) {
      FilterChip filterChip = FilterChip(
        elevation: 0,
        label: Text(
          filterTitles[i],
          style: TextStyle(
            fontSize: 12,
            color: _selected[i]
                ? isDarkMode(context)
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white
                : isDarkMode(context)
                    ? Colors.white70
                    : Colors.black,
            fontFamily: poppinsFont,
          ),
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: primaryColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        avatar: !_selected[i]
            ? Icon(
                Icons.add,
                color: _selected[i] ? Colors.white : primaryColor,
              )
            : null,
        selected: _selected[i],
        selectedColor: _selected[i]
            ? isDarkMode(context)
                ? primaryColorDark
                : primaryColor
            : Colors.transparent,
        showCheckmark: false,
        onSelected: (bool selected) {
          setState(
            () {
              _selected[i] = selected;
            },
          );
        },
      );

      chips.add(
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: filterChip,
        ),
      );
    }

    return Wrap(
      children: chips,
    );
  }

  Widget buildBottomButton() {
    return Container(
      child: buildButton(
        applyFilterLabel,
        true,
        isDarkMode(context) ? primaryColorDark : primaryColor,
        isDarkMode(context) ? Colors.white.withOpacity(0.8) : Colors.white,
        2,
        2,
        8,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
