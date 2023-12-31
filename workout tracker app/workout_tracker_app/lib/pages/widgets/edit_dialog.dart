import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  final Function(String) onEdit;
  final String initialText;
  const EditDialog({
    Key? key,
    required this.onEdit,
    required this.initialText,
  }) : super(key: key);

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildDialogTitle(),
      content: _buildDialogContent(),
      actions: _buildDialogActions(context),
    );
  }

  Text _buildDialogTitle() {
    return const Text('Edit');
  }

  TextField _buildDialogContent() {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(hintText: "Title"),
    );
  }

  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      _buildSaveButton(context),
      _buildCancelButton(context),
    ];
  }

  TextButton _buildSaveButton(BuildContext context) {
    return TextButton(
      onPressed: () => _handleSave(context),
      child: const Text('Save'),
    );
  }

  TextButton _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Cancel'),
    );
  }

  void _handleSave(BuildContext context) {
    if (controller.text.isNotEmpty) {
      widget.onEdit(controller.text);
      Navigator.of(context).pop();
    }
  }
}
