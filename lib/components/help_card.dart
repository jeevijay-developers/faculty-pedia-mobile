import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String details;
  final String? subDetails;
  final String? address;

  const HelpCard({
    super.key,
    required this.title,
    required this.icon,
    required this.details,
    this.subDetails,
    this.address,
  });

  @override
  State<HelpCard> createState() => _HelpCardState();
}

class _HelpCardState extends State<HelpCard> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() => _isExpanded = !_isExpanded);
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon & Title
            Row(
              children: [
                FaIcon(widget.icon, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),

            // Expandable content
            if (_isExpanded) ...[
              const SizedBox(height: 10),
              // Phone clickable
              if (widget.details.isNotEmpty)
                GestureDetector(
                  onTap: () => _launchPhone(
                    widget.details.replaceAll("Phone: ", "").trim(),
                  ),
                  child: Text(
                    widget.details,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),

              // Email clickable
              if (widget.subDetails != null)
                GestureDetector(
                  onTap: () => _launchEmail(
                    widget.subDetails!.replaceAll("Email: ", "").trim(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      widget.subDetails!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),

              // Address (non-clickable)
              if (widget.address != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    widget.address!,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
