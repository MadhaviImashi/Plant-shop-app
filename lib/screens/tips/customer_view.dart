import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Display tips list
// class TipList extends StatefulWidget {
//   const TipList({super.key});
//   @override
//   State<TipList> createState() => TipListState();
// }

class CustomerTipHome extends StatefulWidget {
  const CustomerTipHome({super.key});
  @override
  State<CustomerTipHome> createState() => _CustomerTipHomeState();
}

class _CustomerTipHomeState extends State<CustomerTipHome> {
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tips"),
        ),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: fireStore.collection('Tips').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('No tips to display');
              } else {
                return ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    Color tipColor = const Color.fromARGB(255, 82, 243, 33);

                    return Container(
                      height: 80,
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color.fromARGB(255, 177, 224, 201),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5.0,
                            offset:
                                Offset(0, 5), // shadow direction: bottom right
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          alignment: Alignment.center,
                          child: Image.network(data['img'], fit: BoxFit.fill),
                        ),
                        title: Text(data['name'],
                            style: const TextStyle(fontSize: 16)),
                        // subtitle: Text(data['description']),
                        subtitle: Container(
                          child: (Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(data['description'],
                                  style: const TextStyle(fontSize: 14)),
                              Text(data['type']),
                            ],
                          )),
                        ),

                        isThreeLine: true,
                        dense: true,
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ));
  }
}
