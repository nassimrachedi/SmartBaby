class IntentModel {
  late String question;
  late String action;
  late List<ParameterModel> parameters;
  late List<String> responses;

  IntentModel({
    required this.question,
    required this.action,
    required this.parameters,
    required this.responses,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'action': action,
      'parameters': parameters.map((param) => param.toMap()).toList(),
      'responses': responses,
    };
  }
}

class ParameterModel {
  late String name;
  late String value;

  ParameterModel({required this.name, required this.value});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
    };
  }
}
