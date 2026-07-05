import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ParentalGateDialog extends StatefulWidget {
  final VoidCallback onGSuccess;
  const ParentalGateDialog({super.key, required this.onGSuccess});

  @override
  State<ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<ParentalGateDialog> {
  late int num1;
  late int num2;
  late int correctAnswer;
  final TextEditingController _controller = TextEditingController();
  String _errorText = '';

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final random = Random();
    num1 = random.nextInt(10) + 5; // 5-15
    num2 = random.nextInt(10) + 2; // 2-12
    correctAnswer = num1 + num2;
  }

  void _verify() {
    if (_controller.text == correctAnswer.toString()) {
      Navigator.pop(context);
      widget.onGSuccess();
    } else {
      setState(() {
        _errorText = 'Incorrect! Try again.';
        _generateQuestion();
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.white,
      title: Column(
        children: [
          const Icon(Icons.security_rounded, size: 50, color: Colors.orange),
          const SizedBox(height: 10),
          Text(
            'Parents Only!',
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Solve this math problem to enter:',
              textAlign: TextAlign.center,
              style: GoogleFonts.baloo2(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Text(
              '$num1 + $num2 = ?',
              style: GoogleFonts.baloo2(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.baloo2(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'Answer',
                errorText: _errorText.isEmpty ? null : _errorText,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: _verify,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: Text(
              'Verify',
              style: GoogleFonts.baloo2(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
