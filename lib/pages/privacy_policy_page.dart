import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const route = '/privacy';
  final String lang;
  const PrivacyPolicyPage({super.key, required this.lang});

  String t(String tr, String en, [String de = '', String fr = '']) {
    switch (lang) {
      case 'tr': return tr;
      case 'en': return en;
      case 'de': return de.isNotEmpty ? de : en;
      case 'fr': return fr.isNotEmpty ? fr : en;
      default: return en;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(t('Gizlilik Politikası', 'Privacy Policy', 'Datenschutz', 'Politique de confidentialité')),
        backgroundColor: cs.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('Gizlilik Politikası', 'Privacy Policy', 'Datenschutz', 'Politique de confidentialité'),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSection(
              context,
              t('Veri Toplama', 'Data Collection', 'Datensammlung', 'Collecte de données'),
              t(
                'Bu uygulama kişisel verilerinizi toplamaz, depolamaz veya üçüncü taraflarla paylaşmaz. Tüm OCR işlemleri cihazınızda yerel olarak gerçekleştirilir.',
                'This app does not collect, store, or share your personal data. All OCR processing is performed locally on your device.',
                'Diese App sammelt, speichert oder teilt Ihre persönlichen Daten nicht. Alle OCR-Verarbeitung erfolgt lokal auf Ihrem Gerät.',
                'Cette application ne collecte, ne stocke ou ne partage pas vos données personnelles. Tout le traitement OCR est effectué localement sur votre appareil.'
              ),
            ),
            
            _buildSection(
              context,
              t('Kamera İzni', 'Camera Permission', 'Kamera-Berechtigung', 'Autorisation de caméra'),
              t(
                'Uygulama yalnızca etiket tarama özelliği için kamera erişimi ister. Çekilen fotoğraflar işlendikten sonra silinir.',
                'The app only requests camera access for label scanning functionality. Photos are deleted after processing.',
                'Die App fordert nur Kamerazugriff für die Etikett-Scan-Funktion an. Fotos werden nach der Verarbeitung gelöscht.',
                'L\'application ne demande l\'accès à la caméra que pour la fonctionnalité de numérisation d\'étiquettes. Les photos sont supprimées après traitement.'
              ),
            ),

            _buildSection(
              context,
              t('İletişim', 'Contact', 'Kontakt', 'Contact'),
              t(
                'Gizlilik konularında sorularınız varsa bizimle iletişime geçin:\nhealthlabel.app@gmail.com',
                'If you have questions about privacy, contact us:\nhealthlabel.app@gmail.com',
                'Bei Fragen zum Datenschutz kontaktieren Sie uns:\nhealthlabel.app@gmail.com',
                'Si vous avez des questions sur la confidentialité, contactez-nous:\nhealthlabel.app@gmail.com'
              ),
            ),
            
            const SizedBox(height: 32),
            Center(
              child: Text(
                t(
                  'Son güncelleme: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  'Last updated: ${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                  'Letzte Aktualisierung: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
                  'Dernière mise à jour: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}