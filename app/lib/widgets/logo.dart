import 'package:flutter/material.dart';

import '../core/theme/colors.dart';

class LunaLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const LunaLogo({super.key, this.size = 64, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icono / Símbolo de la Luna con Estética Táctil
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.linoTenue, // Luz de cera sutil
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryContainer.withValues(alpha: 0.12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.nightlight_round,
              size: 32,
              color: AppColors.primaryContainer,
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 16),
          const Text(
            'Tinta de Luna',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 26,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryContainer,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Poesía a la medianoche',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.outline,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
