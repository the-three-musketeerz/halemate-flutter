import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hale_mate/models/reminder/medicine.dart';
import 'package:hale_mate/screens/alarm/globalBloc.dart';
import 'package:hale_mate/models/reminder/Enum.dart';
import 'dart:developer' as developer;
import 'package:hale_mate/screens/alarm/alarm.dart';
import 'package:hale_mate/screens/alarm/createAlarmBlock.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NewEntry extends StatefulWidget {
  @override
  _NewEntryState createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  TextEditingController nameController;
  TextEditingController dosageController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NewEntryBloc _newEntryBloc;

  GlobalKey<ScaffoldState> _scaffoldKey;

  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  void initState() {
    super.initState();
    _newEntryBloc = NewEntryBloc();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    initializeNotifications();
    initializeErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);

    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,

        body: Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Provider<NewEntryBloc>.value(
              value: _newEntryBloc,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                children: <Widget>[
                  PanelTitle(
                    title: "Medicine Name",
                    isRequired: true,
                  ),
                  TextFormField(
                    maxLength: 12,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                      ),
                    ),
                  ),
                  PanelTitle(
                    title: "Dosage in mg",
                    isRequired: false,
                  ),
                  TextFormField(
                    controller: dosageController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  PanelTitle(
                    title: "Medicine Type",
                    isRequired: false,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: StreamBuilder<MedicineType>(
                      stream: _newEntryBloc.selectedMedicineType,
                      builder: (context, snapshot) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MedicineTypeColumn(
                                type: MedicineType.Bottle,
                                name: "Bottle",
                                source: 'assets/syrup.png',
                                isSelected: snapshot.data == MedicineType.Bottle
                                    ? true
                                    : false),
                            MedicineTypeColumn(
                                type: MedicineType.Pill,
                                name: "Pill",
                                source: 'assets/pills.png',
                                isSelected: snapshot.data == MedicineType.Pill
                                    ? true
                                    : false),
                            MedicineTypeColumn(
                                type: MedicineType.Syringe,
                                name: "Syringe",
                                source: 'assets/syringe.png',
                                isSelected: snapshot.data ==
                                    MedicineType.Syringe
                                    ? true
                                    : false),
                            MedicineTypeColumn(
                                type: MedicineType.Tablet,
                                name: "Tablet",
                                source: 'assets/tablets.png',
                                isSelected: snapshot.data == MedicineType.Tablet
                                    ? true
                                    : false),
                          ],
                        );
                      },
                    ),
                  ),
                  PanelTitle(
                    title: "Interval Selection",
                    isRequired: true,
                  ),
                  //ScheduleCheckBoxes(),
                  IntervalSelection(),
                  PanelTitle(
                    title: "Starting Time",
                    isRequired: true,
                  ),
                  SelectTime(),
                  SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(),
                    child: Container(
                      height: 50.0,
                      child: SizedBox.expand(
                          child: RaisedButton(
                            color: Colors.deepPurple,
                            child: Center(
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            onPressed: () {
                              String medicineName;
                              int dosage;
                              //--------------------Error Checking------------------------
                              //Had to do error checking in UI
                              //Due to unoptimized BLoC value-grabbing architecture
                              if (nameController.text == "") {
                                _newEntryBloc.submitError(EntryError.NameNull);
                                return;
                              }
                              if (nameController.text != "") {
                                medicineName = nameController.text;
                              }
                              if (dosageController.text == "") {
                                dosage = 0;
                              }
                              if (dosageController.text != "") {
                                dosage = int.parse(dosageController.text);
                              }
                              for (var medicine in _globalBloc.medicineList$
                                  .value) {
                                if (medicineName == medicine.medicineName) {
                                  _newEntryBloc.submitError(
                                      EntryError.NameDuplicate);
                                  return;
                                }
                              }
                              if (_newEntryBloc.selectedInterval$.value == 0) {
                                _newEntryBloc.submitError(EntryError.Interval);
                                return;
                              }
                              if (_newEntryBloc.selectedTimeOfDay$.value ==
                                  "None") {
                                _newEntryBloc.submitError(EntryError.StartTime);
                                return;
                              }
                              //---------------------------------------------------------
                              String medicineType = _newEntryBloc
                                  .selectedMedicineType.value
                                  .toString()
                                  .substring(13);
                              int interval = _newEntryBloc.selectedInterval$
                                  .value;
                              String startTime = _newEntryBloc
                                  .selectedTimeOfDay$.value;

                              List<int> intIDs =
                              makeIDs(
                                  24 / _newEntryBloc.selectedInterval$.value);
                              List<String> notificationIDs = intIDs
                                  .map((i) => i.toString())
                                  .toList(); //for Shared preference

                              Medicine newEntryMedicine = Medicine(
                                notificationIDs: notificationIDs,
                                medicineName: medicineName,
                                dosage: dosage,
                                medicineType: medicineType,
                                interval: interval,
                                startTime: startTime,
                              );

                              _globalBloc.updateMedicineList(newEntryMedicine);
                              scheduleNotification(newEntryMedicine);
                              developer.log("notif scheduled", name: "notifs");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return AlarmHomeScreen();
                                  },
                                ),
                              );
                            },
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }

  void initializeErrorListen() {
    _newEntryBloc.errorState$.listen(
          (EntryError error) {
        switch (error) {
          case EntryError.NameNull:
            displayError("Please enter the medicine's name");
            break;
          case EntryError.NameDuplicate:
            displayError("Medicine name already exists");
            break;
          case EntryError.Dosage:
            displayError("Please enter the dosage required");
            break;
          case EntryError.Interval:
            displayError("Please select the reminder's interval");
            break;
          case EntryError.StartTime:
            displayError("Please select the reminder's starting time");
            break;
          default:
        }
      },
    );
  }

  void displayError(String error) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
        duration: Duration(milliseconds: 2000),
      ),
    );
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }

  //initializing the flutter Notification plugin
  Future<void> initializeNotifications() async {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => AlarmHomeScreen()),
    );
  }

    scheduleNotification(Medicine medicine) async {
    var hour = int.parse(medicine.startTime[0] + medicine.startTime[1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime[2] + medicine.startTime[3]);


    //var scheduledNotificationDateTime = Time(17, 2, 0);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      //ledColor: Color(0xFF3EB16F),
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    for (int i = 0; i < (24 / medicine.interval).floor(); i++) {
      /*if ((hour + (medicine.interval * i) > 23)) {
        hour = hour + (medicine.interval * i) - 24;
      } else {
        hour = hour + (medicine.interval * i);
      }*/
      developer.log(medicine.notificationIDs[i].toString(), name: "notif id");
      developer.log(hour.toString() + ":" + minute.toString(), name: "notif time");


      await flutterLocalNotificationsPlugin.showDailyAtTime(
          int.parse(medicine.notificationIDs[i].toString()),
          'HaleMate: ${medicine.medicineName}',

          medicine.medicineType.toString() != MedicineType.None.toString()
              ? 'It is time to take your ${medicine.medicineType
              .toLowerCase()}, according to schedule'
              : 'It is time to take your medicine, according to schedule',

          //'notification body',
          Time(hour, minute, 0),
          platformChannelSpecifics);

      developer.log(medicine.notificationIDs[i].toString(), name: "notif id recieved");
      developer.log(hour.toString() + ":" + minute.toString(), name: "notif recieved");

      hour = ogValue;
    }
//await flutterLocalNotificationsPlugin.cancelAll();
  }

}

class IntervalSelection extends StatefulWidget {
  @override
  _IntervalSelectionState createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  var _intervals = [
    1,
    2,
    4,
    6,
    8,
    12,
    24,
  ];
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical:5.0, horizontal: 10.0),
                child: Text(
              "Remind me every  ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            )),
            DropdownButton<int>(
              iconEnabledColor: Colors.deepPurple,
              hint: _selected == 0
                  ? Text(
                "Select an Interval",
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              )
                  : null,
              elevation: 4,
              value: _selected == 0 ? null : _selected,
              items: _intervals.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _selected = newVal;
                  _newEntryBloc.updateInterval(newVal);
                });
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical:10.0, horizontal: 10.0),
                child: Text(
              _selected == 1 ? " hour" : " hours",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class SelectTime extends StatefulWidget {
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
        _newEntryBloc.updateTime("${convertTime(_time.hour.toString())}" +
            "${convertTime(_time.minute.toString())}");
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: FlatButton(
          color: Colors.deepPurpleAccent[100],
          shape: StadiumBorder(),
          onPressed: () {
            _selectTime(context);
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? "Pick Time"
                  : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  final MedicineType type;
  final String name;
  final String source;
  final bool isSelected;

  MedicineTypeColumn(
      {Key key,
        @required this.type,
        @required this.name,
        @required this.source,
        @required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    return GestureDetector(
      onTap: () {
        _newEntryBloc.updateSelectedMedicine(type);
      },
      child: Column(
        children: <Widget>[
          Container(
            width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Colors.deepPurple : Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 14.0),
                child: ImageIcon(
                  AssetImage(source),
                  size: 75,
                  color: isSelected ? Colors.white : Colors.deepPurple,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepPurple : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  final String title;
  final bool isRequired;
  PanelTitle({
    Key key,
    @required this.title,
    @required this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 10),
      child: Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
            text: title,
            style: TextStyle(
                fontSize: 14, color: Colors.black, ),
          ),
          TextSpan(
            text: isRequired ? " *" : "",
            style: TextStyle(fontSize: 14, color: Colors.deepPurple),
          ),
        ]),
      ),
    );
  }
}