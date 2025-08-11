import 'package:flutter/material.dart';

class ExamButton extends StatefulWidget {
  double width;
  String text;
  void Function()? onTap;
  ExamButton({
    super.key,
    required this.width,
    required this.text,
    required this.onTap,
  });

  @override
  State<ExamButton> createState() => _ExamButtonState();
}

class _ExamButtonState extends State<ExamButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Container(
          width: widget.width / 4,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
