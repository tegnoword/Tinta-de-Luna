class Poem {
  final int idPoem;
  final String title;
  final String textPoem;
  final String status;
  final String? creationDay;
  final String? whatsappLink;

  Poem({
    required this.idPoem,
    required this.title,
    required this.textPoem,
    required this.status,
    this.creationDay,
    this.whatsappLink,
  });

  factory Poem.fromJson(Map<String, dynamic> json) {
    return Poem(
      idPoem: json['idPoem'] ?? json['id_poem'],
      title: json['title'] ?? '',
      textPoem: json['textPoem'] ?? json['text_poem'] ?? '',
      status: json['status'] ?? 'draft',
      creationDay: json['creationDay'] ?? json['creation_day'],
      whatsappLink: json['whatsappLink'],
    );
  }
}
