import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart'; 
import '../theme/app_theme.dart';
import 'add_entry_screen.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _archiveScrollController = ScrollController();
  
  String _searchQuery = '';
  String _selectedMoodFilter = 'All moods';
  bool _isFilterOpen = false;

  final List<String> _moodFilters = [
    'All moods',
    'Joyful',
    'Calm',
    'Neutral',
    'Melancholy',
    'Anxious',
    'Energized',
    'Cozy'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _archiveScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journalBox = Hive.box('journals');

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Row(
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
                ),

                // 2. JUDUL HALAMAN 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  child: Text(
                    'Diary Collection',
                    style: TextStyle(fontFamily: 'Lora', fontSize: 26, fontWeight: FontWeight.w500, color: textColor),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. BARIS KOLOM PENCARIAN & TOMBOL FILTER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEBF3F7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderThemeColor),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: mutedTextColor, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                  style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: textColor),
                                  decoration: InputDecoration(
                                    hintText: "Search diaries", 
                                    hintStyle: TextStyle(color: mutedTextColor),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFilterOpen = !_isFilterOpen; 
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: _isFilterOpen 
                                ? const Color(0xFF2C4A60) 
                                : const Color(0xFFBFD7EA).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.tune_rounded, 
                            color: _isFilterOpen ? Colors.white : const Color(0xFF2C4A60), 
                            size: 20
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 4. HORIZONTAL FILTER MOOD CHIPS
                if (_isFilterOpen) ...[
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(), 
                      itemCount: _moodFilters.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final moodName = _moodFilters[index];
                        final isSelected = _selectedMoodFilter == moodName;
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMoodFilter = moodName;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? const Color(0xFF2C4A60) 
                                  : (isDark ? const Color(0xFF1E293B) : Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF2C4A60) : borderThemeColor,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                moodName,
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.white : textColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 5. LIST DAFTAR JURNAL 
                Expanded(
                  child: Scrollbar(
                    controller: _archiveScrollController,
                    thumbVisibility: true, 
                    child: ValueListenableBuilder(
                      valueListenable: journalBox.listenable(),
                      builder: (context, Box box, widget) {
                        if (box.isEmpty) {
                          return Center(
                            child: Text('Your archive is clean and empty.', style: TextStyle(fontFamily: 'DMSans', color: mutedTextColor)),
                          );
                        }

                        final allJournals = box.values.toList().reversed.toList();
                        final keysList = box.keys.toList().reversed.toList();

                        final filteredItems = [];
                        for (int i = 0; i < allJournals.length; i++) {
                          final entry = Map<String, dynamic>.from(allJournals[i] as Map);
                          final String title = (entry['title'] ?? '').toString().toLowerCase();
                          final String content = (entry['content'] ?? '').toString().toLowerCase();
                          final String mood = entry['mood'] ?? 'Neutral';

                          final matchesSearch = title.contains(_searchQuery.toLowerCase()) || content.contains(_searchQuery.toLowerCase());
                          final matchesMood = _selectedMoodFilter == 'All moods' || mood == _selectedMoodFilter;

                          if (matchesSearch && matchesMood) {
                            filteredItems.add({
                              'entry': entry,
                              'key': keysList[i],
                            });
                          }
                        }

                        if (filteredItems.isEmpty) {
                          return Center(
                            child: Text('No results match your search.', style: TextStyle(fontFamily: 'DMSans', color: mutedTextColor)),
                          );
                        }

                        return ListView.separated(
                          controller: _archiveScrollController,
                          physics: const ClampingScrollPhysics(), 
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: filteredItems.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            final entry = item['entry'];
                            final currentHiveKey = item['key'];

                            final String title = entry['title'] ?? 'Untitled';
                            final String content = entry['content'] ?? '';
                            final String mood = entry['mood'] ?? 'Neutral';
                            
                            final String dayNumber = entry['dayNumber'] ?? '3';
                            final String dayName = entry['dayName'] ?? 'Fri';
                            final String tag = entry['tag'] ?? '';
                            final bool hasPhoto = entry['hasPhoto'] ?? false;
                            
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
                                decoration: BoxDecoration(
                                  color: cardColor, 
                                  borderRadius: BorderRadius.circular(16), 
                                  border: Border.all(color: borderThemeColor),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                        width: 45,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              dayNumber,
                                              style: TextStyle(fontFamily: 'Lora', fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              dayName,
                                              style: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: mutedTextColor, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                        child: VerticalDivider(color: borderThemeColor, width: 1, thickness: 1),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    title, 
                                                    maxLines: 1, 
                                                    overflow: TextOverflow.ellipsis, 
                                                    style: TextStyle(fontFamily: 'Lora', fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: textColor),
                                                  ),
                                                ),
                                                if (hasPhoto) ...[
                                                  const SizedBox(width: 8),
                                                  Icon(Icons.image_outlined, color: mutedTextColor, size: 16),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              content, 
                                              maxLines: 2, 
                                              overflow: TextOverflow.ellipsis, 
                                              style: TextStyle(fontFamily: 'DMSans', fontSize: 13, color: isDark ? Colors.grey[300] : Colors.blueGrey, height: 1.4),
                                            ),
                                            const SizedBox(height: 10),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 6,
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                  decoration: BoxDecoration(color: moodStyles['bg'], borderRadius: BorderRadius.circular(20)),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      (() {
                                                        String emoji = '😐';
                                                        if (mood == 'Joyful') emoji = '😊';
                                                        else if (mood == 'Calm') emoji = '🌧️';
                                                        else if (mood == 'Neutral') emoji = '😐';
                                                        else if (mood == 'Melancholy') emoji = '😞';
                                                        else if (mood == 'Anxious') emoji = '⚡';
                                                        else if (mood == 'Energized') emoji = '⭐';
                                                        else if (mood == 'Cozy') emoji = '☕';
                                                        return Text('$emoji ', style: const TextStyle(fontSize: 11));
                                                      }()),
                                                      Text(mood, style: TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.bold, color: moodStyles['text'])),
                                                    ],
                                                  ),
                                                ),
                                                if (tag.trim().isNotEmpty)
                                                  Text(
                                                    '#${tag.trim()}',
                                                    style: TextStyle(
                                                      fontFamily: 'DMSans', 
                                                      fontSize: 12, 
                                                      color: isDark ? const Color(0xFF60A5FA) : Colors.blue, 
                                                      fontWeight: FontWeight.w500
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}