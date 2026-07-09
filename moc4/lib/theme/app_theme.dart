import 'package:flutter/material.dart';

class CloudiaryTheme {
  // 1. PALET WARNA
  // Light Mode
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCardBg = Color(0xFFFFFFFF);
  static const Color lightPrimaryText = Color(0xFF4B5563);
  static const Color lightCardText = Color(0xFF374151);
  static const Color lightMutedText = Color(0xFF8FA3B1);
  static const Color lightBorder = Color(0x73BFD7EA); 

  // Dark Mode
  static const Color darkBg = Color(0xFF0F1923);
  static const Color darkCardBg = Color(0xFF182130);
  static const Color darkPrimaryText = Color(0xFFC8D8E4);
  static const Color darkCardText = Color(0xFFC8D8E4);
  static const Color darkMutedText = Color(0xFF6A8FA8);
  static const Color darkBorder = Color(0x335A93B8); 

  // 2. WARNA CHIPS MOOD
  static Map<String, Map<String, Color>> moodStyles = {
    'Joyful': {'text': Color(0xFFF59E0B), 'bg': Color(0xFFFEF3C7)},
    'Calm': {'text': Color(0xFF3B82F6), 'bg': Color(0xFFDBEAFE)},
    'Neutral': {'text': Color(0xFF6B7280), 'bg': Color(0xFFF3F4F6)},
    'Melancholy': {'text': Color(0xFF8B5CF6), 'bg': Color(0xFFEDE9FE)},
    'Anxious': {'text': Color(0xFFEF4444), 'bg': Color(0xFFFEE2E2)},
    'Energized': {'text': Color(0xFF10B981), 'bg': Color(0xFFD1FAE5)},
    'Cozy': {'text': Color(0xFFD97706), 'bg': Color(0xFFFEF3C7)},
  };

  // 3. GAYA BAYANGAN
  static List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 2,
      offset: const Offset(0, 1), 
    )
  ];

  static List<BoxShadow> activeShadow = [
    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6, offset: const Offset(0, 4)),
    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, -2)),
  ];

  // 4. HIRARKI TIPOGRAFI
  static const TextStyle mainHeader = TextStyle(
    fontFamily: 'Lora',
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle dateHeader = TextStyle(
    fontFamily: 'Lora',
    fontSize: 30,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle chartTitle = TextStyle(
    fontFamily: 'Lora',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle archiveTitle = TextStyle(
    fontFamily: 'Lora',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic, 
  );

  static const TextStyle metadataCaps = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
  );

  static const TextStyle subtext = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}