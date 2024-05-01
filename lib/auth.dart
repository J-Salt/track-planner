import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Signs in user with [email] and [password]
  Future<void> signIn({required email, required password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Registers a user with [email] and [password]
  /// Returns String [uid]
  Future<String> createUser({required email, required password}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists for that email.';
      }
    } catch (e) {
      return e.toString();
    }

    return 'User creation failed.';
  }

  /// Signs out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
