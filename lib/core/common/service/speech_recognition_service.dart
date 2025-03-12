import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognitionService {
  static final SpeechRecognitionService _instance =
      SpeechRecognitionService._internal();

  factory SpeechRecognitionService() => _instance;

  SpeechRecognitionService._internal();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  bool get isListening => _isListening;

  // Initialize the speech recognition service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    _isInitialized = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
        }
      },
      onError: (error) => debugPrint('Speech recognition error: $error'),
    );

    return _isInitialized;
  }

  // Start listening for speech
  Future<bool> startListening({
    required Function(String text) onResult,
    String locale = 'en_US',
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return false;
    }

    if (_speech.isListening) {
      await stopListening();
    }

    final result = await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: locale,
    );

    _isListening = result ?? false;
    return _isListening;
  }

  // Stop listening
  Future<void> stopListening() async {
    _isListening = false;
    await _speech.stop();
  }

  // Cancel listening
  Future<void> cancelListening() async {
    _isListening = false;
    await _speech.cancel();
  }

  static Widget buildListeningOverlay(
      BuildContext context, VoidCallback onCancel) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const SizedBox(
            //   width: 100,
            //   height: 100,
            //   child: CircularProgressIndicator(
            //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            //     strokeWidth: 5,
            //   ),
            // ),
            Lottie.asset(
              'assets/lottie/voice.json',
              width: 300,
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(
                    const ['***'],
                    value: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
            const Text(
              'Try say something...',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.stop),
              label: const Text('Stop'),
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
