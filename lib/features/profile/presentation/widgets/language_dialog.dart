import 'package:flutter/material.dart';

class LanguageDialog {
  static Future<void> show({
    required BuildContext context,
    required String currentLanguage,
    required String currentFlag,
    required void Function(String language, String flag) onChanged,
  }) async {
    String tempLanguage = currentLanguage;
    String tempFlag = currentFlag;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1C1C1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              title: const Text(
                'Choose a language',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLangOption(
                    label: 'O‘zbek (Lotin)',
                    flag: '🇺🇿',
                    selected: tempLanguage,
                    onSelected: (lang, flag) {
                      setInnerState(() {
                        tempLanguage = lang;
                        tempFlag = flag;
                      });
                    },
                  ),
                  _buildLangOption(
                    label: 'Русский',
                    flag: '🇷🇺',
                    selected: tempLanguage,
                    onSelected: (lang, flag) {
                      setInnerState(() {
                        tempLanguage = lang;
                        tempFlag = flag;
                      });
                    },
                  ),
                  _buildLangOption(
                    label: 'English (USA)',
                    flag: '🇺🇸',
                    selected: tempLanguage,
                    onSelected: (lang, flag) {
                      setInnerState(() {
                        tempLanguage = lang;
                        tempFlag = flag;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    onChanged(tempLanguage, tempFlag);
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Widget _buildLangOption({
    required String label,
    required String flag,
    required String selected,
    required Function(String, String) onSelected,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text('$flag  $label', style: const TextStyle(color: Colors.white)),
      trailing: Radio<String>(
        value: label,
        groupValue: selected,
        onChanged: (val) {
          if (val != null) onSelected(val, flag);
        },
        activeColor: Colors.teal,
      ),
      onTap: () {
        onSelected(label, flag);
      },
    );
  }
}
