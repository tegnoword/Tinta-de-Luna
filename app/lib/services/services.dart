import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class GraphQLService {
  static final HttpLink httpLink = HttpLink(
    'https://tinta-de-luna.onrender.com/graphql',
  );

  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );

  // --- QUERIES ---
  static const String fetchPoemsQuery = """
    query {
      getPoems {
        idPoem
        title
        textPoem
        status
        creationDay
        whatsappLink(phoneNumber: "584121234567") 
      }
    }
  """;

  // --- MUTACIONES ---
  static const String createPoemMutation = """
    mutation CreatePoem(\$title: String!, \$textPoem: String!) {
      createPoem(title: \$title, textPoem: \$textPoem) {
        idPoem
        title
        status
      }
    }
  """;

  static const String deletePoemMutation = """
    mutation DeletePoem(\$idPoem: Int!) {
      deletePoem(idPoem: \$idPoem)
    }
  """;
}
