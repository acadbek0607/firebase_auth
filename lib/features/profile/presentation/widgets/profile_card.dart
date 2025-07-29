import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileCard extends StatelessWidget {
  final String email;
  final VoidCallback onLanguageTap;
  final String selectedLanguage;
  final String selectedFlag;

  const ProfileCard({
    super.key,
    required this.email,
    required this.onLanguageTap,
    required this.selectedLanguage,
    required this.selectedFlag,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: const Color(0xFF2C2C2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFF2C2C2E),
                      backgroundImage:
                          const AssetImage('assets/img/default.png')
                              as ImageProvider,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Asadbek Mamutov',
                          style: const TextStyle(
                            color: Color(0xFF00A795),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Mobile developer • UIC',
                          style: const TextStyle(color: Color(0xFFE7E7E7)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _infoRow(tr('date_of_birth', context: context), '06.07.2000'),
                _infoRow(
                  tr('phone', context: context),
                  KFormat.formatPhone('+998906620706'),
                ),
                _infoRow(tr('email', context: context), email),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onLanguageTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
              height: 44.0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2B2E),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedLanguage, style: Kstyle.textStyle),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SvgPicture.asset(
                      selectedFlag,
                      height: 20,
                      width: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Text(
            '$title:  ',
            style: Kstyle.textStyle.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(value, style: const TextStyle(color: Color(0xFF999999))),
        ],
      ),
    );
  }
}
