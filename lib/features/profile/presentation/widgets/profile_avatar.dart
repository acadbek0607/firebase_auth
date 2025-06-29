import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;

  const ProfileAvatar({super.key, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: photoUrl != null
                ? NetworkImage(photoUrl!)
                : const AssetImage('assets/images/default_avatar.png')
                      as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                // trigger upload logic here via Bloc
              },
            ),
          ),
        ],
      ),
    );
  }
}
