import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeatureButton extends StatefulWidget {
  double width, height;
  String text;
  void Function()? onTap;
  IconData icon;
  FeatureButton({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.onTap,
    required this.icon,
  });

  @override
  State<FeatureButton> createState() => _FeatureButtonState();
}

class _FeatureButtonState extends State<FeatureButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Container(
              width: widget.width ,
              height: widget.height / 9,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: FaIcon(widget.icon, size: 50, color: Color(0xFF0068c6)),
              ),
            ),
          ),
        ),
        Text(widget.text),
      ],
    );
  }
}
