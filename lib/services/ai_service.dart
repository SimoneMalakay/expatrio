class AIService {
  Future<String> getTipForQuest(String questId) async {
    // Mock for now until Gemini API key is provided
    await Future.delayed(const Duration(seconds: 1));
    final facts = [
      "💡 Fun Fact: In Poland, you must carry your ID at all times! But don't worry, digital mObywatel app works too.",
      "💡 Spanish Tip: Unlike Spain, Poland uses złoty (PLN) not euros. ATMs are everywhere!",
      "💡 Did you know? Polish bureaucracy loves stamps and signatures - very different from Spain's digital systems!",
    ];
    return facts[DateTime.now().millisecond % facts.length];
  }
}
