import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract interface class AuthServiceInterface
{
  Future<UserCredential> callFirebaseAuth({
    required String email,
    required String password,
  });
}

abstract interface class GoogleAuthInterface
{
  Future<UserCredential> signInWithGoogle();
}