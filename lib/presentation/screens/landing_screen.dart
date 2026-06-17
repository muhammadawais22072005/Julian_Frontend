import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:julian_medical_center/presentation/theme/app_theme.dart';
import 'package:julian_medical_center/presentation/widgets/responsive_builder.dart';
import 'package:julian_medical_center/presentation/screens/auth_gateway_screen.dart';
import 'package:julian_medical_center/presentation/screens/appointments_view.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showAuthGateway(BuildContext context, {bool isSignUp = false}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          width: 440,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: AuthGatewayScreen(
            initialSignUp: isSignUp,
            onClose: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  void _showBookingWizard(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          width: 700,
          height: 650,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Material(
            child: AppointmentsView(
              onClose: () => Navigator.pop(context),
              isModal: true,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBuilder.isDesktop(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Content Stream
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHero(context, _homeKey),
                _buildAbout(context, _aboutKey),
                _buildServices(context, _servicesKey),
                _buildContact(context, _contactKey),
                _buildFooter(context),
              ],
            ),
          ),

          // Sticky Adaptive Header / Navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 70,
              decoration: BoxDecoration(
                color: _isScrolled ? Colors.white.withOpacity(0.95) : Colors.transparent,
                boxShadow: _isScrolled
                    ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]
                    : [],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Logo Engine
                  GestureDetector(
                    onTap: () => _scrollToSection(_homeKey),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppTheme.highlightBlue, AppTheme.highlightTeal],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(LucideIcons.heart, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Julian Medical",
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _isScrolled ? AppTheme.primaryNavy : Colors.white,
                                ),
                              ),
                              Text(
                                "Center",
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  color: _isScrolled ? AppTheme.textGray : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Desktop Context Anchors
                  if (isDesktop)
                    Row(
                      children: [
                        _navLink("Home", () => _scrollToSection(_homeKey)),
                        _navLink("About", () => _scrollToSection(_aboutKey)),
                        _navLink("Services", () => _scrollToSection(_servicesKey)),
                        _navLink("Contact", () => _scrollToSection(_contactKey)),
                      ],
                    ),

                  // User Interactive Hub Actions
                  Row(
                    children: [
                      if (isDesktop) ...[
                        OutlinedButton(
                          onPressed: () => _showAuthGateway(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _isScrolled ? AppTheme.highlightBlue : Colors.white,
                            side: BorderSide(color: _isScrolled ? AppTheme.softBorder : Colors.white30),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          ),
                          child: const Text("Sign In / Sign Up", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _showBookingWizard(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.highlightTeal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            elevation: 0,
                          ),
                          child: const Text("Book Appointment", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        ),
                      ] else
                        IconButton(
                          icon: Icon(LucideIcons.menu, color: _isScrolled ? AppTheme.primaryNavy : Colors.white),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                              ),
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _mobileMenuLink("Home", () {
                                      Navigator.pop(context);
                                      _scrollToSection(_homeKey);
                                    }),
                                    _mobileMenuLink("About", () {
                                      Navigator.pop(context);
                                      _scrollToSection(_aboutKey);
                                    }),
                                    _mobileMenuLink("Services", () {
                                      Navigator.pop(context);
                                      _scrollToSection(_servicesKey);
                                    }),
                                    _mobileMenuLink("Contact", () {
                                      Navigator.pop(context);
                                      _scrollToSection(_contactKey);
                                    }),
                                    const Divider(height: 24, color: AppTheme.softBorder),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _showAuthGateway(context);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          side: const BorderSide(color: AppTheme.softBorder),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                        ),
                                        child: const Text("Sign In / Sign Up"),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _showBookingWizard(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.highlightTeal,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          elevation: 0,
                                        ),
                                        child: const Text("Book Appointment"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navLink(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _isScrolled ? AppTheme.textGray : Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobileMenuLink(String label, VoidCallback onTap) {
    return ListTile(
      title: Text(label, style: GoogleFonts.outfit(fontWeight: FontWeight.w500, color: AppTheme.primaryNavy)),
      trailing: const Icon(LucideIcons.chevronRight, size: 16, color: AppTheme.textGray),
      onTap: onTap,
    );
  }

  // ─── HERO SECTION ──────────────────────────────────────────────────────────
  Widget _buildHero(BuildContext context, Key key) {
    final isDesktop = ResponsiveBuilder.isDesktop(context);

    return Container(
      key: key,
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.secondaryDark,
        image: DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1777269749032-d8d458ae594d?w=1600&h=900&fit=crop&auto=format"),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 1100,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.highlightTeal.withOpacity(0.15),
                      border: Border.all(color: AppTheme.highlightTeal.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(color: Color(0xFF5EEAD4), shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Accepting new patients — Book today",
                          style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF5EEAD4), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Your Health,\nOur Priority.",
                    style: GoogleFonts.outfit(
                      fontSize: isDesktop ? 60 : 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Julian Medical Center brings together 80+ specialist physicians under one roof to deliver world-class, compassionate healthcare in a welcoming environment.",
                    style: GoogleFonts.inter(
                      fontSize: isDesktop ? 16 : 14,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showBookingWizard(context),
                        icon: const Icon(LucideIcons.arrowRight, size: 16),
                        label: const Text("Book an Appointment"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.highlightTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                          elevation: 0,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => _scrollToSection(_aboutKey),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white30),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        ),
                        child: const Text("Learn More"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Wrap(
                    spacing: 40,
                    runSpacing: 16,
                    children: [
                      _heroStat("25+", "Years of Excellence"),
                      _heroStat("120k+", "Patients Served"),
                      _heroStat("80+", "Specialist Physicians"),
                      _heroStat("4.9★", "Average Rating"),
                    ],
                  ),
                ],
              ),
            ),
            if (isDesktop) const Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget _heroStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.white30)),
      ],
    );
  }

  // ─── ABOUT SECTION ─────────────────────────────────────────────────────────
  Widget _buildAbout(BuildContext context, Key key) {
    final isDesktop = ResponsiveBuilder.isDesktop(context);

    return Container(
      key: key,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      alignment: Alignment.center,
      child: Container(
        width: 1100,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "ABOUT US",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.highlightTeal,
                            letterSpacing: 2),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Caring for families\nsince 1999.",
                        style: GoogleFonts.outfit(fontSize: 34, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "Julian Medical Center was founded with a single mission: to make exceptional healthcare accessible to every member of our community. Over 25 years we have grown into a full-service multi-specialty clinic trusted by over 120,000 patients.",
                        style: TextStyle(fontSize: 15, color: AppTheme.textGray, height: 1.6),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Our physicians are not just clinicians — they are partners in your long-term health journey. We invest in the latest diagnostic technology so our teams can provide faster, more accurate care.",
                        style: TextStyle(fontSize: 15, color: AppTheme.textGray, height: 1.6),
                      ),
                      const SizedBox(height: 30),
                      _valueItem(LucideIcons.checkCircle2, "Patient-Centered Care", "Every decision we make begins and ends with patient wellbeing."),
                      _valueItem(LucideIcons.checkCircle2, "Clinical Excellence", "Evidence-based medicine delivered by credentialed specialists."),
                      _valueItem(LucideIcons.checkCircle2, "Accessible Healthcare", "Transparent pricing, flexible hours, and telehealth options for all."),
                    ],
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Meet Our Physicians", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                        const SizedBox(height: 20),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.72, // Fixed calculation to secure bounds context gracefully
                          children: [
                            _physicianCard("Dr. Sarah Chen", "General Practice · Director", "https://images.unsplash.com/photo-1659353888906-adb3e0041693?w=300&h=300&fit=crop&auto=format"),
                            _physicianCard("Dr. Marcus Patel", "Internal Medicine", "https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=300&h=300&fit=crop&auto=format"),
                            _physicianCard("Dr. Priya Sharma", "Pediatrics", "https://images.unsplash.com/photo-1625134673337-519d4d10b313?w=300&h=300&fit=crop&auto=format"),
                            _physicianCard("Dr. James Okafor", "Cardiology", "https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?w=300&h=300&fit=crop&auto=format"),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ],
            ),
            if (!isDesktop) ...[
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Meet Our Physicians", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220, // Expanded explicitly to clear horizontal overflow rendering rules
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _physicianCard("Dr. Sarah Chen", "General Practice · Director", "https://images.unsplash.com/photo-1659353888906-adb3e0041693?w=300&h=300&fit=crop&auto=format", width: 160),
                        _physicianCard("Dr. Marcus Patel", "Internal Medicine", "https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=300&h=300&fit=crop&auto=format", width: 160),
                        _physicianCard("Dr. Priya Sharma", "Pediatrics", "https://images.unsplash.com/photo-1625134673337-519d4d10b313?w=300&h=300&fit=crop&auto=format", width: 160),
                        _physicianCard("Dr. James Okafor", "Cardiology", "https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?w=300&h=300&fit=crop&auto=format", width: 160),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _valueItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: const Color(0xFFF0F6FF), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppTheme.highlightBlue, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 13, color: AppTheme.textGray)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _physicianCard(String name, String specialty, String photoUrl, {double? width}) {
    return Container(
      width: width,
      margin: width != null ? const EdgeInsets.only(right: 12) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.softBorder),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(specialty, style: const TextStyle(fontSize: 11, color: AppTheme.textGray), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 10)),
          ),
        ],
      ),
    );
  }

  // ─── SERVICES SECTION ──────────────────────────────────────────────────────
  Widget _buildServices(BuildContext context, Key key) {
    final isDesktop = ResponsiveBuilder.isDesktop(context);

    final servicesData = [
      {"icon": LucideIcons.heart, "label": "Cardiology", "desc": "Heart care, diagnostics, and cardiac rehabilitation.", "color": Colors.red},
      {"icon": LucideIcons.activity, "label": "Neurology", "desc": "Neurological evaluations, EEG testing, and complex brain care.", "color": Colors.purple},
      {"icon": LucideIcons.shield, "label": "Orthopedics", "desc": "Bone, joint, and muscle care — from sports injuries to replacements.", "color": Colors.orange},
      {"icon": LucideIcons.baby, "label": "Pediatrics", "desc": "Compassionate care for children from newborns to teens.", "color": Colors.blue},
      {"icon": LucideIcons.eye, "label": "Ophthalmology", "desc": "Eye health services, checks, and surgeries.", "color": Colors.teal},
      {"icon": LucideIcons.smile, "label": "Dermatology", "desc": "Medical and cosmetic treatments for skin health.", "color": Colors.pink},
      {"icon": LucideIcons.stethoscope, "label": "General Practice", "desc": "Preventive checkups, disease management, and referrals.", "color": Colors.blue},
      {"icon": LucideIcons.shieldAlert, "label": "Immunology", "desc": "Allergy testing, immunities, and autoimmune disorders.", "color": Colors.green},
    ];

    return Container(
      key: key,
      color: const Color(0xFFF4F7FB),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      alignment: Alignment.center,
      child: Container(
        width: 1100,
        child: Column(
          children: [
            const Text(
              "WHAT WE OFFER",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.highlightTeal,
                  letterSpacing: 2),
            ),
            const SizedBox(height: 12),
            Text(
              "Medical Specialties",
              style: GoogleFonts.outfit(fontSize: 34, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
            ),
            const SizedBox(height: 16),
            const Text(
              "From routine checkups to complex specialist care, our multidisciplinary team is equipped to handle every aspect of your health.",
              style: TextStyle(fontSize: 15, color: AppTheme.textGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isDesktop ? 1.1 : 0.82, // Optimized slightly to handle full descriptions cleanly
              ),
              itemCount: servicesData.length,
              itemBuilder: (context, index) {
                final s = servicesData[index];
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.softBorder),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: (s['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 18),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          s['label'] as String,
                          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            s['desc'] as String,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textGray, height: 1.4),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── CONTACT SECTION ───────────────────────────────────────────────────────
  Widget _buildContact(BuildContext context, Key key) {
    final isDesktop = ResponsiveBuilder.isDesktop(context);

    return Container(
      key: key,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      alignment: Alignment.center,
      child: Container(
        width: 1100,
        child: Flex(
          direction: isDesktop ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: isDesktop ? 1 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("GET IN TOUCH", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.highlightTeal, letterSpacing: 2)),
                  const SizedBox(height: 12),
                  Text("We're here to help.", style: GoogleFonts.outfit(fontSize: 34, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                  const SizedBox(height: 16),
                  const Text("Have questions about our services, insurance partnerships, or need assistance booking? Contact our administrative team directly.", style: TextStyle(fontSize: 15, color: AppTheme.textGray, height: 1.5)),
                  const SizedBox(height: 32),
                  _contactInfoBlock(LucideIcons.phone, "Call Center", "+1 (555) 234-5678\nAvailable 24/7 for urgent inquiries"),
                  const SizedBox(height: 20),
                  _contactInfoBlock(LucideIcons.mail, "Email Communications", "support@julianmedical.com\nResponse within 1 business day"),
                  const SizedBox(height: 20),
                  _contactInfoBlock(LucideIcons.mapPin, "Clinic Location", "100 Medical Center Parkway, Suite 400\nFree structural parking available"),
                ],
              ),
            ),
            SizedBox(width: isDesktop ? 60 : 0, height: isDesktop ? 0 : 48),
            Expanded(
              flex: isDesktop ? 1 : 0,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.softBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Send a Message", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                    const SizedBox(height: 20),
                    _buildField("Full Name"),
                    const SizedBox(height: 16),
                    _buildField("Email Address"),
                    const SizedBox(height: 16),
                    _buildField("Message", maxLines: 4),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryNavy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: const Text("Submit Form", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactInfoBlock(IconData icon, String title, String data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.highlightTeal, size: 18),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
            const SizedBox(height: 4),
            Text(data, style: const TextStyle(fontSize: 13, color: AppTheme.textGray, height: 1.4)),
          ],
        ),
      ],
    );
  }

  Widget _buildField(String hint, {int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textGray),
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.softBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.highlightBlue)),
      ),
    );
  }

  // ─── FOOTER SECTION ────────────────────────────────────────────────────────
  Widget _buildFooter(BuildContext context) {
    return Container(
      color: AppTheme.secondaryDark,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      alignment: Alignment.center,
      child: Container(
        width: 1100,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("© 2026 Julian Medical Center. All rights reserved.", style: GoogleFonts.inter(fontSize: 12, color: Colors.white30)),
                Row(
                  children: [
                    _footerLink("Privacy Policy"),
                    const SizedBox(width: 24),
                    _footerLink("Terms of Service"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerLink(String label) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.white30)),
    );
  }
}