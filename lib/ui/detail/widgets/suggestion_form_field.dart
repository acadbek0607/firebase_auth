import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuggestionFormField extends StatefulWidget {
  final String prefsKey;
  final TextEditingController controller;
  final InputDecoration decoration;
  final TextStyle? style;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;

  const SuggestionFormField({
    super.key,
    required this.prefsKey,
    required this.controller,
    required this.decoration,
    this.style,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.minLines,
    this.maxLines,
    this.inputFormatters,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
  });

  @override
  State<SuggestionFormField> createState() => _SuggestionFormFieldState();
}

class _SuggestionFormFieldState extends State<SuggestionFormField> {
  List<String> _options = [];
  TextEditingController? _fieldController;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _options = prefs.getStringList(widget.prefsKey) ?? [];
    });
  }

  Future<void> _save(String value) async {
    final val = value.trim();
    if (val.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(widget.prefsKey) ?? [];
    list.remove(val);
    list.insert(0, val);
    if (list.length > 10) {
      list.removeRange(10, list.length);
    }
    await prefs.setStringList(widget.prefsKey, list);
    setState(() {
      _options = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _options.where(
          (option) => option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          ),
        );
      },
      onSelected: (String selection) {
        widget.controller
          ..text = selection
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: selection.length),
          );
        _save(selection);
      },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            if (_fieldController != textEditingController) {
              _fieldController = textEditingController;
              _fieldController!.value = widget.controller.value;
              _fieldController!.addListener(() {
                if (widget.controller.value != _fieldController!.value) {
                  widget.controller.value = _fieldController!.value;
                }
              });
            }
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: widget.decoration,
              style: widget.style,
              textCapitalization: widget.textCapitalization,
              keyboardType: widget.keyboardType,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              inputFormatters: widget.inputFormatters,
              validator: widget.validator,
              onChanged: widget.onChanged,
              onFieldSubmitted: (value) {
                _save(value);
                widget.onFieldSubmitted?.call(value);
                onFieldSubmitted();
              },
            );
          },
    );
  }
}
