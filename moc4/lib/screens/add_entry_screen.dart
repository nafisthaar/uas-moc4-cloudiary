import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart'; 
import '../main.dart'; 
import '../theme/app_theme.dart';

class AddEntryScreen extends StatefulWidget {
  final int? journalKey; 

  const AddEntryScreen({super.key, this.journalKey});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  String _selectedMood = 'Calm';
  bool _showPhotoOptions = false; 
  bool _isPhotoAttached = false; 
  String? _imagePath; 
  String _headerDateString = '';

  final ImagePicker _imagePickerEngine = ImagePicker();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final List<String> fullMonths = ['JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'];
    
    _headerDateString = "${now.day} ${fullMonths[now.month - 1]} ${now.year}";

    if (widget.journalKey != null) {
      final box = Hive.box('journals');
      final entry = Map<String, dynamic>.from(box.get(widget.journalKey) as Map);
      _titleController.text = entry['title'] ?? '';
      _contentController.text = entry['content'] ?? '';
      _tagController.text = entry['tag'] ?? '';
      _selectedMood = entry['mood'] ?? 'Calm';
      _isPhotoAttached = entry['hasPhoto'] ?? false;
      _imagePath = entry['imagePath'];
      
      if (entry['date'] != null) {
        _headerDateString = entry['date']; 
      }
    }
  }

  Future<void> _handleImageSelection(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePickerEngine.pickImage(
        source: source,
        imageQuality: 80, 
      );
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
          _isPhotoAttached = true;      
          _showPhotoOptions = false;    
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        final bgColor = isDark ? const Color(0xFF0F172A) : CloudiaryTheme.lightBg;
        final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF2C4A60);
        final mutedTextColor = isDark ? const Color(0xFF94A3B8) : CloudiaryTheme.lightMutedText;
        final borderThemeColor = isDark ? const Color(0xFF334155) : CloudiaryTheme.lightBorder;
        final inputBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFEBF3F7);

        return Scaffold(
          backgroundColor: bgColor, 
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(), 
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. TOP NAVIGATION ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: textColor), 
                          label: Text('Back', style: TextStyle(fontFamily: 'DMSans', color: textColor, fontSize: 15)), 
                        ),
                        Text(
                          _headerDateString, 
                          style: TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.w500, color: mutedTextColor, letterSpacing: 1.0), 
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final journalBox = Hive.box('journals');
                              final now = DateTime.now();
                              
                              final List<String> shortDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              final List<String> fullMonths = ['JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'];

                              final String currentDayNum = now.day.toString();
                              final String currentDayNameShort = shortDays[now.weekday - 1];
                              final String currentMonthYearStr = "${fullMonths[now.month - 1]} ${now.year}";
                              final String fullSavedDate = "$currentDayNum $currentMonthYearStr";

                              final entryData = {
                                'title': _titleController.text,
                                'content': _contentController.text,
                                'mood': _selectedMood,
                                'tag': _tagController.text,
                                'date': widget.journalKey != null ? _headerDateString : fullSavedDate,
                                'dayNumber': widget.journalKey != null ? (journalBox.get(widget.journalKey)['dayNumber'] ?? currentDayNum) : currentDayNum,
                                'dayName': widget.journalKey != null ? (journalBox.get(widget.journalKey)['dayName'] ?? currentDayNameShort) : currentDayNameShort,
                                'monthYear': widget.journalKey != null ? (journalBox.get(widget.journalKey)['monthYear'] ?? currentMonthYearStr) : currentMonthYearStr,
                                'hasPhoto': _isPhotoAttached,
                                'imagePath': _imagePath, 
                              };

                              if (widget.journalKey != null) {
                                await journalBox.put(widget.journalKey, entryData);
                              } else {
                                await journalBox.add(entryData);
                              }

                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Journal entry saved successfully!')),
                              );
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBFD7EA), 
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontFamily: 'DMSans', fontWeight: FontWeight.w500, color: Color(0xFF2C4A60)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 2. ATTACHED PHOTO PREVIEW
                    if (_isPhotoAttached) ...[
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _imagePath != null
                                ? Image.file(
                                    File(_imagePath!), 
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=1000', 
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _isPhotoAttached = false;
                                _imagePath = null; 
                              }),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.black.withValues(alpha: 0.5),
                                child: const Icon(Icons.close, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],

                    // 3. TITLE INPUT FORM
                    TextFormField(
                      controller: _titleController,
                      style: TextStyle(fontFamily: 'Lora', fontSize: 28, fontWeight: FontWeight.bold, color: textColor), 
                      decoration: InputDecoration(
                        hintText: "What's on your mind today...",
                        hintStyle: TextStyle(color: mutedTextColor, fontFamily: 'Lora', fontStyle: FontStyle.italic), 
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Title cannot be empty!';
                        return null;
                      },
                    ),
                    Divider(color: borderThemeColor, height: 24), 

                    // 4. CONTENT INPUT FORM
                    TextFormField(
                      controller: _contentController,
                      maxLines: null, 
                      style: TextStyle(fontFamily: 'DMSans', fontSize: 15, color: textColor, height: 1.6), 
                      decoration: InputDecoration(
                        hintText: "Let your thoughts flow freely here. There's no right way to write. Just let it out...",
                        hintStyle: TextStyle(color: mutedTextColor), 
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Please write down your thoughts first!';
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),

                    // 5. MOOD SELECTOR CHIPS
                    Text('HOW ARE YOU FEELING?', style: CloudiaryTheme.metadataCaps.copyWith(color: mutedTextColor)), 
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 10.0,
                      children: CloudiaryTheme.moodStyles.keys.map((String moodName) {
                        final isSelected = _selectedMood == moodName;
                        final styles = CloudiaryTheme.moodStyles[moodName]!;
                        
                        return GestureDetector(
                          onTap: () => setState(() => _selectedMood = moodName),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? styles['bg'] : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? styles['text']! : (isDark ? borderThemeColor : const Color(0xFFEEF2F6))),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (moodName == 'Joyful') const Text('😊 ')
                                else if (moodName == 'Calm') const Text('🌧️ ')
                                else if (moodName == 'Neutral') const Text('😐 ')
                                else if (moodName == 'Melancholy') const Text('😞 ')
                                else if (moodName == 'Anxious') const Text('⚡ ')
                                else if (moodName == 'Energized') const Text('⭐ ')
                                else if (moodName == 'Cozy') const Text('☕ '),
                                Text(
                                  moodName, 
                                  style: TextStyle(
                                    fontFamily: 'DMSans', 
                                    fontSize: 13, 
                                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal, 
                                    color: isSelected ? styles['text'] : textColor 
                                  )
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // 6. TAGS FIELD
                    Text('TAGS', style: CloudiaryTheme.metadataCaps.copyWith(color: mutedTextColor)), 
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(color: inputBgColor, borderRadius: BorderRadius.circular(20)), 
                            child: TextFormField(
                              controller: _tagController,
                              style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: textColor), 
                              decoration: InputDecoration(
                                hintText: "Add a tag...", 
                                hintStyle: TextStyle(color: mutedTextColor), 
                                border: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(color: Color(0xFFBFD7EA), shape: BoxShape.circle),
                          child: const Icon(Icons.local_offer_outlined, color: Color(0xFF2C4A60), size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // 7. ATTACH PHOTO COMPONENT
                    Text('ATTACH PHOTO', style: CloudiaryTheme.metadataCaps.copyWith(color: mutedTextColor)), 
                    const SizedBox(height: 12),

                    if (!_showPhotoOptions)
                      Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          color: cardColor, 
                          borderRadius: BorderRadius.circular(16), 
                          border: Border.all(color: const Color(0xFFBFD7EA), style: BorderStyle.solid, width: 1.2)
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => setState(() => _showPhotoOptions = true),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_outlined, color: mutedTextColor, size: 20), 
                              const SizedBox(width: 8),
                              Text('Add a photo to this entry', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, color: mutedTextColor)), 
                            ],
                          ),
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _handleImageSelection(ImageSource.camera), 
                              style: ElevatedButton.styleFrom(backgroundColor: inputBgColor, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), 
                              icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFF2C4A60), size: 18),
                              label: const Text('Camera', style: TextStyle(fontFamily: 'DMSans', color: Color(0xFF2C4A60))),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _handleImageSelection(ImageSource.gallery), 
                              style: ElevatedButton.styleFrom(backgroundColor: inputBgColor, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), 
                              icon: const Icon(Icons.image_outlined, color: Color(0xFF2C4A60), size: 18),
                              label: const Text('Gallery', style: TextStyle(fontFamily: 'DMSans', color: Color(0xFF2C4A60))),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => setState(() => _showPhotoOptions = false),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)), 
                              child: const Icon(Icons.close, color: Colors.grey, size: 18),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}