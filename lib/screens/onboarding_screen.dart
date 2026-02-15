import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:expatrio/models/user_profile.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Mock state for now
  String? origin = 'Italy';
  String? destination = 'Poland';
  String? city = 'Wrocław';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Welcome to Expatrio 🌍",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Conquer bureaucracy like a game.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Dropdowns will go here
              _buildDropdown("Origin", ["Italy", "Spain"], (v) => setState(() => origin = v)),
              const SizedBox(height: 16),
              _buildDropdown("Moving to", ["Poland"], (v) => setState(() => destination = v)),
              const SizedBox(height: 16),
              _buildDropdown("City", ["Wrocław", "Warsaw"], (v) => setState(() => city = v)),

              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  // Save to Hive
                  final userBox = Hive.box<UserProfile>('userBox');
                  final profile = UserProfile(
                    originCountry: origin ?? 'Italy',
                    destinationCountry: destination ?? 'Poland',
                    destinationCity: city ?? 'Wrocław',
                    visaType: 'Work', // Default for now
                  );
                  await userBox.put('profile', profile);
                  
                  if (mounted) context.push('/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Start My Quest"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: items.first,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
