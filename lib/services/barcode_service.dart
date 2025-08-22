import 'dart:convert';
import 'package:http/http.dart' as http;

class BarcodeService {
  static const String _openFoodFactsBaseUrl = 'https://world.openfoodfacts.org/api/v0/product';

  static Future<Map<String, dynamic>?> getProductInfo(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('$_openFoodFactsBaseUrl/$barcode.json'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data['product'];
        }
      }
      return null;
    } catch (e) {
      throw Exception('Ürün bilgisi alınamadı: $e');
    }
  }

  static List<String> extractIngredients(Map<String, dynamic> product) {
    final ingredientsText = product['ingredients_text'] ?? '';
    if (ingredientsText.isEmpty) return [];
    return ingredientsText
        .split(',')
        .map((ingredient) => ingredient.trim())
        .where((ingredient) => ingredient.isNotEmpty)
        .toList();
  }

  static String getNutritionGradeDescription(String grade) {
    switch (grade.toLowerCase()) {
      case 'a': return 'Çok iyi beslenme kalitesi';
      case 'b': return 'İyi beslenme kalitesi';
      case 'c': return 'Orta beslenme kalitesi';
      case 'd': return 'Zayıf beslenme kalitesi';
      case 'e': return 'Kötü beslenme kalitesi';
      default: return 'Beslenme kalitesi bilinmiyor';
    }
  }

  static Map<String, dynamic> extractNutritionInfo(Map<String, dynamic> product) {
    final nutriments = product['nutriments'] ?? {};
    return {
      'energy_kcal': nutriments['energy-kcal_100g'],
      'fat': nutriments['fat_100g'],
      'saturated_fat': nutriments['saturated-fat_100g'],
      'sugars': nutriments['sugars_100g'],
      'salt': nutriments['salt_100g'],
      'proteins': nutriments['proteins_100g'],
      'fiber': nutriments['fiber_100g'],
    };
  }

  static List<String> detectAllergens(Map<String, dynamic> product) {
    final allergens = product['allergens_tags'] ?? [];
    return allergens
        .map<String>((allergen) => allergen.toString().replaceAll('en:', ''))
        .toList();
  }

  static bool isVegetarian(Map<String, dynamic> product) {
    final labels = product['labels_tags'] ?? [];
    return labels.any((label) =>
        label.toString().contains('vegetarian') ||
        label.toString().contains('vegan'));
  }

  static bool isVegan(Map<String, dynamic> product) {
    final labels = product['labels_tags'] ?? [];
    return labels.any((label) => label.toString().contains('vegan'));
  }

  static bool isGlutenFree(Map<String, dynamic> product) {
    final labels = product['labels_tags'] ?? [];
    return labels.any((label) => label.toString().contains('gluten-free'));
  }

  static bool isOrganic(Map<String, dynamic> product) {
    final labels = product['labels_tags'] ?? [];
    return labels.any((label) =>
        label.toString().contains('organic') ||
        label.toString().contains('bio'));
  }
}