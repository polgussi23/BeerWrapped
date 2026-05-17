// screens/groups/create_meetup_screen.dart
import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/components/groups/group_cancel_button.dart';
import 'package:birrawrapped/services/groups_service.dart';
import 'package:flutter/material.dart';

class CreateMeetupScreen extends StatefulWidget {
  const CreateMeetupScreen({Key? key}) : super(key: key);

  @override
  _CreateMeetupScreenState createState() => _CreateMeetupScreenState();
}

class _CreateMeetupScreenState extends State<CreateMeetupScreen> {
  final _locationController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFB5884C),
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFB5884C),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _createMeetup() async {
    if (_selectedDate == null) {
      setState(() => _errorMessage = 'Cal seleccionar una data');
      return;
    }
    if (_selectedTime == null) {
      setState(() => _errorMessage = 'Cal seleccionar una hora');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final group =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      final dateStr =
          '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
      final timeStr =
          '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

      await GroupsService().createMeetup(
        group['id'].toString(),
        dateStr,
        timeStr,
        _locationController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() =>
          _errorMessage = 'Error al crear la quedada. Torna-ho a intentar.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final group =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomSmallTitle(text: "Nova quedada"),
                  const SizedBox(height: 8),
                  Text(
                    group['name'],
                    style: const TextStyle(
                      fontFamily: 'Kameron',
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Selector de data
                  _SelectorButton(
                    icon: Icons.calendar_today,
                    label: _selectedDate == null
                        ? 'Selecciona una data'
                        : '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                            '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                            '${_selectedDate!.year}',
                    onTap: _pickDate,
                    hasValue: _selectedDate != null,
                  ),
                  const SizedBox(height: 12),

                  // Selector d'hora
                  _SelectorButton(
                    icon: Icons.access_time,
                    label: _selectedTime == null
                        ? 'Selecciona una hora'
                        : '${_selectedTime!.hour.toString().padLeft(2, '0')}:'
                            '${_selectedTime!.minute.toString().padLeft(2, '0')}',
                    onTap: _pickTime,
                    hasValue: _selectedTime != null,
                  ),
                  const SizedBox(height: 12),

                  // Lloc (opcional)
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Lloc (opcional)',
                      hintText: 'Ex: Bar l\'Artiga',
                      prefixIcon: const Icon(Icons.location_on,
                          color: Color(0xFFB5884C)),
                      filled: true,
                      fillColor: const Color(0xFFEDE4D3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createMeetup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB5884C),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Crear quedada',
                              style: TextStyle(
                                fontFamily: 'Kameron',
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const GroupCancelButton()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget privat per als selectors de data i hora
class _SelectorButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool hasValue;

  const _SelectorButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.hasValue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE4D3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: hasValue ? const Color(0xFFB5884C) : Colors.black45),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 16,
                color: hasValue ? Colors.black87 : Colors.black45,
                fontWeight: hasValue ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
