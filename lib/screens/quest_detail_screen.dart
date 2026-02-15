import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:expatrio/models/user_profile.dart';

class _ChecklistItemData {
  final String key;
  final String title;
  final bool hasDoc;

  const _ChecklistItemData({
    required this.key,
    required this.title,
    required this.hasDoc,
  });
}

class QuestDetailScreen extends StatefulWidget {
  final String questId;

  const QuestDetailScreen({super.key, required this.questId});

  @override
  State<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  late final bool _isSpain;
  late final String _title;
  late final String _description;
  late final List<_ChecklistItemData> _checklist;
  late final Map<String, bool> _itemCompletion;

  @override
  void initState() {
    super.initState();
    final userBox = Hive.box<UserProfile>('userBox');
    final profile = userBox.get('profile');
    _isSpain = profile?.originCountry == 'Spain';

    final questData = _buildQuestData(widget.questId, _isSpain);
    _title = questData.$1;
    _description = questData.$2;
    _checklist = questData.$3;
    _itemCompletion = {
      for (final item in _checklist) item.key: false,
    };
  }

  bool get _isAllChecklistCompleted {
    if (_checklist.isEmpty) return true;
    return _checklist.every((item) => _itemCompletion[item.key] ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(_description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          ..._checklist.map(_buildChecklistItem),
          const SizedBox(height: 24),
          _buildAIHelper(_isSpain),
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
          if (!_isAllChecklistCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Complete all checklist items first.'),
              ),
            );
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Quest Complete! +50 XP")),
          );
          context.pop();
        },
        label: const Text("Complete Quest"),
        icon: const Icon(Icons.celebration),
      ),
    );
  }

  Widget _buildChecklistItem(_ChecklistItemData item) {
    final isChecked = _itemCompletion[item.key] ?? false;

    return CheckboxListTile(
      value: isChecked,
      onChanged: (value) {
        setState(() {
          _itemCompletion[item.key] = value ?? false;
        });
      },
      title: Text(item.title),
      secondary: item.hasDoc
          ? IconButton(
              icon: const Icon(Icons.scanner, color: Colors.blue),
              onPressed: () {},
            )
          : null,
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
                const Text("AI Tip",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.purple)),
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

  (String, String, List<_ChecklistItemData>) _buildQuestData(
    String questId,
    bool isSpain,
  ) {
    if (questId == '1') {
      return (
        'Arrival Meldunek',
        'You need to register your address at the local urząd within 30 days of arrival.',
        const [
          _ChecklistItemData(
            key: 'rental_contract',
            title: 'Rental Contract (90+ days)',
            hasDoc: true,
          ),
          _ChecklistItemData(
            key: 'passport',
            title: 'Passport / ID',
            hasDoc: true,
          ),
          _ChecklistItemData(
            key: 'visit_urzad',
            title: 'Visit Urząd Miasta',
            hasDoc: false,
          ),
        ],
      );
    }

    if (questId == '2') {
      return (
        'PESEL Unlock',
        'Get your Polish identification number for taxes and healthcare.',
        const [
          _ChecklistItemData(
            key: 'meldunek_confirmation',
            title: 'Meldunek confirmation',
            hasDoc: true,
          ),
          _ChecklistItemData(
            key: 'pesel_form',
            title: 'Filled PESEL form',
            hasDoc: true,
          ),
          _ChecklistItemData(
            key: 'passport',
            title: 'Passport / ID',
            hasDoc: true,
          ),
        ],
      );
    }

    if (questId == '3') {
      return (
        isSpain ? 'Spanish Consulate (PERE)' : 'Italian Embassy (AIRE)',
        isSpain
            ? 'Register in the PERE (Padrón de Españoles Residentes en el Extranjero) to maintain your Spanish rights while abroad.'
            : "Register in the AIRE (Anagrafe degli Italiani Residenti all'Estero) to notify Italy of your residence in Poland.",
        isSpain
            ? const [
                _ChecklistItemData(
                  key: 'pere_form',
                  title: 'Formulario de inscripción (PERE)',
                  hasDoc: true,
                ),
                _ChecklistItemData(
                  key: 'passport_dni',
                  title: 'Copy of Passport/DNI',
                  hasDoc: true,
                ),
                _ChecklistItemData(
                  key: 'meldunek_proof',
                  title: 'Polświadczenie zameldowania (Meldunek)',
                  hasDoc: true,
                ),
                _ChecklistItemData(
                  key: 'passport_photo',
                  title: '1 Passport photo',
                  hasDoc: false,
                ),
              ]
            : const [
                _ChecklistItemData(
                  key: 'aire_form',
                  title: 'Modulo di iscrizione AIRE',
                  hasDoc: true,
                ),
                _ChecklistItemData(
                  key: 'passport_id',
                  title: 'Copy of Passport/ID',
                  hasDoc: true,
                ),
                _ChecklistItemData(
                  key: 'residence_proof',
                  title: 'Proof of residence (Meldunek)',
                  hasDoc: true,
                ),
              ],
      );
    }

    return (
      'Quest #$questId',
      'Details about your quest.',
      const [],
    );
  }
}
