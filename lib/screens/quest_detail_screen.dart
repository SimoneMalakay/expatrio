import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:expatrio/models/user_profile.dart';

class QuestDetailScreen extends StatelessWidget {
  final String questId;

  const QuestDetailScreen({super.key, required this.questId});

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<UserProfile>('userBox');
    final profile = userBox.get('profile');
    final isSpain = profile?.originCountry == 'Spain';

    String title = "Quest #$questId";
    String description = "Details about your quest.";
    List<Widget> checklist = [];

    if (questId == "1") {
      title = "Arrival Meldunek";
      description = "You need to register your address at the local urząd within 30 days of arrival.";
      checklist = [
        _buildChecklistItem(context, "Rental Contract (90+ days)", true),
        _buildChecklistItem(context, "Passport / ID", true),
        _buildChecklistItem(context, "Visit Urząd Miasta", false),
      ];
    } else if (questId == "2") {
      title = "PESEL Unlock";
      description = "Get your Polish identification number for taxes and healthcare.";
      checklist = [
        _buildChecklistItem(context, "Meldunek confirmation", true),
        _buildChecklistItem(context, "Filled PESEL form", true),
        _buildChecklistItem(context, "Passport / ID", true),
      ];
    } else if (questId == "3") {
      title = isSpain ? "Spanish Consulate (PERE)" : "Italian Embassy (AIRE)";
      description = isSpain 
          ? "Register in the PERE (Padrón de Españoles Residentes en el Extranjero) to maintain your Spanish rights while abroad."
          : "Register in the AIRE (Anagrafe degli Italiani Residenti all'Estero) to notify Italy of your residence in Poland.";
      
      if (isSpain) {
        checklist = [
          _buildChecklistItem(context, "Formulario de inscripción (PERE)", true),
          _buildChecklistItem(context, "Copy of Passport/DNI", true),
          _buildChecklistItem(context, "Polświadczenie zameldowania (Meldunek)", true),
          _buildChecklistItem(context, "1 Passport photo", false),
        ];
      } else {
        checklist = [
          _buildChecklistItem(context, "Modulo di iscrizione AIRE", true),
          _buildChecklistItem(context, "Copy of Passport/ID", true),
          _buildChecklistItem(context, "Proof of residence (Meldunek)", true),
        ];
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          
          ...checklist,
          
          const SizedBox(height: 24),
          _buildAIHelper(isSpain),
          
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt),
            label: const Text("Scan Document (OCR)"),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Trigger AR Confetti
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Quest Complete! +50 XP")));
          context.pop();
        },
        label: const Text("Complete Quest"),
        icon: const Icon(Icons.celebration),
      ),
    );
  }

  Widget _buildChecklistItem(BuildContext context, String title, bool hasDoc) {
    return CheckboxListTile(
      value: false, 
      onChanged: (v) {},
      title: Text(title),
      secondary: hasDoc ? IconButton(
        icon: const Icon(Icons.scanner, color: Colors.blue),
        onPressed: () {},
      ) : null,
    );
  }

  Widget _buildAIHelper(bool isSpain) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.purple),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("AI Tip", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                Text(isSpain 
                  ? "Pro Tip: You can send your PERE application by post to the Consulate in Warsaw if you can't visit in person!"
                  : "Did you know? You can do this by proxy if you have a notarized power of attorney!"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
