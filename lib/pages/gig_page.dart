import 'package:career_pulse/pages/chat_page.dart';
import 'package:flutter/material.dart';

class GigPage extends StatelessWidget {
  final String description;
  final String gigTitle;
  final String imageUrl;
  final List<String> keywords;
  final String occupation;
  final String uid;
  final String location;
  final String? gigId;

  const GigPage({
    Key? key,
    required this.description,
    required this.gigTitle,
    required this.imageUrl,
    required this.keywords,
    required this.occupation,
    required this.uid,
    required this.location,
    required this.gigId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gig Details'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              gigTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.work, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  occupation,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Description', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text(
              'Skills Required',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  keywords
                      .map(
                        (keyword) => Chip(
                          label: Text(keyword),
                          backgroundColor: Colors.blue[100],
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChatPage(
                            receiverEmail: "bamithabekanayake44@gmail.com",
                            receiverId: "K12Wo0HDgwSOqnd93UpXJ3eQvCn1",
                            gigId: gigId,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text('Contact'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Gig ID: $uid',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
