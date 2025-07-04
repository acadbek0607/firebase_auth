import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileCard extends StatelessWidget {
  final String fullName;
  final String phone;
  final String email;
  final String profession;
  final String organization;
  final String? photoUrl;
  final String? dateOfBirth;
  final VoidCallback onEdit;
  final VoidCallback onLanguageTap;
  final String selectedLanguage;
  final String selectedFlag;

  const ProfileCard({
    super.key,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.profession,
    required this.organization,
    this.photoUrl,
    this.dateOfBirth,
    required this.onEdit,
    required this.onLanguageTap,
    required this.selectedLanguage,
    required this.selectedFlag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: const Color(0xFF2C2C2E),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xFF2C2C2E),
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl!)
                            : const AssetImage('assets/img/default.png')
                                  as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              color: Color(0xFF00A795),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$profession • $organization',
                            style: const TextStyle(color: Color(0xFFE7E7E7)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _infoRow('Phone', phone),
                  _infoRow('Email', email),
                  if (dateOfBirth != null)
                    _infoRow('Date of Birth', dateOfBirth!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onLanguageTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2B2E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedLanguage,
                    style: const TextStyle(color: Colors.white),
                  ),
                  SvgPicture.asset(selectedFlag, height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
