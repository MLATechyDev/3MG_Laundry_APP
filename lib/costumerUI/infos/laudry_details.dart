import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class LaundryDetails extends StatefulWidget {
  String name, id, status, date, time;
  String contactnumber, address, schedule;
  String dataLaundryCost, dataCharge, dataTotal;
  String whenCompletethis;
  LaundryDetails({
    Key? key,
    this.name = '',
    this.address = '',
    this.contactnumber = '',
    this.date = '',
    this.id = '',
    this.schedule = '',
    this.status = '',
    this.time = '',
    this.dataLaundryCost = '',
    this.dataCharge = '',
    this.dataTotal = '',
    this.whenCompletethis = '',
  });

  @override
  State<LaundryDetails> createState() => _LaundryDetailsState();
}

class _LaundryDetailsState extends State<LaundryDetails> {
  final laudryCostTEC = TextEditingController();
  final chargeTEC = TextEditingController();
  var totalCharge = TextEditingController();

  final getDate = DateTime.now();

  int cost = 0;
  int charge = 0;
  String whenComplete = 'null';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'LAUNDRY INFO',
          style: GoogleFonts.merriweather(
            textStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              color: Colors.teal.shade100,
              height: 200,
              child: Column(
                children: [
                  Row(
                    children: [
                      detailText(
                          'Status:', widget.status.toUpperCase(), 17, 20),
                      const SizedBox(
                        width: 30,
                      ),
                      detailText(widget.time, widget.date, 17, 10)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  detailText('Laundry ID:', widget.id, 16, 20),
                  detailText('NAME:', widget.name.toUpperCase(), 16, 20),
                  detailText('ADDRESS:', widget.address, 14, 20),
                  detailText('CONTACT NUMBER:',
                      widget.contactnumber.toUpperCase(), 14, 20),
                  const SizedBox(
                    height: 10,
                  ),
                  detailText(
                      'Schedule: ',
                      widget.schedule == 'dropoff' ? 'DROP-OFF' : 'PICK-UP',
                      14,
                      20)
                ],
              ),
            ),
            widget.status == 'complete' ? paymentInfo() : Container(),
            widget.status != 'pending' ? payInfo() : Container(),
            const SizedBox(
              height: 30,
            ),
            widget.status == 'complete' ? btnDone() : Container(),
          ],
        ),
      ),
    );
  }

  Widget paymentInfo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      color: Colors.red[100],
      height: 300,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'PAYMENT INFO',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          detailText('LAUDRY COST:', widget.dataLaundryCost, 15, 20),
          detailText('CHARGE COST:', widget.dataCharge, 15, 20),
          detailText('TOTAL:', widget.dataTotal, 15, 20),
          const SizedBox(
            height: 10,
          ),
          const Text(
            '(Select Recieve Status)',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    'PICK-UP',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        whenComplete = 'pickup';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: whenComplete == 'pickup'
                            ? Colors.teal[200]
                            : Colors.white,
                        border: const Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          top: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          left: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          right: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                      ),
                      height: 70,
                      width: 100,
                      child: Image.asset(
                        'assets/drop-off.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  const Text(
                    'DELIVER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        whenComplete = 'deliver';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: whenComplete == 'deliver'
                            ? Colors.teal[200]
                            : Colors.white,
                        border: const Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          top: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          left: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          right: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                      ),
                      height: 70,
                      width: 100,
                      child: Image.asset(
                        'assets/pickup.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget payInfo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      color: Colors.red[100],
      height: 200,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'PAYMENT INFO',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          detailText('LAUNDRY COST:', widget.dataLaundryCost, 15, 20),
          detailText('CHARGE COST:', widget.dataCharge, 15, 20),
          detailText('TOTAL:', widget.dataTotal, 15, 20),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.whenCompletethis == 'pickup'
                ? 'You can now pick-up your laundry'
                : widget.whenCompletethis == 'deliver'
                    ? 'Waiting to deliver'
                    : '',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget btnDone() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 40), primary: Colors.lightBlue),
        onPressed: () {
          final docUser = FirebaseFirestore.instance
              .collection('customerDetails')
              .doc(widget.id);

          docUser.update({
            'status': 'completed',
            'time': DateFormat('hh:mm a').format(getDate).toString(),
            'date': DateFormat('yyyy-MM-dd').format(getDate).toString(),
          });

          docUser.set({
            'whenComplete': whenComplete,
          }, SetOptions(merge: true)).then((value) {
            // Do your stuff.
          });

          Navigator.pop(context);
        },
        child: const Text('DONE'));
  }

  Widget detailText(String title, String text, double fontsize, double space) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SelectableText(
              title,
              style: TextStyle(
                  fontSize: fontsize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              width: space,
            ),
            SelectableText(
              text,
              style: TextStyle(
                  fontSize: fontsize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
