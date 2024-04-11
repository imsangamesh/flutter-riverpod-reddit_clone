import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_test.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/sign_in_button.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, String name) {
    Routemaster.of(context).push('/r/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = !ref.watch(userProvider)!.isAuthenticated;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            if (isGuest) const SignInButton(isFromLogin: false),
            if (!isGuest) ...[
              ListTile(
                title: const Text('Create a community'),
                leading: const Icon(Icons.add),
                onTap: () => navigateToCreateCommunity(context),
              ),
              ref.watch(userCommunityProvider).when(
                    data: (communities) => Expanded(
                      child: ListView.builder(
                        itemCount: communities.length,
                        itemBuilder: (context, i) {
                          final community = communities[i];
                          return ListTile(
                            title: Text('r/${community.name}'),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                            onTap: () => navigateToCommunity(
                              context,
                              community.name,
                            ),
                          );
                        },
                      ),
                    ),
                    error: (error, _) => ErrorText(error.toString()),
                    loading: () => const Loader(),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}
