import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/widgets/helper_widgets.dart';
import 'package:reddit/core/utils/error_text.dart';
import 'package:reddit/features/auth/auth_controller.dart';
import 'package:reddit/features/community/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  const AddModsScreen(this.name, {super.key});
  final String name;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  final Set<String> uids = {};
  int ctr = 0;

  void addUids(String uid) {
    setState(() => uids.add(uid));
  }

  void removeUids(String uid) {
    setState(() => uids.remove(uid));
  }

  void saveMods() {
    ref
        .read(communityControllerProvider.notifier)
        .addMods(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: saveMods, icon: const Icon(Icons.done_all)),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (community) => ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: community.members.length,
              itemBuilder: (context, i) {
                final member = community.members[i];

                return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.mods.contains(member) && ctr == 0) {
                          uids.add(member);
                        }
                        ctr++;

                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          title: Text(member),
                          onChanged: (val) {
                            if (val ?? false) {
                              addUids(user.uid);
                            } else {
                              removeUids(user.uid);
                            }
                          },
                        );
                      },
                      error: (e, _) => ErrorText(e.toString()),
                      loading: () => const Loader(),
                    );
              },
            ),
            error: (error, _) => ErrorText(error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
