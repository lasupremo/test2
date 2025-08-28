import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:flutter/foundation.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isSigningIn = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isSigningIn ? 'Sign in' : 'Sign up',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            
              SupaEmailAuth(
                            isInitiallySigningIn: _isSigningIn,
                            onToggleSignIn: (bool isSigningIn) {
                              setState(() => _isSigningIn = isSigningIn);
                            },
                            redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
                            onSignInComplete: (response) {},
                            onSignUpComplete: (response) {},
                            metadataFields: const [],
                          ),
                          
                        ],
                      ),
                    ),
                  );
                }
              }


