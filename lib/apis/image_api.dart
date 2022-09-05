import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageApi{
  static Future uploadFileToFirebase(BuildContext context,File imageFile,String documentId) async {

    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('media/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value)async {
      print("audio message : $value");
      await FirebaseFirestore.instance.collection('social_chat').doc(documentId).update({
        "message":value,
      });
    });
  }
}