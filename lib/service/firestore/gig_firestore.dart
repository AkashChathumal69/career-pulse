import 'package:career_pulse/model/gig_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Gig_firestote_function {
  Future<void> addGig(GigModel gigModel , BuildContext context) async {
    try {
      //create gig in Firestore
      final gigRef =
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('gig')
              .doc();

      await gigRef.set(gigModel.toMap());
      // Show success message after gig creation
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gig created successfully')));
    } catch (e) {
      print('Error adding gig: $e');
    }
  }


  Future<List<GigModel>> getGigs() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('gig')
          .get();

      return snapshot.docs.map((doc) => GigModel.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error fetching gigs: $e');
      return [];
    }
  }
  Future<void> deleteGig(String gigId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('gig')
          .doc(gigId)
          .delete();
    } catch (e) {
      print('Error deleting gig: $e');
    }
  }

  Future<GigModel?> getGigById( String userId , String gigId ) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId!)
          .collection('gig')
          .doc(gigId)
          .get();

      if (doc.exists) {
        return GigModel.fromMap(doc.data()!);
      } else {
        print('Gig not found');
        return null;
      }
    } catch (e) {
      print('Error fetching gig: $e');
      return null;
    }
  }	
}
