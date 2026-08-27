import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/investigation_provider.dart';

class RadioPttWidget extends StatelessWidget {
  const RadioPttWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestigationProvider>();
    final isTransmitting = provider.isRadioActive;

    return GestureDetector(
      onTapDown: (_) => provider.setRadioActive(true),
      onTapUp: (_) => provider.setRadioActive(false),
      onTapCancel: () => provider.setRadioActive(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isTransmitting ? AppTheme.red : AppTheme.surfaceAlt,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isTransmitting ? AppTheme.red : AppTheme.amber,
            width: 1.5,
          ),
          boxShadow: isTransmitting
              ? [
                  BoxShadow(
                    color: AppTheme.red.withAlpha(120),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isTransmitting ? Icons.mic : Icons.mic_none,
              color: isTransmitting ? Colors.white : AppTheme.amber,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isTransmitting ? 'TELSİZ YAYINDA (BAS-KONUŞ)' : 'TELSİZ (BAS-KONUŞ)',
              style: TextStyle(
                fontFamily: 'IBM Plex Mono',
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: isTransmitting ? Colors.white : AppTheme.amber,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
