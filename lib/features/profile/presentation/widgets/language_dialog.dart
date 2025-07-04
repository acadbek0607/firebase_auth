import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fire_auth/core/constants/classes.dart';

class LanguageDialog {
  static Future<void> show({
    required BuildContext context,
    required String currentLanguage,
    required String currentFlagPath,
    required void Function(String language, String flagAssetPath) onChanged,
  }) async {
    String tempLanguage = currentLanguage;
    String tempFlagPath = currentFlagPath;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'LanguageDialog',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: Center(
            child: StatefulBuilder(
              builder: (context, setInnerState) {
                return Dialog(
                  backgroundColor: const Color(0xFF2A2A2D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  insetPadding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Choose a language',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildLangOption(
                          label: 'O‘zbek (Lotin)',
                          flagAsset: 'assets/flags/uz.svg',
                          selected: tempLanguage,
                          onSelected: (lang, flag) {
                            setInnerState(() {
                              tempLanguage = lang;
                              tempFlagPath = flag;
                            });
                          },
                        ),
                        _buildLangOption(
                          label: 'Русский',
                          flagAsset: 'assets/flags/ru.svg',
                          selected: tempLanguage,
                          onSelected: (lang, flag) {
                            setInnerState(() {
                              tempLanguage = lang;
                              tempFlagPath = flag;
                            });
                          },
                        ),
                        _buildLangOption(
                          label: 'English (USA)',
                          flagAsset: 'assets/flags/us.svg',
                          selected: tempLanguage,
                          onSelected: (lang, flag) {
                            setInnerState(() {
                              tempLanguage = lang;
                              tempFlagPath = flag;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: Kstyle.buttonStyle.copyWith(
                                  backgroundColor: WidgetStateProperty.all(
                                    const Color(0xFF008F7F).withAlpha(50),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Cancel',
                                  style: Kstyle.textStyle.copyWith(
                                    color: const Color(0xFF008F7F),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: Kstyle.buttonStyle.copyWith(
                                  backgroundColor: WidgetStateProperty.all(
                                    const Color(0xFF008F7F),
                                  ),
                                ),
                                onPressed: () {
                                  onChanged(tempLanguage, tempFlagPath);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Done',
                                  style: Kstyle.textStyle.copyWith(
                                    color: const Color(0xFFFDFDFD),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  static Widget _buildLangOption({
    required String label,
    required String flagAsset,
    required String selected,
    required Function(String, String) onSelected,
  }) {
    final bool isSelected = selected == label;

    return ListTile(
      dense: true,
      horizontalTitleGap: 12,
      contentPadding: EdgeInsets.zero,
      leading: SvgPicture.asset(flagAsset, width: 44, height: 44),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      trailing: GestureDetector(
        onTap: () => onSelected(label, flagAsset),
        child: SvgPicture.asset(
          isSelected ? 'assets/svg/s_toggle.svg' : 'assets/svg/toggle.svg',
          width: 20,
          height: 20,
        ),
      ),
      onTap: () => onSelected(label, flagAsset),
    );
  }
}
