import 'package:flutter/material.dart';

class ModelOptionsDialog extends StatefulWidget {
  final String initialUserData;
  final String initialSize;
  final bool initialScaleEnable;
  final GlobalKey<FormState> formKey;
  final void Function(
    String initialUserData,
    String initialSize, {
    required bool initialScaleEnable,
  }) onAddModel;

  const ModelOptionsDialog({
    required this.initialUserData,
    required this.initialSize,
    required this.initialScaleEnable,
    required this.formKey,
    required this.onAddModel,
    super.key,
  });

  @override
  ModelOptionsDialogState createState() => ModelOptionsDialogState();
}

class ModelOptionsDialogState extends State<ModelOptionsDialog> {
  late TextEditingController userDataController;
  late TextEditingController sizeController;
  late ValueNotifier<bool> scaleEnableController;

  @override
  void initState() {
    super.initState();
    userDataController = TextEditingController(text: widget.initialUserData);
    sizeController = TextEditingController(text: widget.initialSize);
    scaleEnableController = ValueNotifier<bool>(widget.initialScaleEnable);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Model options'),
      content: Form(
        key: widget.formKey,
        child: SizedBox(
          height: 350,
          width: 50,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                title: TextField(
                  controller: userDataController,
                  decoration: const InputDecoration(
                    labelText: 'UserData',
                  ),
                ),
              ),
              ListTile(
                title: ValueListenableBuilder<bool>(
                  valueListenable: scaleEnableController,
                  builder: (context, scaleEnableValue, child) {
                    return TextFormField(
                      controller: sizeController,
                      decoration: InputDecoration(
                        labelText:
                            'Model size in (${scaleEnableValue ? 'scale' : 'pixel'})',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value for model size';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid double';
                        }
                        return null;
                      },
                    );
                  },
                ),
              ),
              ListTile(
                title: ValueListenableBuilder<bool>(
                  valueListenable: scaleEnableController,
                  builder: (context, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enable scale',
                          style: TextStyle(fontSize: 16),
                        ),
                        Switch(
                          value: value,
                          onChanged: (newValue) {
                            scaleEnableController.value = newValue;
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.formKey.currentState!.validate()) {
              widget.onAddModel(
                userDataController.text,
                sizeController.text,
                initialScaleEnable: scaleEnableController.value,
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add Model'),
        ),
      ],
    );
  }
}
