import 'package:diabetes_readings_history/reading_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  DateTime? date;
  TimeOfDay? time;
  String savedDate = '';
  String savedTime = '';
  late List<ReadingItem> readings = [];
  late List<dynamic> newValues;
  FeedingState? _state = FeedingState.fasting;

  bool showDialog = false;

  // late List<String> values;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  void addReading(ReadingItem readingItem) async {
    readings.add(readingItem);
    await Hive.box('newBox').put('values', readings);
  }

  void deleteReading(int index) async {
    readings.removeAt(index);
    await Hive.box('newBox').put('values', readings);
  }

  @override
  void initState() {
    // print(Hive.box('newBox').get('values'));
    newValues = Hive.box('newBox').get('values') ?? [];
    // readings = newValues;
    // print(newValues);
    newValues.forEach((value) {
      // print(value);
      readings.add(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diabetes Reading\'s History',
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            itemCount: readings.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: UniqueKey(),
                background: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onDismissed: (DismissDirection direction) {
                  deleteReading(readings.length - (index + 1));
                  setState(() {});
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 35,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 90,
                            height: 90,
                            child: Text(
                              '${readings[readings.length - (index + 1)].reading}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${readings[readings.length - (index + 1)].time}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${readings[readings.length - (index + 1)].date}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: readings[readings.length - (index + 1)]
                                        .feedingState ==
                                    'صائم'
                                ? Colors.yellow
                                : Colors.green),
                        child: Text(
                          readings[readings.length - (index + 1)].feedingState,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Colors.black54,
                thickness: 2,
                height: 15,
              );
            },
          ),
          showDialog
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.5),
                  child: AlertDialog(
                    elevation: 0,
                    title: Text(
                      'Enter Your Reading value',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    content: Container(
                      width: 250,
                      height: 350,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Form(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextFormField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 22),
                                autofocus: true,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text('فاطر'),
                                    leading: Radio<FeedingState>(
                                      value: FeedingState.wellFed,
                                      groupValue: _state,
                                      onChanged: (FeedingState? value) {
                                        print(_state);
                                        setState(() {
                                          _state = value;
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text('صائم'),
                                    leading: Radio<FeedingState>(
                                      value: FeedingState.fasting,
                                      groupValue: _state,
                                      onChanged: (FeedingState? value) {
                                        print(_state);
                                        setState(() {
                                          _state = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              MaterialButton(
                                color: Colors.blue,
                                elevation: 0,
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.date_range,
                                      color: Colors.white,
                                    ),
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Change\n Date & Time',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ],
                                ),
                                onPressed: () async {
                                  date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2021),
                                          lastDate: DateTime.now()) ??
                                      DateTime.now();

                                  savedDate =
                                      '${date!.month}/${date!.day}/${date!.year}';

                                  print(savedDate);

                                  time = await showTimePicker(
                                        context: context,
                                        initialTime:
                                            TimeOfDay(hour: 12, minute: 0),
                                      ) ??
                                      TimeOfDay.now();

                                  savedTime =
                                      '${time!.hour > 12 ? time!.hour - 12 : time!.hour}:${time!.minute < 10 ? "0${time!.minute}" : time!.minute} ${time!.hour > 12 ? "PM" : "AM"}';

                                  print(savedTime);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              showDialog = false;
                              controller.text = '';
                              setState(() {});
                            },
                            color: Colors.blue,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (savedTime == '') {
                                savedTime =
                                    '${DateTime.now().hour > 12 ? DateTime.now().hour - 12 : DateTime.now().hour}:${DateTime.now().minute < 10 ? "0${DateTime.now().minute}" : DateTime.now().minute} ${DateTime.now().hour > 12 ? "PM" : "AM"}';
                              }
                              if (savedDate == '') {
                                savedDate =
                                    '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';
                              }
                              if (controller.text != '') {
                                addReading(
                                  ReadingItem(
                                    reading: int.parse(controller.text),
                                    time: savedTime,
                                    date: savedDate,
                                    feedingState: _state == FeedingState.fasting
                                        ? 'صائم'
                                        : 'فاطر',
                                  ),
                                );
                                controller.text = '';
                                showDialog = false;
                              }

                              setState(() {});
                            },
                            color: Colors.blue,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  width: 0,
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog = true;
          setState(() {});
        },
      ),
    );
  }
}

// if ('${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour - 12}:${DateTime.now().minute}' ==
//     '2021-10-27 8:15') {
//   await Hive.box('newBox').put(
//     'values',
//     [
//       ReadingItem(
//           reading: 126,
//           time: '6:12 AM',
//           date: '10/27/2021',
//           feedingState: 'صائم'),
//       ReadingItem(
//           reading: 100,
//           time: '5:20 AM',
//           date: '10/26/2021',
//           feedingState: 'صائم'),
//     ],
//   );
// }
