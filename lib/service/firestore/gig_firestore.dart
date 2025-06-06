import 'package:career_pulse/model/gig_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Gig_firestote_function {
  Future<void> addGig(GigModel gigModel, BuildContext context) async {
    try {
      //create gig in Firestore
      final gigRef =
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('gig')
              .doc();

      final metadata = FirebaseFirestore.instance
          .collection('metadata')
          .doc("keywords");

      await metadata.set({
        'keywords': FieldValue.arrayUnion(gigModel.keywords),
      }, SetOptions(merge: true));

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
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('gig')
              .get();

      print("Fetched ${snapshot.docs.length} gigs");
      return snapshot.docs.map((doc) => GigModel.fromSnapshot(doc)).toList();
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

  Future<GigModel?> getGigById(String userId, String gigId) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId!)
              .collection('gig')
              .doc(gigId)
              .get();

      if (doc.exists) {
        return GigModel.fromSnapshot(doc!);
      } else {
        print('Gig not found');
        return null;
      }
    } catch (e) {
      print('Error fetching gig: $e');
      return null;
    }
  }

  Future<List<String>> fetchAllKeywords() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('metadata')
            .doc('keywords')
            .get();
    if (doc.exists && doc.data() != null) {
      List<dynamic> keywords = doc['keywords'];
      return keywords.map((e) => e.toString()).toSet().toList();
    }
    return [];
  }

  Future<List<GigModel>> searchGigs(String keyword) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final usersSnapshot = await firestore.collection('users').get();

      List<GigModel> gigs = [];

      for (var userDoc in usersSnapshot.docs) {
        final gigSnapshot =
            await firestore
                .collection('users')
                .doc(userDoc.id)
                .collection('gig')
                .where('keywords', arrayContains: keyword)
                .get();

        gigs.addAll(gigSnapshot.docs.map((doc) => GigModel.fromSnapshot(doc)));
      }

      return gigs;
    } catch (e) {
      print('Error searching gigs: $e');
      return [];
    }
  }

  Future<List<GigModel>> searchGigFilterLocation(
    String keyword,
    String location,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final usersSnapshot = await firestore.collection('users').get();

      List<GigModel> gigs = [];

      for (var userDoc in usersSnapshot.docs) {
        final gigSnapshot =
            await firestore
                .collection('users')
                .doc(userDoc.id)
                .collection('gig')
                .where('keywords', arrayContains: keyword)
                .where('location', isEqualTo: location)
                .get();

        gigs.addAll(gigSnapshot.docs.map((doc) => GigModel.fromSnapshot(doc)));
      }

      return gigs;
    } catch (e) {
      print('Error searching gigs with filter: $e');
      return [];
    }
  }

  Future<List<GigModel>> getAllGigsForUser(String userId) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("gig")
            .get();

    return snapshot.docs.map((doc) => GigModel.fromSnapshot(doc)).toList();
  }
}
