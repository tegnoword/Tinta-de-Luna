import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/theme/colors.dart';
import '../models/model_poem.dart';
import '../services/services.dart';
import '../widgets/bar.dart';
import '../widgets/card.dart';
import 'edict.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String selectedFilter = 'all'; // 'all', 'draft', 'sent'

  void _openWhatsApp(String? link) async {
    if (link == null || link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se generó el enlace de WhatsApp.')),
      );
      return;
    }
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir WhatsApp.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabecera / Título Principal
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tinta de Luna',
                        style: TextStyle(
                          fontFamily: 'EB Garamond',
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryContainer,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.linoTenue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.nightlight_round,
                              size: 14,
                              color: AppColors.primaryContainer,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Versos',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Filtros de Estado (Chips)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'Todos'),
                      const SizedBox(width: 8),
                      _buildFilterChip('draft', 'Borradores'),
                      const SizedBox(width: 8),
                      _buildFilterChip('sent', 'Enviados'),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Lista Dinámica con Query GraphQL
                Expanded(
                  child: Query(
                    options: QueryOptions(
                      document: gql(GraphQLService.fetchPoemsQuery),
                      pollInterval: const Duration(seconds: 10),
                      fetchPolicy: FetchPolicy.cacheAndNetwork,
                    ),
                    builder:
                        (
                          QueryResult result, {
                          FetchMore? fetchMore,
                          Refetch? refetch,
                        }) {
                          if (result.hasException) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  'Error al conectar con la luna:\n${result.exception.toString()}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: AppColors.error,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            );
                          }

                          if (result.isLoading && result.data == null) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryContainer,
                                strokeWidth: 2,
                              ),
                            );
                          }

                          final List poemsRaw = result.data?['getPoems'] ?? [];
                          List<Poem> poems = poemsRaw
                              .map((e) => Poem.fromJson(e))
                              .toList();

                          // Aplicar filtro local
                          if (selectedFilter != 'all') {
                            poems = poems
                                .where((p) => p.status == selectedFilter)
                                .toList();
                          }

                          if (poems.isEmpty) {
                            return const Center(
                              child: Text(
                                'No hay cartas poéticas aún.\nPresiona + para redactar la primera.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'EB Garamond',
                                  fontSize: 18,
                                  color: AppColors.outline,
                                ),
                              ),
                            );
                          }

                          // Envolvemos con las mutaciones necesarias para borrar y actualizar estado
                          return Mutation(
                            options: MutationOptions(
                              document: gql(GraphQLService.deletePoemMutation),
                              onCompleted: (data) {
                                if (refetch != null) refetch();
                              },
                            ),
                            builder: (RunMutation runDeleteMutation, _) {
                              return Mutation(
                                options: MutationOptions(
                                  document: gql(
                                    GraphQLService.updatePoemStatusMutation,
                                  ),
                                  onCompleted: (data) {
                                    // Forzamos la recarga inmediata de la query para refrescar la UI
                                    if (refetch != null) refetch();
                                  },
                                ),
                                builder:
                                    (RunMutation runUpdateStatusMutation, _) {
                                      return ListView.builder(
                                        padding: const EdgeInsets.only(
                                          bottom: 100,
                                          top: 8,
                                        ),
                                        itemCount: poems.length,
                                        itemBuilder: (context, index) {
                                          final poem = poems[index];
                                          return PoemCard(
                                            poem: poem,
                                            onTap: () async {
                                              final navResult =
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditorView(
                                                            idPoem: poem.idPoem,
                                                            initialTitle:
                                                                poem.title,
                                                            initialText:
                                                                poem.textPoem,
                                                          ),
                                                    ),
                                                  );
                                              if (navResult == true &&
                                                  refetch != null) {
                                                refetch();
                                              }
                                            },
                                            onWhatsAppTap: () {
                                              // 1. Actualizamos el estado enviando el input completo requerido por el backend
                                              runUpdateStatusMutation({
                                                'input': {
                                                  'idPoem': poem.idPoem,
                                                  'title': poem.title,
                                                  'textPoem': poem.textPoem,
                                                  'status': 'sent',
                                                },
                                              });
                                              // 2. Abrimos WhatsApp
                                              _openWhatsApp(poem.whatsappLink);
                                            },
                                            onDeleteTap: () {
                                              _showDeleteDialog(
                                                context,
                                                poem.idPoem,
                                                runDeleteMutation,
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                              );
                            },
                          );
                        },
                  ),
                ),
              ],
            ),

            // Navigation Bar Flotante
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: RudderBar(
                onHomeTap: () {},
                onAddTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditorView()),
                  );
                },
                onProfileTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer
              : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.surface : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    int idPoem,
    RunMutation runDeleteMutation,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        title: const Text(
          '¿Eliminar carta?',
          style: TextStyle(fontFamily: 'EB Garamond', fontSize: 22),
        ),
        content: const Text(
          'Esta acción borrará este poema de la base de datos de manera permanente.',
          style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.outline),
            ),
          ),
          TextButton(
            onPressed: () {
              runDeleteMutation({'idPoem': idPoem});
              Navigator.pop(context);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
