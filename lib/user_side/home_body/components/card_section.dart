import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:out_app/user_side/home_body/components/close_section.dart';

import 'card.dart';

class HomeCardSection extends StatelessWidget {
  const HomeCardSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference restaurants =
        FirebaseFirestore.instance.collection('Restaurants');

    return FutureBuilder<QuerySnapshot>(
      future: restaurants.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("An error occurred.");
        }

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<QueryDocumentSnapshot> data = snapshot.data!.docs;

          return HomeCloseSection(
            restaurants: data,
          );
        }
        return SizedBox(
            height: 203.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(10, (int index) {
                return const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 0, 5, 0),
                    child: RestaurantCard(
                      title: "Loading...",
                      tables: 0,
                      opened: false,
                      price: 1,
                      type: "Loading...",
                      rating: 5,
                      distance: "1 km",
                      restaurantID: 'e',
                      fileName: '',
                      location: null,
                    ));
              }),
            ));
      },
    );
  }
}
