# google_places_sdk_text_field

[![pub.dev][pub-dev-shield]][pub-dev-url]
[![Effective Dart][effective-dart-shield]][effective-dart-url]
[![Stars][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

## Introduction
This package provides a fully customizable autocomplete TextField.  The package uses [flutter-google-places-sdk] to obtain prediction data.

## Usage

<p>
<img src="https://github.com/julienandco/google_places_autocomplete_text_field/raw/main/google_places_textfield_demo.gif">
</p>

Simple usage:

```dart
GooglePlacesSdkTextField(
  apiKey: 'your_api_key_here',
  countries: const ['nz', 'us'],
  fetchPlace: true,
  fetchPlaceFields: const [
    PlaceField.Location,
    PlaceField.Address,
  ],
  onPlaceSelected: (prediction, place) {
    // do something with the selected prediction/place
  },
);

```

The API key is required. For more information on how to obtain it please see [flutter-google-places-sdk] documentation. You can also pass parameters to SDK package. Most of the `TextField` parameters are also supported.

More complex usage:
```dart
GooglePlacesSdkTextField(
  apiKey: '_your_API_key',
  countries: const ['nz', 'us'],
  fetchPlace: true,
  fetchPlaceFields: const [
    PlaceField.Location,
    PlaceField.Address,
  ],
  decoration: InputDecoration(
    border: border,
    focusedBorder: border.copyWith(
      borderSide: const BorderSide(width: 2),
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
  onPlaceSelected: (prediction, place) {
    // do something here
  },
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

```

### Builders

`placesBuilder` - The places/predictions builder representing UI for found predictions. The resulting widget is displayed in the overlay below the `TextField`. It provides 2 parameters: 
        - `predictios` - List of predictions to display
        - `onPredictionSelected` - This callback should be called when the prediction is selected inside the resulting widget. The main `onPlaceSelected` callback will be invoked (and place fetched in case `fetchPlace` is true).

### Properties

- `apiKey` - Google Places API key. This is required.
- `fetchPlace` - Indicates if Google Place information should be fetched as well (once prediction is selected).
- `locale` - The locale in which Places API responses will be localized.
- `countries` - If not null, the results are restricted to those countries. 
- `delayMs` - Delay in ms for the text change debouncer.
- `fetchPlaceFields` - When `fetchPlace` is true then only the requested fields will be returned. If none specified, all fields will be returned.
- `decoration` - `TextField` decoration override. Note that `suffixIcon` will be overriden. You can customize it by overriding `clearIcon`.

Plus most of the standard `TextField` properties are supported as well.

List of customizable widgets:

- `clearIcon` - represents the clear icon widget.
- `loadingWidget` - represents the loading widget while predictions are being fetched.

## Changelog

Please see [CHANGELOG](CHANGELOG.md) for more information on what has changed recently.

## Credits

- [Tom Friml](https://github.com/3ph)
- [All Contributors](../../contributors)

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[pub-dev-shield]: https://img.shields.io/pub/v/walletconnect_qrcode_modal_dart?style=for-the-badge
[pub-dev-url]: https://pub.dev/packages/walletconnect_qrcode_modal_dart
[effective-dart-shield]: https://img.shields.io/badge/style-effective_dart-40c4ff.svg?style=for-the-badge
[effective-dart-url]: https://github.com/tenhobi/effective_dart
[stars-shield]: https://img.shields.io/github/stars/3ph/google_places_sdk_text_field.svg?style=for-the-badge&logo=github&colorB=deeppink&label=stars
[stars-url]: https://packagist.org/packages/3ph/google_places_sdk_text_field
[issues-shield]: https://img.shields.io/github/issues/3ph/google_places_sdk_text_field.svg?style=for-the-badge
[issues-url]: https://github.com/3ph/google_places_sdk_text_field/issues
[license-shield]: https://img.shields.io/github/license/3ph/google_places_sdk_text_field.svg?style=for-the-badge
[license-url]: https://github.com/3ph/google_places_sdk_text_field/blob/master/LICENSE
[flutter-google-places-sdk]: https://pub.dev/packages/flutter_google_places_sdk