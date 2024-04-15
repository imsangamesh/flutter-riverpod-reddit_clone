import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/widgets/helper_widgets.dart';
import 'package:reddit/core/constants/colors.dart';
import 'package:reddit/core/utils/error_text.dart';
import 'package:reddit/core/utils/nav_utils.dart';
import 'package:reddit/features/community/community_controller.dart';
import 'package:reddit/features/community/screens/community_screen.dart';

class SearchCommunityDelegate extends SearchDelegate<SearchCommunityDelegate> {
  SearchCommunityDelegate(this.ref);

  final WidgetRef ref;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
            iconTheme: const IconThemeData(color: AppColors.black, size: 24),
            titleTextStyle: const TextStyle(
              color: AppColors.black,
              fontSize: 19,
              fontWeight: FontWeight.w500,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
          ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => null;

  @override
  Widget buildResults(BuildContext context) => const SizedBox();

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
          data: (communities) => ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: communities.length,
            itemBuilder: (context, i) {
              final comm = communities[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(comm.avatar),
                  ),
                  title: Text('r/${comm.name}'),
                  onTap: () {
                    NavUtils.back(context);
                    NavUtils.to(context, CommunityScreen(comm.name));
                  },
                ),
              );
            },
          ),
          error: (error, _) => ErrorText(error.toString()),
          loading: () => const Loader(),
        );
  }
}
