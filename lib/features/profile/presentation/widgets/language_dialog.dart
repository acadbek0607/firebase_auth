import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
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
                  backgroundColor: AppColors.dark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tr('choose_language', context: context),
                          style: Kstyle.textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 28),
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
                        const SizedBox(height: 24.0),
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
                        const SizedBox(height: 24.0),
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
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: Kstyle.buttonStyle.copyWith(
                                  backgroundColor: WidgetStateProperty.all(
                                    AppColors.darkGreen.withAlpha(50),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  tr('cancel', context: context),
                                  style: Kstyle.textStyle.copyWith(
                                    color: AppColors.darkGreen,
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
                                    AppColors.darkGreen,
                                  ),
                                ),
                                onPressed: () {
                                  onChanged(tempLanguage, tempFlagPath);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  tr('done', context: context),
                                  style: Kstyle.textStyle.copyWith(
                                    color: AppColors.buttonFor,
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

    return GestureDetector(
      onTap: () => onSelected(label, flagAsset),
      child: Row(
        children: [
          // Flag
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SvgPicture.asset(flagAsset, height: 24, width: 24),
          ),
          const SizedBox(width: 12.0),

          // Label
          Expanded(child: Text(label, style: Kstyle.textStyle)),

          // Toggle icon
          SvgPicture.asset(
            isSelected ? 'assets/svg/s_toggle.svg' : 'assets/svg/toggle.svg',
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }
}
