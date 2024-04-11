import 'package:flutter/material.dart';
import 'package:reddit/features/auth/screens/login_screen.dart';
import 'package:reddit/features/community/screens/add_mods_screen.dart';
import 'package:reddit/features/community/screens/community_screen.dart';
import 'package:reddit/features/community/screens/create_community_screen.dart';
import 'package:reddit/features/community/screens/edit_community_screen.dart';
import 'package:reddit/features/community/screens/mod_tools_screen.dart';
import 'package:reddit/features/home/screens/home_screen.dart';
import 'package:reddit/features/post/screens/add_post_type_screen.dart';
import 'package:reddit/features/post/screens/comment_screen.dart';
import 'package:reddit/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage<LoginScreen>(child: LoginScreen()),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage<HomeScreen>(child: HomeScreen()),
    '/create-community': (_) => const MaterialPage<CreateCommunityScreen>(
          child: CreateCommunityScreen(),
        ),
    '/r/:name': (route) => MaterialPage<CommunityScreen>(
          child: CommunityScreen(route.pathParameters['name']!),
        ),
    '/mod-tools/:name': (route) => MaterialPage<ModToolsScreen>(
          child: ModToolsScreen(route.pathParameters['name']!),
        ),
    '/edit-community/:name': (route) => MaterialPage<EditCommunityScreen>(
          child: EditCommunityScreen(route.pathParameters['name']!),
        ),
    '/add-mods/:name': (route) => MaterialPage<AddModsScreen>(
          child: AddModsScreen(route.pathParameters['name']!),
        ),
    '/u/:uid': (route) => MaterialPage<UserProfileScreen>(
          child: UserProfileScreen(route.pathParameters['uid']!),
        ),
    '/edit-profile/:uid': (route) => MaterialPage<EditProfileScreen>(
          child: EditProfileScreen(route.pathParameters['uid']!),
        ),
    '/add-post/:type': (route) => MaterialPage<AddPostTypeScreen>(
          child: AddPostTypeScreen(route.pathParameters['type']!),
        ),
    '/posts/:postId/comments': (route) => MaterialPage<CommentsScreen>(
          child: CommentsScreen(route.pathParameters['postId']!),
        ),
  },
);
