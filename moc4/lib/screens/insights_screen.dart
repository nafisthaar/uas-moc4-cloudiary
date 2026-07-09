import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart';
import '../theme/app_theme.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final journalBox = Hive.box('journals');

    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        final bgColor = isDark ? const Color(0xFF0F172A) : CloudiaryTheme.lightBg;
        final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF2C4A60);
        final mutedTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
        final borderThemeColor = isDark ? const Color(0xFF334155) : CloudiaryTheme.lightBorder;

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: ValueListenableBuilder(
              valueListenable: journalBox.listenable(),
              builder: (context, Box box, widget) {
                final int totalEntries = box.length;

                String topMood = 'None';
                Map<String, int> moodCounts = {};
                
                for (var value in box.values) {
                  final entry = Map<String, dynamic>.from(value as Map);
                  final mood = entry['mood'] ?? 'Neutral';
                  moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
                }

                if (moodCounts.isNotEmpty) {
                  topMood = moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
                }

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TOP BAR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cloudiary',
                            style: TextStyle(fontFamily: 'Lora', fontSize: 22, fontWeight: FontWeight.w500, color: textColor),
                          ),
                          IconButton(
                            icon: Icon(isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined, color: textColor),
                            onPressed: () => isDarkModeNotifier.value = !isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // TITLE
                      Text('Mood Insights', style: TextStyle(fontFamily: 'Lora', fontSize: 26, fontWeight: FontWeight.w500, color: textColor)),
                      const SizedBox(height: 4),
                      Text('Your emotional patterns this month', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: mutedTextColor)),
                      const SizedBox(height: 24),
                      
                      // STATS ROW
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderThemeColor)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('TOTAL DIARIES', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: mutedTextColor, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                    const SizedBox(height: 12),
                                    Text('$totalEntries', style: TextStyle(fontFamily: 'Lora', fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderThemeColor)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('TOP MOOD', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: mutedTextColor, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                    const SizedBox(height: 12),
                                    Text(topMood, style: TextStyle(fontFamily: 'Lora', fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // DISTRIBUTION METRICS
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderThemeColor)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('MOOD DISTRIBUTION', style: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: mutedTextColor, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                              const SizedBox(height: 24),
                              if (totalEntries == 0)
                                const Expanded(child: Center(child: Text('Write entries to populate metrics', style: TextStyle(fontFamily: 'DMSans', color: Colors.grey))))
                              else
                                Expanded(
                                  child: ListView(
                                    children: moodCounts.entries.map((item) {
                                      final double percentage = item.value / totalEntries;
                                      final styles = CloudiaryTheme.moodStyles[item.key] ?? CloudiaryTheme.moodStyles['Neutral']!;

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(item.key, style: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
                                                Text('${(percentage * 100).toStringAsFixed(0)}%', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: LinearProgressIndicator(
                                                value: percentage,
                                                backgroundColor: const Color(0xFFE2E8F0),
                                                valueColor: AlwaysStoppedAnimation<Color>(styles['text']!),
                                                minHeight: 8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}