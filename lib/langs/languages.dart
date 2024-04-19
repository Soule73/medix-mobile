final List<LanguageModel> languages = [
  LanguageModel("English", "en"),
  LanguageModel("العربية", "ar"),
  LanguageModel("Français", "fr"),
];

class LanguageModel {
  LanguageModel(
    this.language,
    this.symbol,
  );

  String language;
  String symbol;
}
