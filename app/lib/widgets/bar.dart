import 'package:flutter/material.dart';

import '../core/theme/colors.dart'; // Ajusta la ruta según tu estructura

class RudderBar extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onAddTap;
  final VoidCallback onProfileTap;

  const RudderBar({
    Key? key,
    required this.onHomeTap,
    required this.onAddTap,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer, // Tinta Carbón Profunda (#23201E)
        borderRadius: BorderRadius.circular(32), // Forma tipo cápsula orgánica
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(35, 32, 30, 0.18),
            blurRadius: 32,
            offset: Offset(0, 12),
          ),
          BoxShadow(
            color: Color.fromRGBO(35, 32, 30, 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Botón de Inicio / Lista
          IconButton(
            icon: const Icon(
              Icons.auto_stories_rounded,
              color: AppColors.inverseOnSurface,
            ),
            onPressed: onHomeTap,
            tooltip: 'Mis Cartas',
          ),

          // Botón Central Destacado (+)
          Material(
            color:
                AppColors.linoTenue, // Luz de Cera / Lino Tenue para contraste
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onAddTap,
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.add_rounded,
                  color: AppColors.primaryContainer,
                  size: 26,
                ),
              ),
            ),
          ),

          // Botón de Perfil / Ajustes
          IconButton(
            icon: const Icon(
              Icons.nightlight_round,
              color: AppColors.inverseOnSurface,
            ),
            onPressed: onProfileTap,
            tooltip: 'Acerca de',
          ),
        ],
      ),
    );
  }
}
