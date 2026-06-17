import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:julian_medical_center/presentation/theme/app_theme.dart';
import 'package:julian_medical_center/presentation/widgets/responsive_builder.dart';
import 'package:julian_medical_center/data/models/doctor_model.dart';
import 'package:julian_medical_center/providers/doctor_provider.dart';

class DoctorsView extends ConsumerWidget {
  const DoctorsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsAsync = ref.watch(doctorListProvider);
    final isDesktop = ResponsiveBuilder.isDesktop(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Doctors",
                        style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
                      ),
                      const SizedBox(height: 2),
                      doctorsAsync.maybeWhen(
                        data: (list) => Text("${list.length} physicians on staff", style: const TextStyle(fontSize: 13, color: AppTheme.textGray)),
                        orElse: () => const Text("Loading staff roster...", style: TextStyle(fontSize: 13, color: AppTheme.textGray)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.highlightTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text("+ Add Doctor"),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Doctors Grid / List
            Expanded(
              child: doctorsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.highlightTeal)),
                error: (err, stack) => Center(child: Text("Error: $err", style: const TextStyle(color: AppTheme.criticalRed))),
                data: (list) {
                  if (list.isEmpty) {
                    return Center(
                      child: Text("No doctors found in the directory.", style: GoogleFonts.inter(color: AppTheme.textGray)),
                    );
                  }

                  if (isDesktop) {
                    return GridView.builder(
                      itemCount: list.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.25, // Adjusted slightly to accommodate all elements cleanly without overflowing
                      ),
                      itemBuilder: (context, index) => _buildDoctorCard(context, list[index]),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildDoctorCard(context, list[index]),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, DoctorModel doc) {
    const allDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Keeps layout balanced cleanly across grid variations
        children: [
          // Top info block
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.softBorder),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.network(
                      doc.photo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(LucideIcons.user, color: AppTheme.textGray, size: 24);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              doc.name,
                              style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _availableBadge(doc.available),
                        ],
                      ),
                      Text(doc.specialty, style: const TextStyle(fontSize: 12, color: AppTheme.highlightTeal, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 4),
                          Text(doc.rating.toString(), style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "(${doc.reviews} reviews)",
                              style: const TextStyle(fontSize: 11, color: AppTheme.textGray),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              doc.bio,
              style: const TextStyle(fontSize: 11, color: AppTheme.textGray, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _statBlock(doc.patients.toString(), "Patients")),
                const SizedBox(width: 8),
                Expanded(child: _statBlock(doc.experience, "Experience")),
                const SizedBox(width: 8),
                Expanded(child: _statBlock(doc.todayAppts.toString(), "Today")),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Shift Availability Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("SCHEDULE", style: GoogleFonts.outfit(fontSize: 9, color: AppTheme.textGray, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: allDays.map((d) {
                    final hasShift = doc.schedule.contains(d);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: hasShift ? const Color(0xFFE8F4FB) : const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        d,
                        style: GoogleFonts.outfit(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: hasShift ? AppTheme.highlightTeal : AppTheme.textGray.withOpacity(0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Info items (Location, phone, email)
          const Divider(height: 1, color: AppTheme.softBorder),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _infoRow(LucideIcons.mapPin, doc.location),
                const SizedBox(height: 4),
                _infoRow(LucideIcons.phone, doc.phone),
                const SizedBox(height: 4),
                _infoRow(LucideIcons.mail, doc.email),
              ],
            ),
          ),

          // Action triggers
          const Divider(height: 1, color: AppTheme.softBorder),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.calendar, size: 12),
                    label: const Text("Schedule", style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      side: const BorderSide(color: AppTheme.softBorder),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.highlightTeal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                    ),
                    child: const Text("View Profile", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _availableBadge(bool available) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: available ? const Color(0xFFEBF7ED) : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        available ? "Available" : "Off today",
        style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.bold, color: available ? AppTheme.stableGreen : AppTheme.textGray),
      ),
    );
  }

  Widget _statBlock(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.highlightTeal)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.textGray)),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppTheme.highlightTeal),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 11, color: AppTheme.textGray), overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}