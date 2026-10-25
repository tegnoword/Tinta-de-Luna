import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../core/theme/colors.dart';
import '../services/services.dart';

class EditorView extends StatefulWidget {
  final int? idPoem;
  final String? initialTitle;
  final String? initialText;

  const EditorView({
    super.key,
    this.idPoem,
    this.initialTitle,
    this.initialText,
  });

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  late TextEditingController _titleController;
  late TextEditingController _textController;

  final List<String> _inspirationPrompts = [
    'A la luz de la medianoche...',
    'Sobre el papel de algodón...',
    'El murmullo del viento dice...',
    'Como la luna sobre la marea...',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _textController = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryContainer,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Taller de Escritura',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.04,
            color: AppColors.primaryContainer,
          ),
        ),
        centerTitle: true,
        actions: [
          Mutation(
            options: MutationOptions(
              document: gql(GraphQLService.createPoemMutation),
              onCompleted: (data) {
                if (data != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Verso guardado con éxito 🌙'),
                      backgroundColor: AppColors.primaryContainer,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(
                    context,
                    true,
                  ); // Regresa e indica actualización
                }
              },
            ),
            builder: (RunMutation runMutation, QueryResult? result) {
              final isLoading = result?.isLoading ?? false;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          final title = _titleController.text.trim();
                          final textPoem = _textController.text.trim();

                          if (title.isEmpty || textPoem.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Por favor escribe un título y un poema.',
                                ),
                              ),
                            );
                            return;
                          }

                          // CORRECCIÓN: Envuelto en 'input' para cumplir con PoemInput!
                          runMutation({
                            'input': {
                              'title': title,
                              'textPoem': textPoem,
                              'status': 'draft',
                            },
                          });
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryContainer,
                          ),
                        )
                      : const Text(
                          'Guardar',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryContainer,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo de Título (Serifa elegante)
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontFamily: 'EB Garamond',
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryContainer,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Título del verso...',
                        hintStyle: TextStyle(
                          fontFamily: 'EB Garamond',
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: AppColors.outlineVariant,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Línea capilar de separación sutil
                    Container(
                      height: 1,
                      color: AppColors.primaryContainer.withValues(alpha: 0.08),
                    ),

                    const SizedBox(height: 20),

                    // Área del Poema (Lienzo amplio)
                    TextField(
                      controller: _textController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(
                        fontFamily: 'EB Garamond',
                        fontSize: 19,
                        height: 1.6,
                        color: AppColors.onSurfaceVariant,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Escribe aquí tus versos en la penumbra...',
                        hintStyle: TextStyle(
                          fontFamily: 'EB Garamond',
                          fontSize: 19,
                          height: 1.6,
                          color: AppColors.outlineVariant,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Carrusel / Chips de Inspiración en la parte inferior
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                border: Border(
                  top: BorderSide(
                    color: AppColors.primaryContainer.withValues(alpha: 0.06),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Text(
                      'Destellos de Inspiración',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.outline,
                        letterSpacing: 0.04,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _inspirationPrompts.length,
                      itemBuilder: (context, index) {
                        final prompt = _inspirationPrompts[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            backgroundColor: AppColors.linoTenue,
                            side: BorderSide.none,
                            label: Text(
                              prompt,
                              style: const TextStyle(
                                fontFamily: 'EB Garamond',
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: AppColors.primaryContainer,
                              ),
                            ),
                            onPressed: () {
                              if (_textController.text.isEmpty) {
                                _textController.text = prompt;
                              } else {
                                _textController.text =
                                    '${_textController.text}\n$prompt';
                              }
                              // Coloca el cursor al final
                              _textController.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _textController.text.length,
                                    ),
                                  );
                            },
                          ),
                        );
                      },
                    ),
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
