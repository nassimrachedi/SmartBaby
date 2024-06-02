enum IntentState {
  Acceptee,
  Refusee,
  EnAttente
}



class IntentModel {
  final String question;
  final List<String> responses;
  final IntentState state;

  IntentModel({
    required this.question,
    required this.responses,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'responses': responses,
      'state' : state.toString(),
    };
  }
}
