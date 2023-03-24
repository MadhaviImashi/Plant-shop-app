import 'package:cloud_firestore/cloud_firestore.dart';

class Plant {
  final String id; // Add this property to store the document ID
  final String name;
  final int price;
  final int count;
  final String imageUrl;
  final String description;

  const Plant({
    required this.id,
    required this.name,
    required this.price,
    required this.count,
    required this.imageUrl,
    required this.description,
  });

  static Plant fromSnapshot(DocumentSnapshot snap) {
    Plant plant = Plant(
      id: snap.id, // Set the ID property from the document ID
      name: snap['name'],
      price: snap['price'],
      count: snap['count'],
      imageUrl: snap['imageUrl'],
      description: snap['description'],
    );
    return plant;
  }

  static Future<List<Plant>> getPlantsFromFirebase(String? uid) async {
    List<Plant> plants = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Carts')
        .doc(uid)
        .collection('Plants')
        .get();
    querySnapshot.docs.forEach((doc) {
      Plant plant = Plant.fromSnapshot(doc);
      plants.add(plant);
    });
    return plants;
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';

// class Plant {
//   // Product's variables: name, price, imageUrl. All required.
//   final String name;
//   final double price;
//   final String imageUrl;
//   final String description;

//   const Plant({
//     required this.name,
//     required this.price,
//     required this.imageUrl,
//     required this.description
//   });

//   static Plant fromSnapshot(DocumentSnapshot snap) {
//     Plant plant = Plant(
//       name: snap['name'],
//       price: snap['price'],
//       imageUrl: snap['imageUrl'],
//       description: snap['description']
//     );
//     return plant;
//   }

//   static const List<Plant> plant = [
//     Plant(
//         name: 'Clementine',
//         price: 10,
//         imageUrl:
//             'https://images.unsplash.com/photo-1547575824-440930b53b4d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80',
//         description:'Herbal Plant'),
//     Plant(
//         name: 'Magnolia',
//         price: 20,
//         imageUrl:
//             'https://images.unsplash.com/photo-1564376050608-34550cab6ccc?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=509&q=80',
//       description:'Herbal Plant'),
//     Plant(
//         name: 'Amaryllis',
//         price: 30,
//         imageUrl:
//             'https://images.unsplash.com/photo-1580724780403-2398394b5cd3?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=881&q=80',
//      description:'Herbal Plant'),
//      Plant(
//         name: 'Hazel',
//         price: 40,
//         imageUrl:
//             'https://images.unsplash.com/photo-1509223197845-458d87318791?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=949&q=80',
//       description:'Herbal Plant'),
//     Plant(
//         name: 'Lavender',
//         price: 50,
//         imageUrl:
//             'https://images.unsplash.com/photo-1532009871151-e1958667c80d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
//     description:'Herbal Plant'),
//   ];
// }
