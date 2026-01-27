// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../models/location_selection.dart';
import '../services/location_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _cityCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lonCtrl = TextEditingController();

  LocationSelection? _saved;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final saved = await LocationStorage.loadManualLocation();
    if (!mounted) return;
    setState(() => _saved = saved);
  }

  Future<void> _save() async {
    final city = _cityCtrl.text.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('City is required')),
      );
      return;
    }

    double? lat;
    double? lon;

    if (_latCtrl.text.trim().isNotEmpty) {
      lat = double.tryParse(_latCtrl.text.trim());
    }
    if (_lonCtrl.text.trim().isNotEmpty) {
      lon = double.tryParse(_lonCtrl.text.trim());
    }

    final loc = LocationSelection(
      city: city,
      country: _countryCtrl.text.trim().isEmpty ? null : _countryCtrl.text.trim(),
      latitude: lat,
      longitude: lon,
    );

    await LocationStorage.saveManualLocation(loc);
    await _loadSaved();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved manual location')),
    );
  }

  Future<void> _clear() async {
    await LocationStorage.clearManualLocation();
    await _loadSaved();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cleared manual location')),
    );
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    _countryCtrl.dispose();
    _latCtrl.dispose();
    _lonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedText = _saved == null ? 'None' : _saved!.displayName;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Saved manual location'),
              subtitle: Text(savedText),
              trailing: TextButton(
                onPressed: _clear,
                child: const Text('Clear'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Set manual location (optional coordinates):'),
          const SizedBox(height: 8),
          TextField(
            controller: _cityCtrl,
            decoration: const InputDecoration(
              labelText: 'City (required)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _countryCtrl,
            decoration: const InputDecoration(
              labelText: 'Country (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _latCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Latitude (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _lonCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Longitude (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
