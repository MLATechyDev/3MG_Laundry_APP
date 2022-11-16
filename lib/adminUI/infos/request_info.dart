import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RequestInfo extends StatefulWidget {
  String name, id, status, date, time;
  String contactnumber, address, schedule;
  String dataLaundryCost, dataCharge, dataTotal, uid;
  RequestInfo({
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
    this.uid = '',
  });

  @override
  State<RequestInfo> createState() => _RequestInfoState();
}

class _RequestInfoState extends State<RequestInfo> {
  final laudryCostTEC = TextEditingController();
  final chargeTEC = TextEditingController();
  var totalCharge = TextEditingController();
  final messageTEC = TextEditingController();
  final getDate = DateTime.now();

  int cost = 0;
  int charge = 0;

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
        actions: [
          sendMessage(),
        ],
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailText(
                            'Status:', widget.status.toUpperCase(), 16, 20),
                        const SizedBox(
                          width: 30,
                        ),
                        detailText(widget.time, widget.date, 16, 10)
                      ],
                    ),
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
            widget.status == 'sort'
                ? toPay()
                : widget.status == 'pending'
                    ? Container()
                    : widget.status == 'accepted'
                        ? Container()
                        : paymentInfo(),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: widget.status == 'pending'
                  ? btnAccept()
                  : widget.status == 'accepted'
                      ? btnToCollect()
                      : widget.status == 'completed'
                          ? btnLaundryCollected()
                          : btnDone(),
            )
          ],
        ),
      ),
    );
  }

  Widget sendMessage() => IconButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 600,
                  child: Column(
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 10, bottom: 5),
                          child: Text(
                            'SEND MESSAGE TO CUSTOMER',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: messageTEC,
                          maxLines: 5,
                          maxLength: 200,
                          decoration: InputDecoration(
                              labelText: 'Message',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: ()  {
                            final docUser = FirebaseFirestore.instance
                                .collection('adminMessage')
                                .doc();
                             docUser.set({
                              'isRead':'notread',
                              'uid': widget.uid,
                              'id': docUser.id,
                              'message': messageTEC.text,
                              'time': DateFormat('hh:mm a').format(getDate).toString(),
                              'date': DateFormat('yyyy-MM-dd').format(getDate).toString(),
                            });
                            
                            Fluttertoast.showToast(msg: 'Message sent');
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Send Message',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          )),
                    ],
                  ),
                );
              });
        },
        icon: Icon(Icons.message),
      );

      
  Widget paymentInfo() {
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
          detailText('TOTAL:', widget.dataTotal, 15, 20)
        ],
      ),
    );
  }

  Widget toPay() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      color: Colors.red[100],
      height: 200,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'PAYMENT INFO',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: const [
                    Text(
                      'LAUNDRY COST: ',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'CHARGE: ',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'TOTAL: ',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      width: 100,
                      height: 35,
                      child: TextFormField(
                        controller: laudryCostTEC,
                        onChanged: (value) {
                          setState(() {
                            cost = 0 + int.parse(value);
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      width: 100,
                      height: 35,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            charge = 0 + int.parse(value);
                          });
                        },
                        controller: chargeTEC,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      width: 100,
                      height: 35,
                      child: TextFormField(
                        enabled: false,
                        controller: totalCharge,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    totalCharge.text = (cost + charge).toString();
                  });
                },
                child: const Text('Compute'))
          ],
        ),
      ),
    );
  }

  Widget btnLaundryCollected() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 40), primary: Colors.lightBlue),
        onPressed: () {
          final docUser = FirebaseFirestore.instance
              .collection('customerDetails')
              .doc(widget.id);

          docUser.delete();

          Navigator.pop(context);
        },
        child: const Text('LAUNDRY COLLECTED'));
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
            'status': widget.status == 'sort'
                ? 'wash'
                : widget.status == 'wash'
                    ? 'dry'
                    : widget.status == 'dry'
                        ? 'fold'
                        : 'complete',
            'time': DateFormat('hh:mm a').format(getDate).toString(),
            'date': DateFormat('yyyy-MM-dd').format(getDate).toString(),
          });
          if (widget.status == 'sort') {
            docUser.set({
              'laundryCost': laudryCostTEC.text,
              'charge': chargeTEC.text,
              'total': totalCharge.text,
            }, SetOptions(merge: true)).then((value) {
              // Do your stuff.
            });
          }

          Navigator.pop(context);
        },
        child: const Text('DONE'));
  }

  Widget btnAccept() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 40), primary: Colors.lightBlue),
        onPressed: () {
          final docUser = FirebaseFirestore.instance
              .collection('customerDetails')
              .doc(widget.id);

          docUser.update({
            'status': widget.schedule == 'pickup' ? 'accepted' : 'sort',
            'time': DateFormat('hh:mm a').format(getDate).toString(),
            'date': DateFormat('yyyy-MM-dd').format(getDate).toString(),
          });

          Navigator.pop(context);
        },
        child: const Text('ACCEPT'));
  }

  Widget btnToCollect() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 40), primary: Colors.lightBlue),
        onPressed: () {
          final docUser = FirebaseFirestore.instance
              .collection('customerDetails')
              .doc(widget.id);

          docUser.update({
            'status': 'sort',
            'time': DateFormat('hh:mm a').format(getDate).toString(),
            'date': DateFormat('yyyy-MM-dd').format(getDate).toString(),
          });

          Navigator.pop(context);
        },
        child: const Text('COLLECTED'));
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
