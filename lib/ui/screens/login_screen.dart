import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn(bool isIos) async {
    final authService = context.read<AuthService>();
    if (isIos) {
      await authService.signInWithApple();
    } else {
      await authService.signInWithGoogle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Top Classification Stamp
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.redDim,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.red),
                    ),
                    child: const Text(
                      'CLASSIFIED // FOR OFFICIAL USE ONLY',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppTheme.red,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Mono',
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Text(
                    'PORTAL: v3.2',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.textFaint,
                      fontFamily: 'IBM Plex Mono',
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Holographic Bureau Radar Crest
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceAlt,
                      border: Border.all(
                        color: AppTheme.amber.withAlpha((150 + _pulseController.value * 105).toInt()),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.amber.withAlpha((40 + _pulseController.value * 50).toInt()),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.shield,
                        size: 52,
                        color: AppTheme.amber.withAlpha((200 + _pulseController.value * 55).toInt()),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),

              // Titles
              Text(
                'BLACK BOX',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'AIR CRASH BUREAU',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppTheme.amber,
                  letterSpacing: 2.0,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Uçak Kaza Soruşturma Dairesi Federal Ağı',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textDim,
                ),
              ),
              const SizedBox(height: 28),

              // Security & Authentication Policy Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassBox(
                  borderColor: AppTheme.surfaceBorder,
                  backgroundColor: const Color(0xFF101419),
                  borderRadius: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.fingerprint, size: 20, color: AppTheme.cyan),
                        SizedBox(width: 8),
                        Text(
                          'MÜFETTİŞ KİMLİK DOĞRULAMA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.cyan,
                            fontFamily: 'IBM Plex Mono',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Havacılık kara kutu ses kayıtları, FDR telemetrisi ve adli otopsi raporlarına erişim yalnızca onaylı tekil müfettiş hesabı ile mümkündür.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textDim,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Platform-Specific Native Sign-In Action (ONLY Apple on iOS, ONLY Google on Android)
              if (authService.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: CircularProgressIndicator(color: AppTheme.amber),
                )
              else if (isIos) ...[
                // iOS Platform: ONLY Sign in with Apple
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => _handleSignIn(true),
                    icon: const Icon(Icons.apple, color: Colors.black, size: 24),
                    label: const Text(
                      'Sign in with Apple',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Android / Other Platforms: ONLY Sign in with Google
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => _handleSignIn(false),
                    icon: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        ' G ',
                        style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    label: const Text(
                      'Google Hesabı ile Giriş Yap',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Bottom Security Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_outline, size: 12, color: AppTheme.textFaint),
                  SizedBox(width: 6),
                  Text(
                    '256-BIT FEDERAL ADLİ ŞİFRELEME • NTSB / BEA STANDARDI',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppTheme.textFaint,
                      fontFamily: 'IBM Plex Mono',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
