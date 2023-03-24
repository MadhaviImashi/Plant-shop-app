import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///display plants list
class PlantCard extends StatefulWidget {
  const PlantCard({
    required this.user,
    super.key,
  });
  final String user;
  @override
  State<PlantCard> createState() => PlantCardState();
}

class PlantCardState extends State<PlantCard> {
  final fireStore = FirebaseFirestore.instance;
  late String uid = widget.user;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection('Plants').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('No Plant to display');
          } else {
            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          data['img'],
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          data['name'],
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: Text(
                          data['price'],
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(data['description']),
                      ),
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 20)),
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF58AF8B),
                                foregroundColor: Colors.white),
                            onPressed: () async {
                           
                              var docRef = FirebaseFirestore.instance
                                  .collection('Carts')
                                  .doc(uid)
                                  .collection('Plants')
                                  .doc(document.id);

                              await docRef.set({
                                'name': data['name'],
                                'description': data['description'],
                                'imageUrl': data['img'],
                                'price': int.parse(data['price']),
                                'count': 0
                              });
                            },
                            child: const Text("Add To Cart"),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 20)),
                          IconButton(
                            icon: const Icon(Icons.favorite),
                            splashColor: Colors.red,
                            color: const Color.fromARGB(255, 243, 4, 143),
                            tooltip: 'Add to wishlist',
                            onPressed: () async {
                              CollectionReference<Map<String, dynamic>>
                                  wishlistRef = FirebaseFirestore.instance
                                      .collection('wishlist')
                                      .doc(uid)
                                      .collection('items');

                              await wishlistRef.add({
                                'name': data['name'],
                                'imageUrl': data['img'],
                                'price': data['price']
                              });
                            },
                          )
                        ],
                      )
                    ],
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
