import"package:firebase_auth/firebase_auth.dart";

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();


  Future<User?> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e.code));
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e.code));
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e.code));
    } catch (e) {
      throw Exception("Password reset failed: $e");
    }
  }

  String _mapAuthError(String code) {
    switch (code ) {
      case "email-already-in-use" :
        return "An account with this email already exists.";
      case "invalid-email" :
        return "Please enter a valid email address.";
      case "weak-password" :
        return "Password must be at least 6 characters long.";
      case "user-not-found" :
        return "Invalid email or password.";
      case "wrong-password" :
        return "Invalid email or password.";
      case "user-disabled" :
        return "This account has been disabled. Contact support.";
      case "too-many-requests" :
        return "Too many login attempts. Please try again later.";
      case "network-request-failed" :
        return "No internet connection. Please check your network.";
      default :
        return "Authenmtication failed. Please try again later.";

    }
  }
}