import 'package:flutter/material.dart';
import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdjustValues extends StatefulWidget {
  const AdjustValues({Key? key}) : super(key: key);

  @override
  _AdjustValuesState createState() => _AdjustValuesState();
}

class _AdjustValuesState extends State<AdjustValues> {
  late String _selectedOption;
  late TextEditingController _minController;
  late TextEditingController _maxController;
  String? _minErrorText;
  String? _maxErrorText;

  @override
  void initState() {
    super.initState();
    _selectedOption = '';
    _minController = TextEditingController();
    _maxController = TextEditingController();
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adjust vital sign values'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOptionButton('Modify Heart Rate', 'Heart Rate'),
            SizedBox(height: 8),
            _buildOptionButton('Modify Temperature', 'Temperature'),
            SizedBox(height: 8),
            _buildOptionButton('Modify Oxygen Level', 'Oxygen Level'),
            SizedBox(height: 24),
            if (_selectedOption.isNotEmpty)
              _buildTextFormFields(option: _selectedOption),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, String option) {
    return ElevatedButton(
      onPressed: () {
        _selectOption(option);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.accent1,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
      _minController.text = '';
      _maxController.text = '';
      _minErrorText = null;
      _maxErrorText = null;
    });
  }

  Widget _buildTextFormFields({required String option}) {
    late String minLabel;
    late String maxLabel;
    bool isMaxVisible = true;

    switch (option) {
      case 'Heart Rate':
        minLabel = 'Minimum heart rate';
        maxLabel = 'Maximum heart rate';
        break;
      case 'Temperature':
        minLabel = 'Minimum temperature';
        maxLabel = 'Maximum temperature';
        break;
      case 'Oxygen Level':
        minLabel = 'Oxygen level limit';
        maxLabel = ''; // No max for Oxygen Level
        isMaxVisible = false;
        break;
      default:
        minLabel = '';
        maxLabel = '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modify $option',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        _buildTextField(controller: _minController, label: minLabel, isRequired: true, errorText: _minErrorText),
        if (isMaxVisible) // Conditionally show the maximum field
          SizedBox(height: 8),
        if (isMaxVisible)
          _buildTextField(controller: _maxController, label: maxLabel, isRequired: true, errorText: _maxErrorText),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildButton('Confirm', TColors.accent1, _confirmChanges),
            _buildButton('Cancel', TColors.accent1, _cancelChanges),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isRequired,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label,
            suffixText: isRequired ? '*' : '', // Add asterisk to indicate required field
            errorText: errorText, // Display error text
          ),
          validator: (value) {
            if (isRequired && value!.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        if (errorText != null) // Display error text in red
          Text(
            errorText,
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 90,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
        child: Text(text),
      ),
    );
  }

  void _confirmChanges() {
    String? minErrorText;
    String? maxErrorText;

    if (_minController.text.isEmpty) {
      minErrorText = 'Please enter a value';
    }

    if (_maxController.text.isEmpty) {
      maxErrorText = 'Please enter a value';
    }

    setState(() {
      // Update error message for text fields
      _minErrorText = minErrorText;
      _maxErrorText = maxErrorText;
    });

    if (minErrorText == null && maxErrorText == null) {
      // If no error message, then fields are valid, implement save logic here
      String min = _minController.text;
      String max = _maxController.text;
      // Save the values to wherever they need to be stored
      print('Minimum Value: $min');
      print('Maximum Value: $max');

      // After save logic, reset text fields
      _minController.clear();
      _maxController.clear();
      // Reset selected option
      setState(() {
        _selectedOption = '';
      });
    }
  }

  void _cancelChanges() {
    setState(() {
      _selectedOption = ''; // Reset selected option
    });
  }
}