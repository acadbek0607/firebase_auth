// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/ui/detail/widgets/responsive_center.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  Future<String> _loadPolicy(BuildContext context) async {
    final code = context.locale.languageCode;
    final path = 'assets/privacy/' + code + '.txt';
    return await DefaultAssetBundle.of(context).loadString(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('privacy_policy', context: context)),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: _loadPolicy(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return ResponsiveCenter(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                snapshot.data ?? '',
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
