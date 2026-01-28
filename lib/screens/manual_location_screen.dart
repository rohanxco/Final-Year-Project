// lib/screens/manual_location_screen.dart
import 'package:flutter/material.dart';
import '../models/location_selection.dart';
import '../services/location_storage.dart';

class ManualLocationScreen extends StatefulWidget {
  const ManualLocationScreen({super.key});

  @override
  State<ManualLocationScreen> createState() => _ManualLocationScreenState();
}

class _ManualLocationScreenState extends State<ManualLocationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cityCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lonCtrl = TextEditingController();

  bool _saving = false;
  LocationSelection? _saved;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final loc = await LocationStorage.loadManualLocation();
    setState(() => _saved = loc);

    if (loc != null) {
      _cityCtrl.text = loc.city;
      _countryCtrl.text = loc.country ?? '';
      _latCtrl.text = loc.latitude?.toString() ?? '';
      _lonCtrl.text = loc.longitude?.toString() ?? '';
    }
  }

  double? _parseDouble(String s) {
    final t = s.trim();
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final city = _cityCtrl.text.trim();
    final country = _countryCtrl.text.trim().isEmpty
        ? null
        : _countryCtrl.text.trim();
    final lat = _parseDouble(_latCtrl.text);
    final lon = _parseDouble(_lonCtrl.text);

    // If user entered one coord, require both
    if ((lat == null) != (lon == null)) {
      setState(() => _saving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter BOTH latitude and longitude, or leave both empty.',
          ),
        ),
      );
      return;
    }

    final loc = LocationSelection(
      city: city,
      country: country,
      latitude: lat,
      longitude: lon,
    );

    await LocationStorage.saveManualLocation(loc);

    setState(() {
      _saved = loc;
      _saving = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Manual location saved ✅')));

    // Go back (so Qibla/Prayer screen can refresh)
    Navigator.pop(context, true);
  }

  Future<void> _clear() async {
    await LocationStorage.clearManualLocation();
    setState(() {
      _saved = null;
      _cityCtrl.clear();
      _countryCtrl.clear();
      _latCtrl.clear();
      _lonCtrl.clear();
    });
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Manual location cleared')));
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
    final savedLabel = _saved == null
        ? 'None'
        : '${_saved!.city}${_saved!.country == null ? '' : ', ${_saved!.country}'}'
              '${(_saved!.latitude != null && _saved!.longitude != null) ? '  (${_saved!.latitude}, ${_saved!.longitude})' : ''}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Location'),
        actions: [
          TextButton(
            onPressed: _saved == null ? null : _clear,
            child: const Text('Clear'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Card(
                    child: ListTile(
                      title: const Text('Saved manual location'),
                      subtitle: Text(savedLabel),
                      leading: const Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _cityCtrl,
                    decoration: const InputDecoration(
                      labelText: 'City (required)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'City is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _countryCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Country (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _latCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Latitude (optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _lonCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Longitude (optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Text(
                    'Tip: On iPhone/Safari web, GPS permission is often blocked.\n'
                    'If so, enter latitude+longitude once and the app will always work.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: const Icon(Icons.save),
                    label: Text(_saving ? 'Saving…' : 'Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
