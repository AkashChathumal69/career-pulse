import 'package:career_pulse/model/gig_model.dart';
import 'package:career_pulse/pages/gig_page.dart';
import 'package:career_pulse/service/firestore/gig_firestore.dart';
import 'package:career_pulse/service/location/location_service.dart';
import 'package:flutter/material.dart';

class SearchGigList extends StatefulWidget {
  final String keywords;
  const SearchGigList({Key? key, required this.keywords}) : super(key: key);

  @override
  State<SearchGigList> createState() => _SearchGigListState();
}

class _SearchGigListState extends State<SearchGigList> {
  final Gig_firestote_function _gigFirestore = Gig_firestote_function();
  final LocationService _locationService = LocationService();
  String? _location;
  List<GigModel> _gigs = [];

  @override
  void initState() {
    super.initState();
    _fetchGigs();
  }

  Future<void> _fetchGigs() async {
    final result = await _gigFirestore.searchGigs(widget.keywords);
    setState(() => _gigs = result);
  }

  Future<void> _fetchGigsByLocation(String location) async {
    final result = await _gigFirestore.searchGigFilterLocation(
      widget.keywords,
      location,
    );
    setState(() => _gigs = result);
  }

  Future<void> _onLocationPressed() async {
    final loc = await _locationService.getLiveLocation();
    if (loc != null && loc.isNotEmpty) {
      setState(() {
        _location = loc;
      });
      await _fetchGigsByLocation(loc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Gig List'),
        backgroundColor: Colors.blue,
        actions: [
          Row(
            children: [
              Text(
                _location ?? 'Location',
                style: const TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.location_on_sharp),
                onPressed: _onLocationPressed,
              ),
            ],
          ),
        ],
      ),
      body:
          _gigs.isEmpty
              ? const Center(child: Text('No gigs found.'))
              : ListView.builder(
                itemCount: _gigs.length,
                itemBuilder: (context, index) {
                  final gig = _gigs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: ListTile(
                      title: Text(gig.gig_title),
                      subtitle: Text(gig.description),
                      trailing: Text(gig.uid),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => GigPage(
                                    location: _location ?? 'Location',
                                    gigId: gig.gig_id,
                                    gigTitle: gig.gig_title,
                                    description: gig.description,
                                    imageUrl: gig.imageUrl,
                                    keywords: gig.keywords,
                                    occupation: gig.occupation,
                                    uid: gig.uid,
                                  ),
                            ),
                          ),
                    ),
                  );
                },
              ),
    );
  }
}
