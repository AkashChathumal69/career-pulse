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
      backgroundColor: const Color.fromARGB(255, 0, 46, 125),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              // Top Row with Back and Search
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _onLocationPressed,
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Filters
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      await _onLocationPressed();
                      Navigator.pop(context);
                    },
                    child: _buildFilterButton(
                      Icons.location_on,
                      _location ?? "Location",
                    ),
                  ),
                  const SizedBox(width: 20),
                  _buildFilterButton(Icons.list, "Category"),
                ],
              ),

              const SizedBox(height: 30),

              // Gig List
              Expanded(
                child:
                    _gigs.isEmpty
                        ? const Center(
                          child: Text(
                            'No gigs found.',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                        : ListView.builder(
                          itemCount: _gigs.length,
                          itemBuilder: (context, index) {
                            final gig = _gigs[index];
                            return _buildGigCard(gig);
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 35, 114),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 40,
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildGigCard(GigModel gig) {
    return GestureDetector(
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  gig.imageUrl,
                  fit: BoxFit.cover,
                  height: 103,
                  width: 120,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 50),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.yellow, size: 16),
                        SizedBox(width: 5),
                        Text("4.5", style: TextStyle(fontSize: 14)),
                        Spacer(),
                        Icon(Icons.favorite, color: Colors.red, size: 16),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      gig.occupation,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 46, 125),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blue, size: 12),
                        const SizedBox(width: 4),
                        Text(gig.uid, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _location ?? "Unknown",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
