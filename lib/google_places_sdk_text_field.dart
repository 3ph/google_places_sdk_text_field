import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places;

export 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

typedef GooglePlacesSdkTextFieldPlacesBuilder = Widget Function(
  List<places.AutocompletePrediction> predictions,
  Function(places.AutocompletePrediction)? onPredictionSelected,
);

class GooglePlacesSdkTextField extends StatefulWidget {
  const GooglePlacesSdkTextField({
    required this.apiKey,
    this.fetchPlace = false,
    this.locale,
    this.countries,
    this.delayMs,
    this.decoration,
    this.fetchPlaceFields,
    this.onPlaceSelected,
    this.loadingWidget,
    this.clearIcon,
    this.placesBuilder,
    super.key,
    // TextField
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.inputFormatters,
    this.enabled,
    this.ignorePointers,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.cursorErrorColor,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.selectionControls,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scribbleEnabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.canRequestFocus = true,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
  });

  final String apiKey;
  final bool fetchPlace;
  final Locale? locale;
  final List<String>? countries;
  final int? delayMs;
  final InputDecoration? decoration;
  final List<places.PlaceField>? fetchPlaceFields;
  final Widget? loadingWidget;
  final Widget? clearIcon;
  final GooglePlacesSdkTextFieldPlacesBuilder? placesBuilder;

  // TextField
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final bool readOnly;
  final bool? showCursor;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool? ignorePointers;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final bool? cursorOpacityAnimates;
  final Color? cursorColor;
  final GestureTapCallback? onTap;
  final bool onTapAlwaysCalled;
  final TapRegionCallback? onTapOutside;
  final MouseCursor? mouseCursor;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final Clip clipBehavior;
  final String? restorationId;
  final bool scribbleEnabled;
  final bool enableIMEPersonalizedLearning;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final bool canRequestFocus;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final Color? cursorErrorColor;
  final BoxHeightStyle selectionHeightStyle;
  final BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final TextSelectionControls? selectionControls;
  final DragStartBehavior dragStartBehavior;
  final TextMagnifierConfiguration? magnifierConfiguration;

  final Function(
    places.AutocompletePrediction prediction,
    places.Place? place,
  )? onPlaceSelected;

  @override
  State<GooglePlacesSdkTextField> createState() =>
      _GooglePlacesSdkTextFieldState();
}

class _GooglePlacesSdkTextFieldState extends State<GooglePlacesSdkTextField> {
  final _controller = TextEditingController();
  final _layerLink = LayerLink();

  late final _debouncer = _Debouncer(delay: widget.delayMs);
  late final _places = places.FlutterGooglePlacesSdk(
    widget.apiKey,
    locale: widget.locale,
  );

  List<places.AutocompletePrediction> _predictions = [];
  OverlayEntry? _overlayEntry;
  bool _ignoreChange = false;
  bool _canClean = false;

  @override
  void initState() {
    _controller.addListener(_onTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        decoration: (widget.decoration ?? const InputDecoration()).copyWith(
          suffixIcon: _canClean
              ? IconButton(
                  icon: widget.clearIcon ?? const Icon(Icons.close),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _clearPredition(),
                )
              : null,
        ),
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        style: widget.style,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        textDirection: widget.textDirection,
        readOnly: widget.readOnly,
        showCursor: widget.showCursor,
        autofocus: widget.autofocus,
        obscuringCharacter: widget.obscuringCharacter,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        expands: widget.expands,
        maxLength: widget.maxLength,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        ignorePointers: widget.ignorePointers,
        cursorWidth: widget.cursorWidth,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorOpacityAnimates: widget.cursorOpacityAnimates,
        cursorColor: widget.cursorColor,
        cursorErrorColor: widget.cursorErrorColor,
        selectionHeightStyle: widget.selectionHeightStyle,
        selectionWidthStyle: widget.selectionWidthStyle,
        keyboardAppearance: widget.keyboardAppearance,
        scrollPadding: widget.scrollPadding,
        dragStartBehavior: widget.dragStartBehavior,
        selectionControls: widget.selectionControls,
        onTap: widget.onTap,
        onTapAlwaysCalled: widget.onTapAlwaysCalled,
        onTapOutside: widget.onTapOutside,
        mouseCursor: widget.mouseCursor,
        buildCounter: widget.buildCounter,
        scrollController: widget.scrollController,
        scrollPhysics: widget.scrollPhysics,
        autofillHints: widget.autofillHints,
        contentInsertionConfiguration: widget.contentInsertionConfiguration,
        clipBehavior: widget.clipBehavior,
        restorationId: widget.restorationId,
        scribbleEnabled: widget.scribbleEnabled,
        enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
        canRequestFocus: widget.canRequestFocus,
        spellCheckConfiguration: widget.spellCheckConfiguration,
        magnifierConfiguration: widget.magnifierConfiguration,
      ),
    );
  }

  void _onTextChanged() async {
    final text = _controller.text;
    setState(() => _canClean = text.isNotEmpty);
    if (_ignoreChange) return;
    _debouncer.call(() async {
      if (text.isEmpty) {
        _removeOverlay();
        return;
      }
      _removeOverlay();
      _overlayEntry = _createOverlayEntry(isLoading: true);
      if (mounted) Overlay.of(context).insert(_overlayEntry!);
      try {
        final response = await _places.findAutocompletePredictions(
          text,
          countries: widget.countries,
        );
        _removeOverlay();
        _predictions = response.predictions;
        _overlayEntry = _createOverlayEntry();
        if (mounted) Overlay.of(context).insert(_overlayEntry!);
      } catch (e) {
        // TODO: show error
      }
    });
  }

  OverlayEntry? _createOverlayEntry({bool isLoading = false}) {
    if (context.findRenderObject() != null) {
      final renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);

      return OverlayEntry(
        builder: (context) => Positioned(
          left: offset.dx,
          top: size.height + offset.dy,
          width: size.width,
          child: CompositedTransformFollower(
            showWhenUnlinked: false,
            link: _layerLink,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 1.0,
              child: _overlayChild(isLoading),
            ),
          ),
        ),
      );
    }
    return null;
  }

  Widget _overlayChild(bool isLoading) {
    if (isLoading) {
      return Align(
        alignment: Alignment.center,
        child: widget.loadingWidget ??
            const SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
      );
    }
    if (widget.placesBuilder != null) {
      return widget.placesBuilder!(_predictions, (prediction) {
        _predictionSelected(prediction);
      });
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: _predictions.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () async {
          final prediction = _predictions[index];
          _predictionSelected(prediction);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            _predictions[index].fullText,
          ),
        ),
      ),
    );
  }

  void _removeOverlay() {
    _predictions = [];
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _clearPredition() {
    _ignoreChange = true;
    _controller.text = '';
    _predictions = [];
    _ignoreChange = false;

    _removeOverlay();
  }

  Future<void> _predictionSelected(
      places.AutocompletePrediction prediction) async {
    _ignoreChange = true;
    _controller.text = prediction.fullText;
    _ignoreChange = false;

    if (widget.fetchPlace) {
      final placeResponse = await _places.fetchPlace(
        prediction.placeId,
        fields: widget.fetchPlaceFields ?? [],
      );
      widget.onPlaceSelected?.call(prediction, placeResponse.place);
    } else {
      widget.onPlaceSelected?.call(prediction, null);
    }

    _removeOverlay();
  }
}

class _Debouncer {
  _Debouncer({this.delay});

  final int? delay;
  Timer? _timer;

  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: delay ?? 300), callback);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
