import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart'; 
import '../theme/app_theme.dart';
import 'add_entry_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ScrollController _homeScrollController = ScrollController();
  final List<String> _dayNames = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];
  final List<String> _monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  @override
  Widget build(BuildContext context) {
    final journalBox = Hive.box('journals');
    final now = DateTime.now();
    final String currentDayName = _dayNames[now.weekday - 1];
    final String currentDayAndMonth = "${now.day} ${_monthNames[now.month - 1]}";
    final String todayStringKey = "${now.day} ${_monthNames[now.month - 1].toUpperCase()} ${now.year}";

    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        final bgColor = isDark ? const Color(0xFF0F172A) : CloudiaryTheme.lightBg;
        final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF2C4A60);
        final mutedTextColor = isDark ? const Color(0xFF94A3B8) : CloudiaryTheme.lightMutedText;
        final borderThemeColor = isDark ? const Color(0xFF334155) : CloudiaryTheme.lightBorder;

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Scrollbar(
              controller: _homeScrollController,
              thumbVisibility: true, 
              child: SingleChildScrollView(
                controller: _homeScrollController,
                physics: const ClampingScrollPhysics(), 
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cloudiary',
                          style: TextStyle(fontFamily: 'Lora', fontSize: 22, fontWeight: FontWeight.w500, color: textColor),
                        ),
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined, 
                            color: textColor,
                          ),
                          onPressed: () {
                            isDarkModeNotifier.value = !isDark;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // 2. MAIN DATE 
                    Text(currentDayName, style: CloudiaryTheme.metadataCaps.copyWith(color: mutedTextColor)),
                    const SizedBox(height: 4),
                    Text(currentDayAndMonth, style: CloudiaryTheme.dateHeader.copyWith(color: textColor)),
                    const SizedBox(height: 24),

                    // 3. BANNER "TODAY'S MOOD" & "RECENT"
                    ValueListenableBuilder(
                      valueListenable: journalBox.listenable(),
                      builder: (context, Box box, widget) {
                        Map<String, dynamic>? todayEntry;
                        int? todayEntryKey;

                        final reversedKeys = box.keys.toList().reversed.toList();
                        for (var key in reversedKeys) {
                          final e = Map<String, dynamic>.from(box.get(key) as Map);
                          if (e['date'] == todayStringKey) {
                            todayEntry = e;
                            todayEntryKey = key as int?;
                            break; 
                          }
                        }

                        final bool hasWrittenToday = todayEntry != null;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEBF3F7), 
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: borderThemeColor),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TODAY\'S MOOD', 
                                    style: TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.bold, color: mutedTextColor, letterSpacing: 1.2),
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  if (!hasWrittenToday) ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('How are you feeling today?', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: textColor, fontWeight: FontWeight.w500)),
                                        GestureDetector(
                                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEntryScreen())),
                                          child: const Text('Write now →', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                  ] else ...[
                                    Row(
                                      children: [
                                        (() {
                                          final String mood = todayEntry!['mood'] ?? 'Neutral';
                                          final styles = CloudiaryTheme.moodStyles[mood] ?? CloudiaryTheme.moodStyles['Neutral']!;
                                          
                                          String emoji = '😐';
                                          if (mood == 'Joyful') emoji = '😊';
                                          else if (mood == 'Calm') emoji = '🌧️';
                                          else if (mood == 'Neutral') emoji = '😐';
                                          else if (mood == 'Melancholy') emoji = '😞';
                                          else if (mood == 'Anxious') emoji = '⚡';
                                          else if (mood == 'Energized') emoji = '⭐';
                                          else if (mood == 'Cozy') emoji = '☕';

                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(color: styles['bg'], borderRadius: BorderRadius.circular(20)),
                                            child: Text(
                                              '$emoji $mood',
                                              style: TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.w600, color: styles['text']),
                                            ),
                                          );
                                        }()),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddEntryScreen(journalKey: todayEntryKey))),
                                            child: Text(
                                              '"${todayEntry['title']}"',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontFamily: 'Lora', fontStyle: FontStyle.italic, fontSize: 15, color: textColor, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 4. KOTAK KALENDER
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderThemeColor)),
                              child: Column(
                                children: [
                                  Text('July 2026', style: CloudiaryTheme.chartTitle.copyWith(color: textColor, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) => Text(day, style: const TextStyle(fontFamily: 'DMSans', fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold))).toList(),
                                  ),
                                  const SizedBox(height: 8),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8),
                                    itemCount: 33, 
                                    itemBuilder: (context, index) {
                                      if (index < 2) return const SizedBox.shrink(); 
                                      final dayNumber = index - 1;
                                      final isToday = dayNumber == now.day && now.month == 7 && now.year == 2026; 

                                      return Container(
                                        decoration: BoxDecoration(
                                          color: isToday ? const Color(0xFFBFD7EA) : Colors.transparent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$dayNumber',
                                            style: TextStyle(
                                              fontFamily: 'DMSans', 
                                              fontSize: 13, 
                                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal, 
                                              color: isToday ? const Color(0xFF2C4A60) : textColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),

                            // 5. RECENT ENTRIES SECTION
                            Text('RECENT', style: CloudiaryTheme.metadataCaps.copyWith(color: mutedTextColor)),
                            const SizedBox(height: 12),

                            if (box.isEmpty) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24.0),
                                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderThemeColor)),
                                child: const Center(
                                  child: Text('No journal entries yet.\nTap the + button to start your journey!', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'DMSans', color: Colors.grey, fontSize: 14, height: 1.5)),
                                ),
                              ),
                            ] else ...[
                              (() {
                                final keysList = box.keys.toList().reversed.toList();
                                final journalList = box.values.toList().reversed.toList();
                                final displayCount = journalList.length > 3 ? 3 : journalList.length;

                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: displayCount,
                                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final entry = Map<String, dynamic>.from(journalList[index] as Map);
                                    final currentHiveKey = keysList[index]; 
                                    
                                    final String title = entry['title'] ?? 'Untitled';
                                    final String content = entry['content'] ?? '';
                                    final String mood = entry['mood'] ?? 'Neutral';
                                    final moodStyles = CloudiaryTheme.moodStyles[mood] ?? CloudiaryTheme.moodStyles['Neutral']!;

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => AddEntryScreen(journalKey: currentHiveKey as int?)),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderThemeColor)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: CloudiaryTheme.archiveTitle.copyWith(color: textColor, fontWeight: FontWeight.bold)),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                  decoration: BoxDecoration(color: moodStyles['bg'], borderRadius: BorderRadius.circular(20)),
                                                  child: Text(mood, style: TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.w600, color: moodStyles['text'])),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(content, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'DMSans', fontSize: 13, color: Colors.grey, height: 1.4)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }()),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEntryScreen())),
            backgroundColor: const Color(0xFFBFD7EA),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.add, size: 28, color: Colors.white),
          ),
        );
      },
    );
  }
}