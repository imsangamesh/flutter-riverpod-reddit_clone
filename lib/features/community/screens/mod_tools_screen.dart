import 'package:flutter/material.dart';
import 'package:reddit/core/utils/nav_utils.dart';
import 'package:reddit/features/community/screens/add_mods_screen.dart';
import 'package:reddit/features/community/screens/edit_community_screen.dart';

class ModToolsScreen extends StatelessWidget {
  const ModToolsScreen(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mod Tools')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add_moderator),
              title: const Text('Add Moderators'),
              onTap: () => NavUtils.to(context, AddModsScreen(name)),
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Community'),
              onTap: () => NavUtils.to(context, EditCommunityScreen(name)),
            ),
          ],
        ),
      ),
    );
  }
}
