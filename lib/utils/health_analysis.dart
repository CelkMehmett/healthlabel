String extractIngredients(String text, String lang) {
  final regex = RegExp(
    lang == 'tr'
        ? r'(İçindekiler)[\s:\-]*([\s\S]+?)(\n\n|\n[A-ZŞĞÜİÖÇ]|$)'
        : r'(Ingredients)[\s:\-]*([\s\S]+?)(\n\n|\n[A-Z]|$)',
    caseSensitive: false,
  );
  final match = regex.firstMatch(text);
  if (match != null) {
    return match.group(2)?.trim() ?? '';
  }
  return '';
}

/// Returns a list of detected risks as strings
List<String> analyzeHealthRisks(String ingredients, String lang) {
  if (ingredients.isEmpty) return [];

  final lc = ingredients.toLowerCase();

  final List<String> risks = [];

  // Diabetes
  final sugarWords = [
    'şeker',
    'glikoz',
    'fruktoz',
    'sakkaroz',
    'bal',
    'maltodekstrin',
    'dekstroz',
    'agave',
    'şurup',
    'corn syrup',
    'glucose',
    'sugar',
    'honey',
  ];
  if (sugarWords.any(lc.contains)) {
    risks.add(lang == "tr"
        ? "Şeker hastalığı için riskli içerik"
        : "Risky for diabetes");
  }

  // Gluten
  final glutenWords = [
    'gluten',
    'buğday',
    'arpa',
    'çavdar',
    'wheat',
    'barley',
    'rye'
  ];
  if (glutenWords.any(lc.contains)) {
    risks.add(lang == "tr"
        ? "Gluten hassasiyeti için riskli içerik"
        : "Risky for gluten sensitivity");
  }

  // Vegan/Vegetarian
  final animalWords = [
    'et',
    'balık',
    'yumurta',
    'süt',
    'peynir',
    'jelatin',
    'meat',
    'fish',
    'egg',
    'milk',
    'cheese',
    'gelatin'
  ];
  if (animalWords.any(lc.contains)) {
    risks.add(lang == "tr"
        ? "Vegan/Vejetaryen için uygun değil"
        : "Not suitable for vegans/vegetarians");
  }

  // Lactose
  final lactoseWords = [
    'laktoz',
    'süt',
    'yoğurt',
    'peynir',
    'cream',
    'milk',
    'cheese',
    'yogurt',
    'lactose'
  ];
  if (lactoseWords.any(lc.contains)) {
    risks.add(lang == "tr"
        ? "Laktoz intoleransı için riskli içerik"
        : "Risky for lactose intolerance");
  }

  // Allergens
  final allergenWords = [
    'fıstık',
    'yer fıstığı',
    'kabuklu yemiş',
    'egg',
    'milk',
    'soy',
    'peanut',
    'tree nut',
    'almond',
    'hazelnut',
    'walnut',
    'soya'
  ];
  if (allergenWords.any(lc.contains)) {
    risks.add(lang == "tr" ? "Alerjen içerik var" : "Contains allergens");
  }

  // PKU
  if (lc.contains('aspartam')) {
    risks.add(lang == "tr"
        ? "Fenilketonüri için riskli içerik"
        : "Risky for phenylketonuria (PKU)");
  }

  // Hypertension
  if (lc.contains('tuz') || lc.contains('sodium')) {
    risks.add(lang == "tr"
        ? "Yüksek tansiyon için dikkat"
        : "Warning for hypertension");
  }

  return risks;
}