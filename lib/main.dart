import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const StudentInfoApp());

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF3949AB);
    return MaterialApp(
      title: 'CSS3344 Lab 02 Student Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: indigo),
        scaffoldBackgroundColor: const Color(0xFFF5F6FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE8EAF6),
          foregroundColor: Color(0xFF202654),
          centerTitle: true,
        ),
      ),
      home: const StudentProfileScreen(),
    );
  }
}

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  static const _studentName = 'LIEW YOU HENG';
  static const _studentId = 'BCS24090001';
  static const _personalGoal = 'Never become the person you once disliked.';
  static const _roles = ['Student', 'Developer', 'Designer'];

  DateTime _selectedDate = DateTime.now();
  String _selectedRole = _roles.first;

  Future<void> _selectMaterialDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isAfter(today) ? today : _selectedDate,
      firstDate: DateTime(1950),
      lastDate: today,
      helpText: 'SELECT A DATE',
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _showCupertinoDatePicker() {
    final today = DateTime.now();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => _PickerSheet(
        title: 'Choose a date',
        onDone: () => Navigator.pop(sheetContext),
        child: SizedBox(
          height: 190,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate.isAfter(today)
                ? today
                : _selectedDate,
            minimumDate: DateTime(1950),
            maximumDate: today,
            onDateTimeChanged: (value) => setState(() => _selectedDate = value),
          ),
        ),
      ),
    );
  }

  void _showCupertinoRolePicker() {
    var selectedIndex = _roles.indexOf(_selectedRole);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => _PickerSheet(
        title: 'Choose your role',
        onDone: () {
          setState(() => _selectedRole = _roles[selectedIndex]);
          Navigator.pop(sheetContext);
        },
        child: SizedBox(
          height: 170,
          child: CupertinoPicker(
            itemExtent: 42,
            scrollController: FixedExtentScrollController(
              initialItem: selectedIndex,
            ),
            onSelectedItemChanged: (index) => selectedIndex = index,
            children: _roles.map((role) => Center(child: Text(role))).toList(),
          ),
        ),
      ),
    );
  }

  String get _formattedDate =>
      '${_selectedDate.day.toString().padLeft(2, '0')} ${_month(_selectedDate.month)} ${_selectedDate.year}';

  String _month(int month) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];

  String _systemClockLabel() {
    final now = DateTime.now();
    final hour = (now.hour % 12 == 0 ? 12 : now.hour % 12).toString().padLeft(
      2,
      '0',
    );
    final minute = now.minute.toString().padLeft(2, '0');
    return 'SYSTEM  •  ${now.day} ${_month(now.month).toUpperCase()} ${now.year}  •  $hour:$minute ${now.hour >= 12 ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CSS3344 Mobile App Dev - Lab 02',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          if (MediaQuery.sizeOf(context).width >= 650)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  _systemClockLabel(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF59627E),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final wide = MediaQuery.sizeOf(context).width >= 760;
            final profile = _StudentProfileCard(
              name: _studentName,
              studentId: _studentId,
              goal: _personalGoal,
            );
            final preferences = _PreferencesCard(
              formattedDate: _formattedDate,
              selectedRole: _selectedRole,
              roles: _roles,
              onMaterialDate: _selectMaterialDate,
              onCupertinoDate: _showCupertinoDatePicker,
              onRoleChanged: (value) {
                if (value != null) setState(() => _selectedRole = value);
              },
              onCupertinoRole: _showCupertinoRolePicker,
            );
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: wide && orientation == Orientation.landscape
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: profile),
                            const SizedBox(width: 20),
                            Expanded(child: preferences),
                          ],
                        )
                      : ListView(
                          children: [
                            profile,
                            const SizedBox(height: 16),
                            preferences,
                            const SizedBox(height: 12),
                            const _FooterNote(),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StudentProfileCard extends StatelessWidget {
  const _StudentProfileCard({
    required this.name,
    required this.studentId,
    required this.goal,
  });

  final String name;
  final String studentId;
  final String goal;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      shadowColor: colors.primary.withValues(alpha: .14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: colors.primary,
              child: const Icon(
                Icons.person_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF242949),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Student ID: $studentId',
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: Colors.grey.shade700),
            ),
            const Divider(height: 32, thickness: 1),
            Text(
              'Personal Life Goal / Quote',
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 9),
            Text(
              '“$goal”',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colors.primary,
                fontStyle: FontStyle.italic,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard({
    required this.formattedDate,
    required this.selectedRole,
    required this.roles,
    required this.onMaterialDate,
    required this.onCupertinoDate,
    required this.onRoleChanged,
    required this.onCupertinoRole,
  });

  final String formattedDate;
  final String selectedRole;
  final List<String> roles;
  final VoidCallback onMaterialDate;
  final VoidCallback onCupertinoDate;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onCupertinoRole;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.tune_rounded, color: colors.primary),
                const SizedBox(width: 9),
                Text(
                  'PROFILE PREFERENCES',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 17),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.event_outlined, size: 19, color: colors.primary),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('Selected date')),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onMaterialDate,
                    icon: const Icon(Icons.calendar_month_rounded, size: 17),
                    label: const Text('Material date'),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onCupertinoDate,
                    icon: const Icon(Icons.phone_iphone_rounded, size: 17),
                    label: const Text('Cupertino date'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(child: Text('Your role')),
                DropdownButton<String>(
                  value: selectedRole,
                  underline: const SizedBox.shrink(),
                  items: roles
                      .map(
                        (role) =>
                            DropdownMenuItem(value: role, child: Text(role)),
                      )
                      .toList(),
                  onChanged: onRoleChanged,
                ),
                IconButton(
                  onPressed: onCupertinoRole,
                  tooltip: 'Cupertino wheel picker',
                  icon: Icon(
                    Icons.view_carousel_outlined,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
            const Text(
              'Material dropdown  •  Cupertino wheel picker',
              style: TextStyle(fontSize: 11, color: Color(0xFF7B8196)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.onDone,
    required this.child,
  });

  final String title;
  final VoidCallback onDone;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: CupertinoColors.systemBackground,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                CupertinoButton(onPressed: onDone, child: const Text('Done')),
              ],
            ),
          ),
          child,
        ],
      ),
    ),
  );
}

class _FooterNote extends StatelessWidget {
  const _FooterNote();

  @override
  Widget build(BuildContext context) => const Center(
    child: Text(
      'LAB 01 STUDENT PROFILE  /  LAB 02 ADAPTIVE UI',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 10,
        letterSpacing: 1.1,
        color: Color(0xFF777D91),
      ),
    ),
  );
}

