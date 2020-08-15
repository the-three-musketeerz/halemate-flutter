import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Alarm/globalBloc.dart';
import 'package:hale_mate/models/reminder/medicine.dart';
import 'package:hale_mate/views/alarm/alarmDetails.dart';
import 'package:hale_mate/views/alarm/createAlarm.dart';
import 'package:provider/provider.dart';
import 'package:hale_mate/constanst.dart';


class AlarmHomeScreen extends StatefulWidget {
  @override
  _AlarmHomeScreenState createState() => _AlarmHomeScreenState();
}

class _AlarmHomeScreenState extends State<AlarmHomeScreen> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      body: Container(
        color: Color(0xFFF6F8FC),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Flexible(
              flex: 7,
              child: Provider<GlobalBloc>.value(
                child: BottomContainer(),
                value: _globalBloc,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: colorDark,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewEntry(),
            ),
          );
        },
      ),
    );
  }
}


class BottomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder<List<Medicine>>(
      stream: _globalBloc.medicineList$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.data.length == 0) {
          return Container(
              color: Color(0xFFF6F8FC),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Press + to add a Reminder for your Medications",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ));
        } else {
          return Container(
            color: Color(0xFFF6F8FC),
            child: Column(children: <Widget>[
              Container(
                child: Container(
                  height: 40.0,
                child: Text(
                  "My Reminders",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                )),
              ),
              Expanded(
                  child: GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return MedicineCard(snapshot.data[index]);
                },
              ))
            ]),
          );
        }
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  final Medicine medicine;

  MedicineCard(this.medicine);

  Hero makeIcon(double size) {
    if (medicine.medicineType == "BotLight,tle") {
      return Hero(
        tag: medicine.medicineName + medicine.medicineType,
        child: ImageIcon(
          AssetImage('assets/syrup.png'),
          color: colorLight,
          size: size,
        ),
      );
    } else if (medicine.medicineType == "Pill") {
      return Hero(
        tag: medicine.medicineName + medicine.medicineType,
        child: ImageIcon(
          AssetImage('assets/pills.png'),
          color: colorLight,
          size: size,
        ),
      );
    } else if (medicine.medicineType == "Syringe") {
      return Hero(
        tag: medicine.medicineName + medicine.medicineType,
        child: ImageIcon(
          AssetImage('assets/syringe.png'),
          color: colorLight,
          size: size,
        ),
      );
    } else if (medicine.medicineType == "Tablet") {
      return Hero(
        tag: medicine.medicineName + medicine.medicineType,
        child: ImageIcon(
          AssetImage('assets/tablets.png'),
          color: colorLight,
          size: size,
        ),
      );
    }
    return Hero(
      tag: medicine.medicineName + medicine.medicineType,
      child: Icon(
        Icons.error,
        color: Colors.red[400],
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: InkWell(
        highlightColor: Colors.white,
        splashColor: Colors.grey,
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder<Null>(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget child) {
                      return Opacity(
                        opacity: animation.value,
                        child: MedicineDetails(medicine),
                      );
                    });
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                makeIcon(50.0),
                Hero(
                  tag: medicine.medicineName,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      medicine.medicineName,
                      style: TextStyle(
                          fontSize: 22,
                          color: colorDark,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Text(
                  medicine.interval == 1
                      ? "Every " + medicine.interval.toString() + " hour"
                      : "Every " + medicine.interval.toString() + " hours",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
