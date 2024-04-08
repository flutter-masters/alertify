import 'package:flutter/material.dart';

import '../../../failures/auth_failure.dart';

extension SignInAuthFailureX on SignInAuthFailure {
  ({IconData icon, String message}) get errorData => switch (this) {
        SignInAuthFailure.network => (
            icon: Icons.wifi_off,
            message: 'There was a problem with the network connection',
          ),
        SignInAuthFailure.userNotFound => (
            icon: Icons.person_outline,
            message: 'User not found.',
          ),
        SignInAuthFailure.wrongPassword => (
            icon: Icons.mark_email_unread_outlined,
            message: 'Invalid credentials',
          ),
        SignInAuthFailure.userDisabled => (
            icon: Icons.person_off,
            message: 'Your account has been disabled.'
          ),
        _ => (
            icon: Icons.error_outline,
            message: 'Something went wrong.',
          ),
      };
}

extension SignUpAuthFailureX on SignUpAuthFailure {
  ({IconData icon, String message}) get errorData => switch (this) {
        SignUpAuthFailure.network => (
            icon: Icons.wifi_off,
            message: 'There was a problem with the network connection',
          ),
        SignUpAuthFailure.emailAlreadyInUse => (
            icon: Icons.mark_email_unread_outlined,
            message: 'The email provided already exists.',
          ),
        SignUpAuthFailure.weakPassword => (
            icon: Icons.no_encryption_gmailerrorred_outlined,
            message: 'The password provided is too weak.',
          ),
        _ => (
            icon: Icons.error_outline,
            message: 'Something went wrong.',
          ),
      };
}
