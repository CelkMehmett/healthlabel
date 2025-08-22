import '../models/history_item.dart';
import '../state/app_state.dart';

class AnalysisService {
  static RiskLevel analyze(String text) {
    final prefs = AppState.I.prefs.value;
    final t = text.toLowerCase();

    bool risky = false;
    bool attention = false;

    if (prefs.gluten && t.contains("gluten")) risky = true;
    if (prefs.peanut && (t.contains("peanut") || t.contains("fıstık"))) risky = true;
    if (prefs.diabetes && t.contains("sugar")) attention = true;
    if (prefs.lactose && (t.contains("lactose") || t.contains("milk"))) risky = true;
    if (prefs.egg && t.contains("egg")) risky = true;
    if (prefs.soy && (t.contains("soy") || t.contains("soya"))) risky = true;
    if (prefs.sesame && t.contains("sesame")) risky = true;
    if (prefs.shellfish && (t.contains("shrimp") || t.contains("crab") || t.contains("shellfish"))) risky = true;
    if (prefs.nuts && (t.contains("almond") || t.contains("hazelnut") || t.contains("cashew") || t.contains("walnut") || t.contains("nut"))) risky = true;
    if (prefs.caffeine && (t.contains("caffeine") || t.contains("coffee") || t.contains("tea"))) attention = true;
    if (prefs.msg && (t.contains("msg") || t.contains("E621".toLowerCase()))) attention = true;
    if (prefs.colorants && t.contains("color")) attention = true;
    if (prefs.additives && (t.contains("preservative") || t.contains("emulsifier") || t.contains("E2"))) attention = true;

    if (t.contains("low sugar") || t.contains("unsweetened")) return RiskLevel.safe;

    if (risky) return RiskLevel.risky;
    if (attention) return RiskLevel.attention;
    return RiskLevel.safe;
  }
}