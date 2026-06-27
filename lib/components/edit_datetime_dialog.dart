import 'package:flutter/material.dart';

class EditDateTimeDialog extends StatefulWidget {
  final DateTime initialDate;
  final TimeOfDay initialTime;
  final Future<void> Function(DateTime date, TimeOfDay time) onSave;

  const EditDateTimeDialog({
    Key? key,
    required this.initialDate,
    required this.initialTime,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditDateTimeDialog> createState() => _EditDateTimeDialogState();
}

class _EditDateTimeDialogState extends State<EditDateTimeDialog> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _isSaving = false;

  static const _accentColor = Color(0xFFB5884C);
  static const _backgroundColor = Color(0xFFEDE4D3);

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedTime = widget.initialTime;
  }

  ThemeData _pickerTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      colorScheme: const ColorScheme.light(
        primary: _accentColor,
        onPrimary: Colors.white,
        onSurface: Colors.black87,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _accentColor),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) =>
          Theme(data: _pickerTheme(context), child: child!),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) =>
          Theme(data: _pickerTheme(context), child: child!),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Modificar data i hora',
        style: TextStyle(fontFamily: 'Kameron', fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSelectorTile(
            icon: Icons.calendar_today,
            label: 'Data',
            value:
                '${_two(_selectedDate.day)}/${_two(_selectedDate.month)}/${_selectedDate.year}',
            onTap: _isSaving ? null : _pickDate,
          ),
          const SizedBox(height: 12),
          _buildSelectorTile(
            icon: Icons.access_time,
            label: 'Hora',
            value: '${_two(_selectedTime.hour)}:${_two(_selectedTime.minute)}',
            onTap: _isSaving ? null : _pickTime,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child:
              const Text('Cancel·lar', style: TextStyle(fontFamily: 'Kameron')),
        ),
        TextButton(
          onPressed: _isSaving
              ? null
              : () async {
                  setState(() => _isSaving = true);
                  await widget.onSave(_selectedDate, _selectedTime);
                  if (mounted) Navigator.pop(context);
                },
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(
                  'Guardar',
                  style: TextStyle(
                    fontFamily: 'Kameron',
                    fontWeight: FontWeight.bold,
                    color: _accentColor,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSelectorTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _accentColor.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Icon(icon, color: _accentColor, size: 20),
            const SizedBox(width: 10),
            Text(label,
                style: const TextStyle(
                    fontFamily: 'Kameron', fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                    fontFamily: 'Kameron', color: Colors.black54)),
            const SizedBox(width: 6),
            const Icon(Icons.edit, size: 16, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
