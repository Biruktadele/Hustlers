import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BeautifulAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool transparent;
  final List<Widget>? actions;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;

  const BeautifulAppBar({
    super.key,
    required this.title,
    this.transparent = false,
    this.actions,
    this.onNotificationPressed,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors based on transparency
    final backgroundColor = transparent ? Colors.transparent : null;
    final foregroundColor = transparent ? Colors.deepPurple : Colors.white;

    return Container(
      decoration: transparent
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade800,
                  Colors.deepPurple.shade500,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
      child: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: foregroundColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Always transparent in AppBar, handled by Container
        elevation: 0,
        iconTheme: IconThemeData(color: foregroundColor),
        actions: actions ??
            [
              IconButton(
                onPressed: onNotificationPressed ?? () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 8.0),
                child: GestureDetector(
                  onTap: onProfilePressed ?? () {},
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: transparent 
                        ? Colors.deepPurple 
                        : Colors.white,
                    child: Icon(
                      Icons.person,
                      color: transparent ? Colors.white : Colors.deepPurple,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
