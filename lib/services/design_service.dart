import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';

class DesignService {
  DesignService._();

  static final GenerativeModel _model =
  FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.1-flash-image',
    generationConfig: GenerationConfig(
      responseModalities: [
        ResponseModalities.image,
      ],
    ),
  );

  static Future<File> generateDesign({
    required File imageFile,
    required String room,
    required String style,
    required String roomLength,
    required String roomWidth,
    required String roomHeight,
    required String measurementUnit,
  }) async {
    if (!await imageFile.exists()) {
      throw Exception('The selected room photo could not be found.');
    }

    final imageBytes = await imageFile.readAsBytes();

    if (imageBytes.isEmpty) {
      throw Exception('The selected room photo is empty.');
    }

    final mimeType = _getMimeType(imageFile.path);

    final imagePart = InlineDataPart(
      mimeType,
      imageBytes,
    );

    final prompt = TextPart(
      '''
You are a professional interior designer and architectural
visualization specialist.

Redesign the provided room photograph.

ROOM INFORMATION:
- Room type: $room
- Interior style: $style
- Length: $roomLength $measurementUnit
- Width: $roomWidth $measurementUnit
- Height: $roomHeight $measurementUnit

ARCHINEST REQUIREMENTS:

1. Keep the original room architecture realistic.

2. Preserve:
- walls
- windows
- doors
- ceiling
- room proportions
- major architectural structures

3. Transform the room into a professional
   $style-style $room.

4. Add realistic:
- furniture
- lighting
- flooring
- wall treatment
- curtains where appropriate
- decorations
- plants where appropriate
- storage where appropriate

5. Maintain realistic scale and perspective.

6. Do not make the room unrealistically large.

7. Do not change the room into another type of room.

8. Do not remove important architectural structures.

9. Use realistic materials.

10. Use natural-looking lighting.

11. The result should look like a professional
    interior design photograph.

12. Do not create a cartoon, illustration,
    game scene or abstract image.

13. Keep the original camera viewpoint
    as closely as possible.

14. Make the final room attractive,
    modern and professionally furnished.

15. Generate one complete redesigned room image.

Return the redesigned room image.
''',
    );

    try {
      final response = await _model.generateContent([
        Content.multi([
          prompt,
          imagePart,
        ]),
      ]);

      if (response.inlineDataParts.isEmpty) {
        throw Exception(
          'Gemini did not return a generated image. '
              'Please try again.',
        );
      }

      final generatedBytes =
          response.inlineDataParts.first.bytes;

      if (generatedBytes.isEmpty) {
        throw Exception(
          'Gemini returned an empty image.',
        );
      }

      final fileName =
          'archinest_design_${DateTime.now().millisecondsSinceEpoch}.png';

      final outputPath =
          '${Directory.systemTemp.path}/$fileName';

      final outputFile = File(outputPath);

      await outputFile.writeAsBytes(
        generatedBytes,
        flush: true,
      );

      return outputFile;
    } catch (error) {
      throw Exception(
        'AI design generation failed: $error',
      );
    }
  }

  static String _getMimeType(String path) {
    final extension =
    path.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';

      case 'png':
        return 'image/png';

      case 'webp':
        return 'image/webp';

      case 'heic':
        return 'image/heic';

      case 'heif':
        return 'image/heif';

      default:
        return 'image/jpeg';
    }
  }
}