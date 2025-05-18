import 'package:flutter/material.dart';
import 'package:career_pulse/service/firestore/gig_firestore.dart';
import 'package:career_pulse/pages/serchGigListPage.dart';

class SearchBarWidget extends StatelessWidget {
  final Gig_firestote_function _gigFirestore = Gig_firestote_function();

  SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.blueGrey),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  List<String> keywords =
                      await _gigFirestore.fetchAllKeywords();
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(searchTerms: keywords),
                  );
                },
                child: const Text(
                  "Search",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<String> searchTerms;

  CustomSearchDelegate({required this.searchTerms});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final matchQuery =
        searchTerms
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(matchQuery[index]),
          onTap: () {
            final selectedKeyword = matchQuery[index];
            close(context, null);
            Future.delayed(Duration(milliseconds: 100), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SearchGigList(keywords: selectedKeyword),
                ),
              );
            });
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text("Type to search..."));
    }

    final matchQuery =
        searchTerms
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(matchQuery[index]),
          onTap: () {
            final selectedKeyword = matchQuery[index];
            close(context, null);
            Future.delayed(Duration(milliseconds: 100), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SearchGigList(keywords: selectedKeyword),
                ),
              );
            });
          },
        );
      },
    );
  }
}
