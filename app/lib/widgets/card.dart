import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/model_poem.dart';
import '../core/theme/colors.dart';
import '../services/services.dart';

class PoemCard extends StatelessWidget {
  final Poem poem;
  final VoidCallback onTap;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onDeleteTap;

  const PoemCard({
    super.key,
    required this.poem,
    required this.onTap,
    required this.onWhatsAppTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDraft = poem.status == 'draft';
    final headerColor = isDraft
        ? AppColors.azulCrepusculo
        : AppColors.linoTenue;
    final statusText = isDraft ? 'Borrador' : 'Enviado';

    return Mutation(
      options: MutationOptions(
        document: gql(GraphQLService.updatePoemStatusMutation),
        onCompleted: (data) {
          // Estado actualizado con éxito en el backend
        },
      ),
      builder: (RunMutation runMutation, QueryResult? result) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primaryContainer.withValues(alpha: 0.08),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                            onPressed: () {
                              // Actualiza el estado a 'sent' en la base de datos
                              runMutation({
                                'idPoem': poem.idPoem,
                                'status': 'sent',
                              });
                              // Ejecuta la lógica de WhatsApp existente
                              onWhatsAppTap();
                            },
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
      },
    );
  }
}
