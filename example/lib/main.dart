import 'package:flutter/material.dart';

import 'package:google_places_sdk_text_field/google_places_sdk_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _apiKey = '_your_API_key_here_';
  String _selectedPlace = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.green.shade700,
      ),
    );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example'),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Start searching (vanilla)...'),
                FractionallySizedBox(
                  widthFactor: 0.75,
                  child: GooglePlacesSdkTextField(
                    apiKey: _apiKey,
                    countries: const ['nz', 'us'],
                    fetchPlace: true,
                    fetchPlaceFields: const [
                      PlaceField.Location,
                      PlaceField.Address,
                    ],
                    onPlaceSelected: (prediction, place) => setState(
                      () => _selectedPlace = place!.address!,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 64),
                  child: Text('Start searching (customized)...'),
                ),
                FractionallySizedBox(
                  widthFactor: 0.75,
                  child: GooglePlacesSdkTextField(
                      apiKey: _apiKey,
                      countries: const ['nz', 'us'],
                      fetchPlace: true,
                      fetchPlaceFields: const [
                        PlaceField.Location,
                        PlaceField.Address,
                      ],
                      decoration: InputDecoration(
                        border: border,
                        focusedBorder: border.copyWith(
                          borderSide: BorderSide(width: 2),
                        ),
                        fillColor: Colors.green.shade100,
                        filled: true,
                      ),
                      clearIcon: const Icon(
                        Icons.exit_to_app,
                        color: Colors.green,
                      ),
                      loadingWidget: LinearProgressIndicator(
                        color: Colors.green.shade700,
                      ),
                      onPlaceSelected: (prediction, place) => setState(
                            () => _selectedPlace = place!.address!,
                          ),
                      placesBuilder: (predictions, onPredictionSelected) {
                        return ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: predictions.map((prediction) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.bottomRight,
                                padding: const EdgeInsets.all(8),
                                child: Text(prediction.primaryText),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    _selectedPlace,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
