class OCRService {
  Future<String> scanDocument() async {
    // Mock ML Kit implementation (ML Kit removed for MVP compatibility)
    await Future.delayed(const Duration(seconds: 2));
    return "Meldunek Confirmed: 2024-05-12";
  }
}
