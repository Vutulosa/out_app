import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:out_app/business_side/booking_view_screen/components/screen_user_header.dart';
import 'package:out_app/shared/shared_components/button.dart';
import 'package:out_app/shared/shared_components/out_snackbar.dart';
import 'package:out_app/user_side/restaurant_screen/components/stamps_section.dart';

import 'components/screen_back_button.dart';

class BusBookingViewScreen extends StatelessWidget {
  const BusBookingViewScreen(
      {Key? key,
      required this.restaurantID,
      required this.userID,
      required this.userEmail})
      : super(key: key);
  final String restaurantID;
  final String userID;
  final String userEmail;

  void giveStamp() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .collection('stamps')
        .doc(restaurantID)
        .update({'stamps': FieldValue.increment(1)}).onError(
            (error, stackTrace) => FirebaseFirestore.instance
                .collection('Users')
                .doc(userID)
                .collection('stamps')
                .doc(restaurantID)
                .set({'stamps': FieldValue.increment(1)}));
  }

  void addPastBooking() {
    FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(restaurantID)
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .collection('bookings')
          .add({
        'date': DateTime.now(),
        'restaurantID': restaurantID,
        'image': value['image'],
        'rating': value['rating'],
        'name': value['name'],
        'type': value['type']
      });
    });
  }

  void removeCurrentBooking() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .update({'booking': ''});
    var list = [userID];
    FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(restaurantID)
        .update({'bookings': FieldValue.arrayRemove(list)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFBFF),
        body: ListView(
          children: [
            const ScreenBackButton(),
            ScreenUserHeader(userEmail: userEmail),
            OutStampsSection(
                restaurantID: restaurantID,
                stampsAlignment: MainAxisAlignment.spaceAround,
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                textAlignment: MainAxisAlignment.center,
                userID: userID),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: ElevatedButton(
                    onPressed: () async {
                      showCupertinoDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return AlertDialog(
                                title: const Center(
                                    child: Text(
                                  'Close Booking',
                                )),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Go Back',
                                        style: TextStyle(
                                            color: (Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        outSnackbar('Closed Booking', context);
                                        removeCurrentBooking();
                                        addPastBooking();
                                      },
                                      child: Text(
                                        'Close Booking',
                                        style: TextStyle(
                                            color: (Theme.of(context)
                                                .colorScheme
                                                .error)),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        outSnackbar(
                                            'Gave a stamp and closed booking',
                                            context);
                                        giveStamp();
                                        removeCurrentBooking();
                                        addPastBooking();
                                      },
                                      child: const Text(
                                        'Give Stamp and Close',
                                        style: TextStyle(color: (Colors.green)),
                                      )),
                                ],
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))));
                          });
                    },
                    child: const Text('Close Booking'),
                    style: getOutButtonStyle(Colors.green).merge(ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(180, 50)))),
                  ),
                )
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () async {
                      outSnackbar('Reseted Stamps', context);
                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(userID)
                          .collection('stamps')
                          .doc(restaurantID)
                          .set({'stamps': 0}).onError((error, stackTrace) =>
                              outSnackbar('Error occured', context));
                    },
                    child: const Text('Redeem Stamps'),
                    style: getOutButtonStyle(Colors.amber).merge(ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(180, 50)))),
                  ),
                )
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return AlertDialog(
                                title: const Center(
                                    child: Text(
                                  'Cancel Booking',
                                )),
                                content: const Text(
                                    'Are you sure you want to cancel the booking?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Go Back')),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        outSnackbar(
                                            'Cancelled Booking', context);
                                        removeCurrentBooking();
                                      },
                                      child: Text(
                                        'Cancel Booking',
                                        style: TextStyle(
                                            color: (Theme.of(context)
                                                .colorScheme
                                                .error)),
                                      )),
                                ],
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))));
                          });
                    },
                    child: const Text('Cancel Booking'),
                    style:
                        getOutButtonStyle(Theme.of(context).colorScheme.error)
                            .merge(ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(180, 50)))),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

void giveStamp() {}
