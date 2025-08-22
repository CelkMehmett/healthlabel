import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'history_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class HomeContent extends StatefulWidget {
  final String lang;
  const HomeContent({super.key, required this.lang});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool _loadingGallery = false;

  String t(String tr, String en, [String de = '', String fr = '']) {
    switch (widget.lang) {
      case 'tr':
        return tr;
      case 'en':
        return en;
      case 'de':
        return de.isNotEmpty ? de : en;
      case 'fr':
        return fr.isNotEmpty ? fr : en;
      default:
        return en;
    }
  }

  // ScanPage.route yok → string route kullan
  void _goScan() => Navigator.pushNamed(context, '/scan');

  Future<void> _pickFromGallery() async {
    if (_loadingGallery) return;
    setState(() => _loadingGallery = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _loadingGallery = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t(
            "Galeriden seçim (placeholder)",
            "Pick from gallery (placeholder)",
            "Galerie-Auswahl (Platzhalter)",
            "Sélection galerie (placeholder)",
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;

    final gradientColors = dark
        ? [cs.surface, cs.surface.withAlpha(217)]
        : [cs.primaryContainer.withAlpha(217), cs.surface];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -120,
              left: -80,
              child: _Blob(
                color: cs.primary.o(dark ? 0.18 : 0.25),
                size: 260,
              ),
            ),
            Positioned(
              top: -40,
              right: -60,
              child: _Blob(
                color: cs.secondary.o(dark ? 0.12 : 0.18),
                size: 220,
              ),
            ),
            Positioned(
              bottom: -80,
              left: -40,
              child: _Blob(
                color: cs.tertiary.o(dark ? 0.10 : 0.15),
                size: 180,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                t(
                                  "Etiketinizi Tarayın",
                                  "Scan Your Label",
                                  "Scannen Sie Ihr Etikett",
                                  "Scannez votre étiquette",
                                ),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                t(
                                  "Hızlı OCR + kişisel sağlık analizi",
                                  "Fast OCR + personalized health analysis",
                                  "Schnelle OCR + personalisierte Gesundheitsanalyse",
                                  "OCR rapide + analyse de santé personnalisée",
                                ),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: cs.onSurfaceVariant),
                              ),
                              const SizedBox(height: 22),
                              _PulseButton(
                                icon: Icons.camera_alt_rounded,
                                label: t("Tara (Kamera)", "Scan (Camera)",
                                    "Scannen (Kamera)", "Scanner (Caméra)"),
                                onPressed: _goScan,
                              ),
                              const SizedBox(height: 12),
                              FilledButton.tonal(
                                onPressed:
                                    _loadingGallery ? null : _pickFromGallery,
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(54),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: AnimatedSwitcher(
                                    duration:
                                        const Duration(milliseconds: 250),
                                    transitionBuilder: (c, a) =>
                                        FadeTransition(opacity: a, child: c),
                                    child: _loadingGallery
                                        ? Row(
                                            key: const ValueKey('loading'),
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                t(
                                                  "Yükleniyor...",
                                                  "Loading...",
                                                  "Laden...",
                                                  "Chargement...",
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 16.5,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            key: const ValueKey('idle'),
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons
                                                  .photo_library_outlined),
                                              const SizedBox(width: 8),
                                              Text(
                                                t(
                                                  "Galeriden Seç",
                                                  "From Gallery",
                                                  "Aus Galerie",
                                                  "Depuis la galerie",
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 16.5,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _QuickAction(
                                icon: Icons.history_rounded,
                                label: t("Geçmiş", "History", "Verlauf",
                                    "Historique"),
                                onTap: () => Navigator.pushNamed(
                                    context, HistoryPage.route),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickAction(
                                icon: Icons.tune_rounded,
                                label: t("Tercihler", "Preferences",
                                    "Einstellungen", "Préférences"),
                                onTap: () => Navigator.pushNamed(
                                    context, ProfilePage.route),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickAction(
                                icon: Icons.settings_rounded,
                                label: t("Ayarlar", "Settings",
                                    "Einstellungen", "Paramètres"),
                                onTap: () => Navigator.pushNamed(
                                    context, SettingsPage.route),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: Column(
                          children: [
                            _InfoTile(
                              icon: Icons.shield_rounded,
                              title: t(
                                  "Kişisel risk profili",
                                  "Personal risk profile",
                                  "Persönliches Risikoprofil",
                                  "Profil de risque personnel"),
                              subtitle: t(
                                "Diyabet, gluten ve alerjenlere göre sonuçlar özelleşir.",
                                "Results are customized for diabetes, gluten and allergens.",
                                "Ergebnisse werden für Diabetes, Gluten und Allergene angepasst.",
                                "Les résultats sont personnalisés pour le diabète, le gluten et les allergènes.",
                              ),
                            ),
                            const SizedBox(height: 12),
                            _InfoTile(
                              icon: Icons.lock_rounded,
                              title: t(
                                  "Veriler cihazda",
                                  "Data on device",
                                  "Daten auf dem Gerät",
                                  "Données sur l'appareil"),
                              subtitle: t(
                                "Buluta gönderilmez; gizlilik önceliklidir.",
                                "Not sent to cloud; privacy first.",
                                "Nicht in die Cloud gesendet; Datenschutz steht an erster Stelle.",
                                "Non envoyé vers le cloud; confidentialité d'abord.",
                              ),
                            ),
                            const SizedBox(height: 12),
                            _InfoTile(
                              icon: Icons.eco_rounded,
                              title: t("Sade ve hızlı", "Simple and fast",
                                  "Einfach und schnell", "Simple et rapide"),
                              subtitle: t(
                                "Modern UI, tek dokunuşla tarama.",
                                "Modern UI, one-touch scanning.",
                                "Moderne Benutzeroberfläche, Ein-Touch-Scannen.",
                                "Interface moderne, numérisation en un clic.",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// --- parçalar

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface.o(0.7),
            border: Border.all(color: cs.outlineVariant.o(0.5)),
            boxShadow: [
              BoxShadow(
                color: cs.primary.o(0.10),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _PulseButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _PulseButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<_PulseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 1.035).animate(
    CurvedAnimation(parent: _c, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ScaleTransition(
      scale: _scale,
      child: ElevatedButton.icon(
        onPressed: widget.onPressed,
        icon: Icon(widget.icon, size: 26),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 17.5, fontWeight: FontWeight.w700),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          shadowColor: cs.primary.o(0.35),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: cs.surface.o(0.75),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.o(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.o(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: cs.primary),
            const SizedBox(height: 6),
            Text(label, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.secondaryContainer.o(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.secondaryContainer),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cs.secondary, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSecondaryContainer,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.o(0.5),
              blurRadius: 60,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}

/// --- yardımcı: withOpacity yerine güvenli kısayol
extension _ColorOpacityCompat on Color {
  /// `withOpacity(x)` yerine uyarısız kullanım.
  Color o(double opacity) => withAlpha((opacity * 255).round());
}