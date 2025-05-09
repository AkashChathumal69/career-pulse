import 'package:career_pulse/model/gig_model.dart';
import 'package:career_pulse/pages/gig_page.dart';
import 'package:career_pulse/service/firestore/gig_firestore.dart';
import 'package:flutter/material.dart';

class SearchGigList extends StatefulWidget {
  final String keywords;

  const SearchGigList({super.key, required this.keywords});

  @override
  State<SearchGigList> createState() => _SearchGigListState();
}

class _SearchGigListState extends State<SearchGigList> {
  final Gig_firestote_function _gigFirestore = Gig_firestote_function();

  List<GigModel> gigs = [];

  @override
  void initState() {
    super.initState();
    fetchGigs();
  }

  void fetchGigs() async {
    List<GigModel> result = await _gigFirestore.searchGigs(widget.keywords);
    setState(() {
      gigs = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Gig List'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: gigs.length,
        itemBuilder: (context, index) {
          final gig = gigs[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(gig.gig_title),
              subtitle: Text(gig.description),
              trailing: Text('\$${gig.uid}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => GigPage(
                          description: gig.description,
                          gigTitle: gig.gig_title,
                          imageUrl: gig.imageUrl,
                          keywords: gig.keywords,
                          occupation: gig.occupation,
                          uid: gig.uid,
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
