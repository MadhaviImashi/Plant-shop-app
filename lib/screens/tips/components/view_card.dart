import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../update_Tips.dart';

//Display tips list
class TipList extends StatefulWidget {
  const TipList({super.key});
  @override
  State<TipList> createState() => TipListState();
}

class TipListState extends State<TipList> {
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection('Tips').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('No tips to display');
          } else {
            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                Color plantColor = const Color.fromARGB(255, 82, 243, 33);

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
                        offset: Offset(0, 5), // shadow direction: bottom right
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 20,
                      height: 20,
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: plantColor,
                      ),
                    ),
                    title: Text(data['name']),
                    subtitle: Text(data['type']),
                    isThreeLine: true,
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            onTap: () => Future(
                             
                              ()=>Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateTips(
                                          id: document.id,
                                          name: data['name'],
                                          url: data['img'],
                                          type: data['type'],
                                          description: data['description'])))
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: const Text(
                              'Delete',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            onTap: () {
                              delete(document.id);
                            },
                          ),
                        ];
                      },
                    ),
                    dense: true,
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

//delete  tip
void delete(String tipId) async {
  var collection = FirebaseFirestore.instance.collection('Tips');
  collection.doc(tipId).delete();
}
