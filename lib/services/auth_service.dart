import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// Stream de cambios de sesión (login/logout).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Registra usuario y guarda perfil en Firestore.
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password
    );
    final user = cred.user!;
    final userModel = UserModel(
      uid: user.uid,
      email: email,
      displayName: displayName,
      photoUrl: '',
    );
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toJson());
    return userModel;
  }

  /// Inicia sesión y devuelve el perfil de Firestore.
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password
    );
    final user = cred.user!;
    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists || doc.data() == null) {
      // Si no existe perfil, creamos uno mínimo
      final fallback = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoUrl: '',
      );
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(fallback.toJson());
      return fallback;
    }

    return UserModel.fromJson(doc.data()!);
  }

  /// Carga un perfil a partir de UID (para el AuthGate).
  Future<UserModel> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return UserModel.fromJson(doc.data()!);
  }

  /// Cierra sesión.
  Future<void> signOut() => _auth.signOut();
}
