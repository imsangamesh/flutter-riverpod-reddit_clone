import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/errors/failure.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/services/typedefs.dart';
import 'package:reddit/models/user_model.dart';

final authRepoProvider = Provider(
  (ref) => AuthRepo(
    fire: ref.firestore,
    auth: ref.fireAuth,
    googleSignIn: ref.googleSignIn,
    box: ref.getStorage,
  ),
);

class AuthRepo {
  AuthRepo({
    required FirebaseFirestore fire,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required GetStorage box,
  })  : _fire = fire,
        _auth = auth,
        _googleSignIn = googleSignIn,
        _box = box;

  final FirebaseFirestore _fire;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final GetStorage _box;

  /// --------------------------------------------- `GETTERS`

  bool get isAuthenticated => _auth.currentUser != null && getUser != null;

  CollectionReference get _users => _fire.collection(FireKeys.users);

  /// --------------------------------------------- `METHODS`

  Stream<UserModel> getUserData(String uid) => _users.doc(uid).snapshots().map(
        (userSnap) => UserModel.fromMap(
          userSnap.data()! as Map<String, dynamic>,
        ),
      );

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw Exception('User is null, please try again!');
      }

      final user = userCredential.user!;
      final userSnapshot = await _userSnapshop(user.uid);
      UserModel userModel;

      if (userSnapshot.exists && userSnapshot.data() != null) {
        userModel = UserModel.fromMap(userSnapshot.data()!);
      } else {
        userModel = userModel = UserModel.newUser(
          uid: user.uid,
          name: user.displayName,
          profilePic: user.photoURL,
        );
      }

      await _storeUser(userModel);
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      return left(Failure.fromFirebase(e));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _userSnapshop(String uid) {
    return _fire.collection(FireKeys.users).doc(uid).get();
  }

  /// --------------------------------------------- `GET STORAGE BOX`
  ///
  Future<void> _storeUser(UserModel user) async {
    await _box.write(BoxKeys.user, user.toMap());
  }

  UserModel? get getUser {
    final userMap = _box.read<DataMap>(BoxKeys.user);
    return userMap == null ? null : UserModel.fromMap(userMap);
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    await _box.erase();
  }
}
