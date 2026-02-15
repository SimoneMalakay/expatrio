import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expatrio/models/user_profile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Roadmap"),
        actions: [
          _buildStreakCounter(),
          const SizedBox(width: 16),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<UserProfile>('userBox').listenable(),
        builder: (context, box, widget) {
          final profile = box.get('profile');
          final isSpain = profile?.originCountry == 'Spain';
          final questTitle = isSpain ? "Spanish Consulate (PERE)" : "Italian Embassy (AIRE)";
          final questDesc = isSpain ? "Register as Spanish resident" : "Tell Italy you moved (AIRE)";

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildXPHeader(),
              const SizedBox(height: 24),
              const Text("QUESTS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              
              _buildQuestCard(context, "1", "Arrival Meldunek", "Registered address", 30, true, false),
              _buildQuestCard(context, "2", "PESEL Unlock", "Get your ID number", 50, false, false),
              _buildQuestCard(context, "3", questTitle, questDesc, 100, false, true),
            ],
          );
        },
      ),
    );
  }

  Widget _buildXPHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Level 1 Expat", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("120 / 500 XP", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: 0.24,
            progressColor: Colors.green,
            backgroundColor: Colors.white,
            barRadius: const Radius.circular(4),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCounter() {
    return const Row(
      children: [
        Icon(Icons.local_fire_department, color: Colors.orange),
        SizedBox(width: 4),
        Text("3 Days", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildQuestCard(BuildContext context, String id, String title, String desc, int xp, bool done, bool locked) {
    return Card(
      elevation: 0,
      color: locked ? Colors.grey.shade100 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: locked ? null : () => context.push('/quest/$id'),
        leading: CircleAvatar(
          backgroundColor: locked ? Colors.grey : (done ? Colors.green : Colors.blue),
          child: Icon(
            locked ? Icons.lock : (done ? Icons.check : Icons.map),
            color: Colors.white,
          ),
        ),
        title: Text(title, style: TextStyle(decoration: done ? TextDecoration.lineThrough : null)),
        subtitle: Text(desc),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text("+$xp XP", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
        ),
      ),
    );
  }
}
