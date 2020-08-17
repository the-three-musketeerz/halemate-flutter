import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hale_mate/models/help/helpData.dart';



 class HelpListView extends StatelessWidget {

   static const String id = 'Help';

   @override
   Widget build(BuildContext context) {
     return Material(
         child: ListView.builder(
         itemCount: titles.length,
         itemBuilder: (context, index) {
           return Container(
               height: 110.0,
               child: Card(
                   semanticContainer: true,
                   clipBehavior: Clip.antiAliasWithSaveLayer,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(10.0),
                   ),
                   elevation: 5,
                   margin: EdgeInsets.all(10),
                   child: Padding(
                     padding: EdgeInsets.only(top: 15.0),
                     child: ListTile(
                         leading: Icon(
                           icons[index],
                           color: iconColors[index],
                           size: 60.0,
                         ),
                         title: Text(
                           titles[index],
                           style: TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         trailing: Icon(Icons.keyboard_arrow_right),
                         onTap: () {
                           showDialog(
                               context: context,
                               builder: (BuildContext context) {
                                 return new AlertDialog(
                                   title: Text(titles[index], style: TextStyle(
                                       color: iconColors[index]
                                   ),),
                                   content: new SingleChildScrollView(
                                       child: Text(
                                         descriptions[index],
                                         textAlign: TextAlign.justify,
                                       )),
                                   actions: <Widget>[
                                     new FlatButton(
                                       onPressed: () {
                                         Navigator.of(context).pop();
                                       },
                                       textColor: Theme.of(context).primaryColor,
                                       child: const Text('Okay, got it!'),
                                     )
                                   ],
                                 );
                               });
                         }),
                   )
               )
           );
         })
     );
   }


 }


