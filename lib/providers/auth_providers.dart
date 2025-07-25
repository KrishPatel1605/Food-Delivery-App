
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPrefsProvider must be overridden');
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

class AuthRepository {
  final FirebaseAuth _auth;
  final SharedPreferences _prefs;
  AuthRepository(this._auth, this._prefs);

  static const String loggedInKey = 'logged_in';

  Future<UserCredential> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    await _prefs.setBool(loggedInKey, true);
    return cred;
  }

  Future<UserCredential> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _prefs.setBool(loggedInKey, true);
    return cred;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _prefs.remove(loggedInKey);
  }

  User? get currentUser => _auth.currentUser;
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider), ref.watch(sharedPrefsProvider));
});
