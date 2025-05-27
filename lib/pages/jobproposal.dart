import 'package:flutter/material.dart';

class JobProposalForm extends StatefulWidget {
  final List<String> sellerGigs; // Pass seller's gig titles here

  const JobProposalForm({Key? key, required this.sellerGigs}) : super(key: key);

  @override
  _JobProposalFormState createState() => _JobProposalFormState();
}

class _JobProposalFormState extends State<JobProposalForm> {
  String? selectedGig;
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _sendProposal() {
    if (selectedGig == null ||
        _daysController.text.isEmpty ||
        _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // TODO: Implement actual send logic
    print("Gig: $selectedGig");
    print("Days: ${_daysController.text}");
    print("Message: ${_messageController.text}");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Proposal Sent")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Job Proposal"),
        backgroundColor: const Color(0xFF002E7D),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Select Gig Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedGig,
                hint: const Text("Select a Gig"),
                items:
                    widget.sellerGigs
                        .map(
                          (gig) =>
                              DropdownMenuItem(value: gig, child: Text(gig)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() => selectedGig = value);
                },
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),

            const SizedBox(height: 20),

            // Date Count
            TextField(
              controller: _daysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Number of Days",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),

            const SizedBox(height: 20),

            // Message Box
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Your Message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),

            const SizedBox(height: 30),

            // Send Proposal Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendProposal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002E7D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Send Proposal",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
