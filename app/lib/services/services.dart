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
    query FetchPoems(\$phoneNumber: String) {
      getPoems {
        idPoem
        title
        textPoem
        status
        creationDay
        whatsappLink(phoneNumber: \$phoneNumber)
      }
    }
  """;

  // --- MUTACIONES ---
  static const String createPoemMutation = """
    mutation CreatePoem(\$input: PoemInput!) {
      createPoem(input: \$input) {
        idPoem
        title
        textPoem
        status
        creationDay
      }
    }
  """;

  // Mutación adaptada para usar PoemUpdateInput en el backend
  static const String updatePoemStatusMutation = """
    mutation UpdatePoemStatus(\$input: PoemUpdateInput!) {
      updatePoem(input: \$input) {
        idPoem
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
