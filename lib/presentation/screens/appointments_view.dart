import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:julian_medical_center/presentation/theme/app_theme.dart';
import 'package:julian_medical_center/data/models/appointment_model.dart';
import 'package:julian_medical_center/providers/appointment_provider.dart';

class AppointmentsView extends ConsumerStatefulWidget {
  final VoidCallback? onClose;
  final bool isModal;

  const AppointmentsView({
    super.key,
    this.onClose,
    this.isModal = false,
  });

  @override
  ConsumerState<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends ConsumerState<AppointmentsView> {
  int _currentStep = 1;
  String _selectedDept = '';
  String _selectedDoctor = '';
  String _reason = '';

  // Calendar State
  late DateTime _calendarDate;
  int? _selectedDay;
  String? _selectedTimeSlot;

  // Checklist compliance states
  bool _noFever = false;
  bool _wearMask = false;
  bool _noticePolicy = false;
  bool _infoCorrect = false;

  bool _isSuccess = false;

  final List<String> _departments = [
    "General Practice", "Cardiology", "Pediatrics", "Orthopedics",
    "Dermatology", "Neurology", "Obstetrics & Gynecology", "Ophthalmology",
  ];

  final Map<String, List<String>> _doctors = {
    "General Practice": ["Dr. Sarah Chen", "Dr. Marcus Patel"],
    "Cardiology": ["Dr. James Okafor", "Dr. Lena Hartmann"],
    "Pediatrics": ["Dr. Priya Sharma", "Dr. Carlos Rivera"],
    "Orthopedics": ["Dr. William Tran", "Dr. Amina Hassan"],
    "Dermatology": ["Dr. Sofia Nguyen"],
    "Neurology": ["Dr. Ethan Brooks"],
    "Obstetrics & Gynecology": ["Dr. Fatima Al-Rashid"],
    "Ophthalmology": ["Dr. Henry Kim"],
  };

  final List<String> _morningSlots = ["8:00 AM", "8:30 AM", "9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM"];
  final List<String> _afternoonSlots = ["1:00 PM", "1:30 PM", "2:00 PM", "2:30 PM", "3:00 PM", "3:30 PM", "4:00 PM", "4:30 PM"];
  final Set<String> _unavailableSlots = {"9:00 AM", "10:30 AM", "2:00 PM", "3:30 PM"};

  @override
  void initState() {
    super.initState();
    _calendarDate = DateTime.now();
  }

  bool _canNext() {
    if (_currentStep == 1) return _selectedDept.isNotEmpty && _selectedDoctor.isNotEmpty;
    if (_currentStep == 2) return _selectedDay != null && _selectedTimeSlot != null;
    if (_currentStep == 3) return _noFever && _wearMask && _noticePolicy && _infoCorrect;
    return true;
  }

  void _nextStep() {
    if (_currentStep < 3 && _canNext()) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  void _submit() async {
    if (!_canNext()) return;

    final appt = AppointmentModel(
      id: 0,
      category: 'Routine Consultation',
      appointmentStatus: 'upcoming',
      patient: 'Emma Thompson', // Logged in patient name (hardcoded/demo session)
      doctor: _selectedDoctor,
      type: 'Routine Consultation',
      date: '${_getMonthName(_calendarDate.month)} ${_selectedDay ?? 1}, ${_calendarDate.year}',
      createdAt: DateTime.now(),
      department: _selectedDept,
      cancellationReason: _reason.isNotEmpty ? _reason : null,
    );

    // Call state notifier method
    await ref.read(appointmentListProvider.notifier).addAppointment(appt);
    setState(() => _isSuccess = true);
  }

  String _getMonthName(int month) {
    const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) {
      return _buildSuccessView();
    }

    return Scaffold(
      appBar: widget.isModal
          ? PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.highlightBlue, AppTheme.highlightTeal]),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Book Appointment", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              if (widget.onClose != null)
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.white, size: 18),
                  onPressed: widget.onClose,
                )
            ],
          ),
        ),
      )
          : null,
      body: Column(
        children: [
          // Step progress indicator bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _stepIndicator(1, "Select Doctor"),
                _stepDivider(),
                _stepIndicator(2, "Date & Time"),
                _stepDivider(),
                _stepIndicator(3, "Confirm"),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main form content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildActiveStep(),
            ),
          ),

          // Stepper actions footer
          const Divider(height: 1),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 1)
                  OutlinedButton.icon(
                    onPressed: _prevStep,
                    icon: const Icon(LucideIcons.chevronLeft, size: 14),
                    label: const Text("Back"),
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  )
                else
                  const SizedBox(),
                ElevatedButton(
                  onPressed: _canNext() ? (_currentStep == 3 ? _submit : _nextStep) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.highlightBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    elevation: 0,
                  ),
                  child: Text(_currentStep == 3 ? "Confirm & Book" : "Continue"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepIndicator(int step, String label) {
    final isActive = _currentStep == step;
    final isDone = _currentStep > step;
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: isDone ? AppTheme.stableGreen : (isActive ? AppTheme.highlightBlue : Colors.white),
            border: Border.all(color: isActive || isDone ? Colors.transparent : AppTheme.softBorder, width: 1.5),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: isDone
              ? const Icon(LucideIcons.check, color: Colors.white, size: 12)
              : Text(step.toString(), style: TextStyle(color: isActive ? Colors.white : AppTheme.textGray, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.outfit(fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? AppTheme.primaryNavy : AppTheme.textGray)),
      ],
    );
  }

  Widget _stepDivider() {
    return Container(width: 32, height: 1, color: AppTheme.softBorder, margin: const EdgeInsets.symmetric(horizontal: 8));
  }

  Widget _buildActiveView() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return const SizedBox();
    }
  }

  Widget _buildActiveStep() {
    return _buildActiveView();
  }

  // ─── STEP 1: DOCTOR & DEPARTMENT ──────────────────────────────────────────
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Department / Specialty", style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.8,
          children: _departments.map((d) {
            final isSel = _selectedDept == d;
            return InkWell(
              onTap: () => setState(() {
                _selectedDept = d;
                _selectedDoctor = '';
              }),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSel ? const Color(0xFFF0F6FF) : Colors.white,
                  border: Border.all(color: isSel ? AppTheme.highlightBlue : AppTheme.softBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                child: Text(d, style: GoogleFonts.outfit(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.w500, color: isSel ? AppTheme.highlightBlue : AppTheme.primaryNavy)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        if (_selectedDept.isNotEmpty) ...[
          Text("Select Doctor", style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _doctors[_selectedDept]?.length ?? 0,
            itemBuilder: (context, idx) {
              final docName = _doctors[_selectedDept]![idx];
              final isSel = _selectedDoctor == docName;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => setState(() => _selectedDoctor = docName),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSel ? const Color(0xFFF0F6FF) : Colors.white,
                      border: Border.all(color: isSel ? AppTheme.highlightBlue : AppTheme.softBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFE8F0FB),
                          child: Text(docName.split(" ").last[0], style: const TextStyle(color: AppTheme.highlightBlue, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(docName, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                            Text(_selectedDept, style: const TextStyle(fontSize: 11, color: AppTheme.textGray)),
                          ],
                        ),
                        if (isSel)
                          const Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(LucideIcons.check, color: AppTheme.highlightBlue, size: 16),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],

        Text("Reason for Visit (optional)", style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: 3,
          onChanged: (v) => _reason = v,
          decoration: const InputDecoration(hintText: "Describe symptoms or consult reason..."),
        ),
      ],
    );
  }

  // ─── STEP 2: INTERACTIVE CALENDAR & TIME SLOTS ─────────────────────────────
  Widget _buildStep2() {
    final daysInMonth = DateUtils.getDaysInMonth(_calendarDate.year, _calendarDate.month);
    final firstDayOffset = DateTime(_calendarDate.year, _calendarDate.month, 1).weekday % 7; // offset Sunday=0

    final weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Calendar Grid Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(LucideIcons.chevronLeft, size: 16),
              onPressed: () => setState(() {
                _calendarDate = DateTime(_calendarDate.year, _calendarDate.month - 1);
                _selectedDay = null;
                _selectedTimeSlot = null;
              }),
            ),
            Text(
              "${_getMonthName(_calendarDate.month)} ${_calendarDate.year}",
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
            ),
            IconButton(
              icon: const Icon(LucideIcons.chevronRight, size: 16),
              onPressed: () => setState(() {
                _calendarDate = DateTime(_calendarDate.year, _calendarDate.month + 1);
                _selectedDay = null;
                _selectedTimeSlot = null;
              }),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Weekday labels
        Row(
          children: weekdays.map((day) {
            return Expanded(
              child: Center(
                child: Text(day, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textGray)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),

        // Grid Calendar Cells
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
          itemCount: daysInMonth + firstDayOffset,
          itemBuilder: (context, index) {
            if (index < firstDayOffset) return const SizedBox();

            final day = index - firstDayOffset + 1;
            final date = DateTime(_calendarDate.year, _calendarDate.month, day);
            final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));

            final isSelected = _selectedDay == day;

            return Center(
              child: MouseRegion(
                cursor: isPast ? SystemMouseCursors.basic : SystemMouseCursors.click,
                child: InkWell(
                  onTap: isPast
                      ? null
                      : () => setState(() {
                    _selectedDay = day;
                    _selectedTimeSlot = null;
                  }),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.highlightBlue : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      day.toString(),
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPast ? AppTheme.textGray.withOpacity(0.3) : (isSelected ? Colors.white : AppTheme.primaryNavy),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),

        // Time slots chip selection
        if (_selectedDay != null) ...[
          Text("Morning Slots", style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textGray, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _morningSlots.map((slot) => _slotChip(slot)).toList(),
          ),
          const SizedBox(height: 18),
          Text("Afternoon Slots", style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textGray, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _afternoonSlots.map((slot) => _slotChip(slot)).toList(),
          ),
        ]
      ],
    );
  }

  Widget _slotChip(String slot) {
    final isSelected = _selectedTimeSlot == slot;
    final isUnavailable = _unavailableSlots.contains(slot);

    return MouseRegion(
      cursor: isUnavailable ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: ChoiceChip(
        label: Text(slot),
        selected: isSelected,
        disabledColor: const Color(0xFFF1F5F9),
        selectedColor: AppTheme.highlightBlue,
        backgroundColor: Colors.white,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          fontSize: 11,
          color: isUnavailable
              ? AppTheme.textGray.withOpacity(0.4)
              : (isSelected ? Colors.white : AppTheme.primaryNavy),
          decoration: isUnavailable ? TextDecoration.lineThrough : null,
        ),
        onSelected: isUnavailable
            ? null
            : (selected) {
          setState(() => _selectedTimeSlot = slot);
        },
      ),
    );
  }

  // ─── STEP 3: COMPLIANCE CHECKLIST & PREVIEW ────────────────────────────────
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Review Booking Details", style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFF4F7FB), borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _reviewRow(LucideIcons.stethoscope, "Department", _selectedDept),
              const Divider(height: 24),
              _reviewRow(LucideIcons.user, "Doctor", _selectedDoctor),
              const Divider(height: 24),
              // 1. FIXED: Fallback value protection if _selectedDay evaluates to null
              _reviewRow(LucideIcons.calendar, "Date", "${_getMonthName(_calendarDate.month)} ${_selectedDay ?? 1}, ${_calendarDate.year}"),
              const Divider(height: 24),
              _reviewRow(LucideIcons.clock, "Time", _selectedTimeSlot ?? '--:--'),
              if (_reason.isNotEmpty) ...[
                const Divider(height: 24),
                _reviewRow(LucideIcons.alignLeft, "Reason", _reason),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),

        Text("Pre-appointment Checklist", style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
        const SizedBox(height: 8),
        const Text("Confirm details and compliance rules:", style: TextStyle(fontSize: 11, color: AppTheme.textGray)),
        const SizedBox(height: 12),
        _checkItem("I confirm I have not had a fever in the last 24 hours.", _noFever, (val) => setState(() => _noFever = val ?? false)),
        _checkItem("I agree to wear a mask inside the clinic if experiencing respiratory symptoms.", _wearMask, (val) => setState(() => _wearMask = val ?? false)),
        _checkItem("I understand that missing appointments without 24h notice may incur a fee.", _noticePolicy, (val) => setState(() => _noticePolicy = val ?? false)),
        _checkItem("I confirm my contact info is correct for confirmation and SMS alerts.", _infoCorrect, (val) => setState(() => _infoCorrect = val ?? false)),
      ],
    );
  }

  Widget _reviewRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppTheme.highlightBlue, size: 14),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label.toUpperCase(), style: GoogleFonts.outfit(fontSize: 9, color: AppTheme.textGray, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
            ],
          ),
        )
      ],
    );
  }

  Widget _checkItem(String text, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(value: value, onChanged: onChanged, activeColor: AppTheme.highlightBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text, style: const TextStyle(fontSize: 12, color: AppTheme.primaryNavy, height: 1.4)),
            ),
          )
        ],
      ),
    );
  }

  // ─── SUCCESS MODAL OVERLAY ──────────────────────────────────────────────────
  Widget _buildSuccessView() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(color: Color(0xFFD1FAE5), shape: BoxShape.circle),
                child: const Icon(LucideIcons.check, color: AppTheme.stableGreen, size: 32),
              ),
              const SizedBox(height: 20),
              Text("Appointment Confirmed!", style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
              const SizedBox(height: 8),
              const Text(
                "Your appointment has been successfully booked. A confirmation has been sent to your email.",
                style: TextStyle(fontSize: 13, color: AppTheme.textGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(color: const Color(0xFFF4F7FB), borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _reviewRow(LucideIcons.stethoscope, "Department", _selectedDept),
                    const Divider(height: 16),
                    _reviewRow(LucideIcons.user, "Doctor", _selectedDoctor),
                    const Divider(height: 16),
                    _reviewRow(LucideIcons.calendar, "Date", "${_getMonthName(_calendarDate.month)} ${_selectedDay ?? 1}, ${_calendarDate.year}"),
                    const Divider(height: 16),
                    _reviewRow(LucideIcons.clock, "Time", _selectedTimeSlot ?? '--:--'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onClose ?? () => setState(() {
                    _isSuccess = false;
                    _currentStep = 1;
                    _selectedDept = '';
                    _selectedDoctor = '';
                    _reason = '';
                    _selectedDay = null;
                    _selectedTimeSlot = null;
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.highlightBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: const Text("Done"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}