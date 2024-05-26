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
  late bool required;
  late String name;
  late String entity;
  late String value;
  late bool isList ;

  ParameterModel({
    required this.required,
    required this.name,
    required this.entity,
    required this.value,
    required this.isList
  });

  Map<String, dynamic> toMap() {
    return {
      'required' : required,
      'name': name,
      'entity' : entity,
      'value': value,
      'isList' : isList,
    };
  }
}
