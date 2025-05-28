import 'package:career_pulse/model/gig_model.dart';
import 'package:career_pulse/service/firestore/gig_firestore.dart';
import 'package:flutter/material.dart';

class MyGigPage extends StatefulWidget {
  const MyGigPage({super.key});

  @override
  MyGigPageState createState() => MyGigPageState();
}

class MyGigPageState extends State<MyGigPage> {
  final Gig_firestote_function gigFirestore = Gig_firestote_function();
  List<GigModel> gigs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGigs();
  }

  Future<void> fetchGigs() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedGigs = await gigFirestore.getGigs();
      setState(() {
        gigs = fetchedGigs;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching gigs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteGig(String gigId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Gig'),
            content: Text('Are you sure you want to delete this gig?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await gigFirestore.deleteGig(gigId);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gig deleted successfully')));
        fetchGigs(); // refresh list
      } catch (e) {
        debugPrint('Error deleting gig: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete gig')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Gigs')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : gigs.isEmpty
              ? Center(child: Text('No gigs found'))
              : ListView.builder(
                itemCount: gigs.length,
                itemBuilder: (context, index) {
                  final gig = gigs[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: ListTile(
                      title: Text(gig.gig_title),
                      subtitle: Text(gig.description),
                      leading: Image.network(
                        gig.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Icon(Icons.broken_image),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteGig(gig.gig_id!),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
