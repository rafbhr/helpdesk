import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/colors/Colors.dart';
import '/util/Util.dart';

Widget AnimatedContainers(context){

  return AnimatedContainer(
    
    curve: Curves.fastLinearToSlowEaseIn,
    duration: const Duration(microseconds: 1),  //set lowest because we dont want unnecessary delay, cannot set as null because 'duration' is a required element of animatedcontainer.
    child: Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular (20),
    ),
    
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children:[
          Center(
            
            child: GestureDetector(
              /*onTap: (){
              Navigator.pop(context);
              },
              */
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  //color: Theme.of(context).backgroundColor,
                  color: isDarkMode(context) ? Colors.white: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow:[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 10)
                    )
                  ]
                ),
                child: Center(
                  child: SpinKitCubeGrid(
                    //color: Theme.of(context).hoverColor,
                    //color: Colors.blue,
                    color: isDarkMode(context) ? Colors.black : Colors.blue,
                    size: 80,
                  )
    
                ),
              ),
            )
          )
        ]
      )
    )
  );
 
}
