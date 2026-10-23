import 'package:flutter/material.dart';

import '../models/model_poem.dart';
import '../core/theme/colors.dart'; // Asegúrate de ajustar la ruta según tu estructura

class PoemCard extends StatelessWidget {
  final Poem poem;
  final VoidCallback onTap;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onDeleteTap;

  const PoemCard({
    Key? key,
    required this.poem,
    required this.onTap,
    required this.onWhatsAppTap,
    required this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDraft = poem.status == 'draft';
    // Colores tonales basados en el documento de diseño y AppColors
    final headerColor = isDraft
        ? AppColors.azulCrepusculo
        : AppColors.linoTenue;
    final statusText = isDraft ? 'Borrador' : 'Enviado';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow, // Papel pergamino claro (#F6F3EE)
        borderRadius: BorderRadius.circular(8), // Esquinas suavizadas de 8px
        border: Border.all(
          color: AppColors.primaryContainer.withValues(
            alpha: 0.08,
          ), // Línea capilar sutil
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera con metadatos y color tonal suave
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    statusText.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.06,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    poem.creationDay ?? '',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
            ),
            // Contenido del Poema
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poem.title,
                    style: const TextStyle(
                      fontFamily: 'EB Garamond',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    poem.textPoem,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'EB Garamond',
                      fontSize: 16,
                      height: 1.5,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Acciones rápidas inferiores
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          size: 20,
                          color: AppColors.primaryContainer,
                        ),
                        onPressed: onWhatsAppTap,
                        tooltip: 'Enviar por WhatsApp',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: AppColors.error,
                        ),
                        onPressed: onDeleteTap,
                        tooltip: 'Eliminar carta',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
