import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const LabTwoApp());

class LabTwoApp extends StatelessWidget {
  const LabTwoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF14273B);
    return MaterialApp(
      title: 'Adaptive Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087E8B),
          surface: const Color(0xFFF7F8F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F8F5),
          foregroundColor: ink,
          centerTitle: false,
          elevation: 0,
        ),
      ),
      home: const AdaptiveProfilePage(),
    );
  }
}

class AdaptiveProfilePage extends StatefulWidget {
  const AdaptiveProfilePage({super.key});

  @override
  State<AdaptiveProfilePage> createState() => _AdaptiveProfilePageState();
}

class _AdaptiveProfilePageState extends State<AdaptiveProfilePage> {
  DateTime _selectedDate = DateTime(2003, 11, 21);
  String _selectedRole = 'Student';
  final List<String> _roles = const ['Student', 'Developer', 'Designer'];

  Future<void> _selectMaterialDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isAfter(today) ? today : _selectedDate,
      firstDate: DateTime(1950),
      lastDate: today,
      helpText: 'SELECT YOUR BIRTH DATE',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.grid_view_rounded, size: 20, color: Color(0xFF087E8B)),
            SizedBox(width: 9),
            Text(
              'FIELDNOTES',
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2.3,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Center(
              child: Text(
                _systemClockLabel(),
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF667786),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final wide =
              orientation == Orientation.landscape &&
              MediaQuery.sizeOf(context).width > 650;
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 11, child: _destinationPanel()),
                Expanded(
                  flex: 10,
                  child: SingleChildScrollView(
                    child: _detailsPanel(compact: true),
                  ),
                ),
              ],
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              _destinationPanel(height: 236),
              const SizedBox(height: 22),
              _studentDetails(),
              const SizedBox(height: 6),
              _titleSection(),
              _actionButtons(),
              _description(),
              _pickerControls(),
              const SizedBox(height: 18),
              _footerNote(),
            ],
          );
        },
      ),
    );
  }

  String _systemClockLabel() {
    final now = DateTime.now();
    final h = (now.hour % 12 == 0 ? 12 : now.hour % 12).toString().padLeft(
      2,
      '0',
    );
    final m = now.minute.toString().padLeft(2, '0');
    return 'SYSTEM  •  ${now.day} ${_month(now.month).toUpperCase()} ${now.year}  •  $h:$m ${now.hour >= 12 ? 'PM' : 'AM'}';
  }

  Widget _destinationPanel({double? height}) => ClipRRect(
    borderRadius: BorderRadius.circular(26),
    child: SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: AlpineLakePainter()),
          Positioned(
            left: 20,
            top: 18,
            child: _glassTag(
              icon: Icons.place_outlined,
              text: 'SWISS ALPS  /  46.5°N',
            ),
          ),
          const Positioned(
            left: 24,
            bottom: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THE QUIET\nSIDE OF SUMMER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    height: 1.04,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'A field note from the water’s edge',
                  style: TextStyle(color: Color(0xFFE7F1EF), fontSize: 12),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 18,
            bottom: 20,
            child: Icon(Icons.north_east_rounded, color: Colors.white70),
          ),
        ],
      ),
    ),
  );

  Widget _glassTag({required IconData icon, required String text}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .22),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.white.withValues(alpha: .28)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _studentDetails() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFE7ECEA)),
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE4F2EF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: Color(0xFF087E8B),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STUDENT DETAILS',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.6,
                  color: Color(0xFF71808A),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'LIEW YOU HENG',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF14273B),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F6F4),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            _selectedRole.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
              color: Color(0xFF087E8B),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _titleSection() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Oeschinen Lake',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.4,
                  color: Color(0xFF14273B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Kandersteg, Switzerland',
                style: TextStyle(fontSize: 13, color: Color(0xFF73808A)),
              ),
            ],
          ),
        ),
        const Icon(Icons.star_rounded, color: Color(0xFFF08A52), size: 20),
        const SizedBox(width: 5),
        const Text(
          '41',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF14273B),
          ),
        ),
      ],
    ),
  );

  Widget _actionButtons() => Row(
    children: [
      _action(Icons.route_rounded, 'ROUTE'),
      const SizedBox(width: 26),
      _action(Icons.bookmark_border_rounded, 'SAVE'),
      const SizedBox(width: 26),
      _action(Icons.share_outlined, 'SHARE'),
    ],
  );

  Widget _action(IconData icon, String label) => Expanded(
    child: Column(
      children: [
        Icon(icon, color: const Color(0xFF087E8B), size: 21),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            letterSpacing: 1.3,
            color: Color(0xFF087E8B),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _description() => const Padding(
    padding: EdgeInsets.only(top: 18, bottom: 20),
    child: Text(
      'A still, turquoise lake tucked beneath the peaks. Follow the shore trail in the morning, when the light slips across the water and the valley is quiet.',
      style: TextStyle(height: 1.55, color: Color(0xFF586A76), fontSize: 13),
    ),
  );

  Widget _pickerControls() => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFFE7ECEA)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.tune_rounded, size: 17, color: Color(0xFF087E8B)),
            SizedBox(width: 8),
            Text(
              'PROFILE PREFERENCES',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14273B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _dateField(),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _selectMaterialDate,
                icon: const Icon(Icons.calendar_month_rounded, size: 16),
                label: const Text('Material date'),
                style: _buttonStyle(),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _showCupertinoDatePicker,
                icon: const Icon(Icons.phone_iphone_rounded, size: 16),
                label: const Text('Cupertino date'),
                style: _buttonStyle(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, color: Color(0xFFE9EEEC)),
        const SizedBox(height: 13),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Your role',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF586A76),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DropdownButton<String>(
              value: _selectedRole,
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(14),
              items: _roles
                  .map(
                    (role) => DropdownMenuItem(value: role, child: Text(role)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedRole = value);
              },
            ),
            const SizedBox(width: 5),
            IconButton(
              onPressed: _showCupertinoRolePicker,
              tooltip: 'Cupertino wheel picker',
              icon: const Icon(
                Icons.view_carousel_outlined,
                color: Color(0xFF087E8B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        const Text(
          'Material dropdown  ·  Cupertino wheel picker',
          style: TextStyle(fontSize: 10, color: Color(0xFF89969D)),
        ),
      ],
    ),
  );

  ButtonStyle _buttonStyle() => OutlinedButton.styleFrom(
    foregroundColor: const Color(0xFF087E8B),
    side: const BorderSide(color: Color(0xFFDCE9E5)),
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 11),
    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
  );

  Widget _dateField() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    decoration: BoxDecoration(
      color: const Color(0xFFF6F8F6),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Row(
      children: [
        const Icon(Icons.event_outlined, size: 17, color: Color(0xFF82919A)),
        const SizedBox(width: 9),
        const Expanded(
          child: Text(
            'Birth date',
            style: TextStyle(fontSize: 12, color: Color(0xFF586A76)),
          ),
        ),
        Text(
          _formattedDate,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF14273B),
            fontSize: 12,
          ),
        ),
      ],
    ),
  );

  Widget _footerNote() => const Center(
    child: Text(
      'LAYOUT STUDY  /  MATERIAL × CUPERTINO',
      style: TextStyle(
        fontSize: 9,
        letterSpacing: 1.5,
        color: Color(0xFF99A3A7),
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _detailsPanel({required bool compact}) => Padding(
    padding: EdgeInsets.fromLTRB(
      compact ? 20 : 0,
      compact ? 16 : 0,
      compact ? 20 : 0,
      24,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _studentDetails(),
        const SizedBox(height: 8),
        _titleSection(),
        _actionButtons(),
        _description(),
        _pickerControls(),
        const SizedBox(height: 16),
        _footerNote(),
      ],
    ),
  );
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
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 4),
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
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  onPressed: onDone,
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    ),
  );
}

class AlpineLakePainter extends CustomPainter {
  const AlpineLakePainter();
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF547C86), Color(0xFFB9D0C5), Color(0xFF1F7180)],
        ).createShader(rect),
    );
    final sun = Paint()..color = const Color(0xFFF3D6A1).withValues(alpha: .92);
    canvas.drawCircle(
      Offset(size.width * .76, size.height * .22),
      size.width * .075,
      sun,
    );
    final distant = Path()
      ..moveTo(0, size.height * .58)
      ..lineTo(size.width * .19, size.height * .24)
      ..lineTo(size.width * .34, size.height * .55)
      ..lineTo(size.width * .5, size.height * .18)
      ..lineTo(size.width * .73, size.height * .58)
      ..lineTo(size.width * .88, size.height * .31)
      ..lineTo(size.width, size.height * .52)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(distant, Paint()..color = const Color(0xFF7B9998));
    final snow = Path()
      ..moveTo(size.width * .14, size.height * .33)
      ..lineTo(size.width * .19, size.height * .24)
      ..lineTo(size.width * .24, size.height * .36)
      ..lineTo(size.width * .20, size.height * .34)
      ..lineTo(size.width * .185, size.height * .38)
      ..lineTo(size.width * .17, size.height * .33)
      ..close();
    canvas.drawPath(
      snow,
      Paint()..color = const Color(0xFFDDE3D8).withValues(alpha: .8),
    );
    final shore = Path()
      ..moveTo(0, size.height * .56)
      ..cubicTo(
        size.width * .2,
        size.height * .49,
        size.width * .29,
        size.height * .65,
        size.width * .48,
        size.height * .58,
      )
      ..cubicTo(
        size.width * .67,
        size.height * .51,
        size.width * .8,
        size.height * .61,
        size.width,
        size.height * .52,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(shore, Paint()..color = const Color(0xFF176978));
    final reflection = Paint()
      ..color = const Color(0xFFB7D7CE).withValues(alpha: .44)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 12; i++) {
      final y = size.height * (.68 + i * .024);
      final x = size.width * (.12 + (i % 4) * .2);
      canvas.drawLine(
        Offset(x, y),
        Offset(x + size.width * (.08 + (i % 3) * .035), y),
        reflection,
      );
    }
    final pine = Paint()..color = const Color(0xFF234B4F);
    for (var i = 0; i < 7; i++) {
      final x = size.width * (.79 + i * .035);
      final y = size.height * (.49 + (i.isEven ? .02 : 0));
      final h = size.height * (.12 + (i % 3) * .025);
      final path = Path()
        ..moveTo(x, y - h)
        ..lineTo(x - h * .25, y)
        ..lineTo(x + h * .25, y)
        ..close();
      canvas.drawPath(path, pine);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
