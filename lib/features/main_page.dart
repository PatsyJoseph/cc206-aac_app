import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/all.dart';
import '../screens/category1.dart';
import '../screens/category2.dart';
import '../screens/category3.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String activeButton = '';
  bool isDropdownOpen = false;
  bool isAddNewFormVisible = false;
  AudioPlayer audioPlayer = AudioPlayer();
  String selectedCategory = 'all';

  List<ButtonItem> buttons = [];
  List<AnimationController> _animationControllers = [];

  File? newItemImage;
  String? newItemSound;

  final TransformationController _transformationController =
      TransformationController();
  final double _minScale = 1.0;
  final double _maxScale = 2.0;

  @override
  void initState() {
    super.initState();
    _loadButtons();
    _tabController = TabController(length: 4, vsync: this);
    _transformationController.addListener(_onTransformationChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    audioPlayer.dispose();
    super.dispose();
  }

  void _onTransformationChanged() {
    final double scale = _transformationController.value.getMaxScaleOnAxis();
    if (scale < _minScale) {
      _transformationController.value = Matrix4.identity();
    }
  }

  Future<void> _loadButtons() async {
    final prefs = await SharedPreferences.getInstance();
    final buttonData = prefs.getStringList('buttons') ?? [];

    setState(() {
      buttons = buttonData.isEmpty
          ? List.generate(
              12,
              (index) => ButtonItem(
                id: 'placeholder_$index',
                text: 'Button ${index + 1}',
                isPlaceholder: true,
              ),
            )
          : buttonData
              .map((item) => ButtonItem.fromJson(json.decode(item)))
              .toList();
    });

    _initializeAnimationControllers();
  }

  void _initializeAnimationControllers() {
    _animationControllers = List.generate(
      buttons.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this,
      ),
    );
  }

  Future<void> _saveButtons() async {
    final prefs = await SharedPreferences.getInstance();
    final buttonData =
        buttons.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList('buttons', buttonData);
  }

  void _setActiveButton(String buttonName) {
    setState(() {
      activeButton = (activeButton == buttonName) ? '' : buttonName;
      isAddNewFormVisible = activeButton == 'ADD NEW';
      isDropdownOpen = activeButton == 'DELETE';
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      buttons[index].isSelected = !buttons[index].isSelected;
    });
  }

  void _confirmDeletion() {
    setState(() {
      buttons.removeWhere((button) => button.isSelected);
      activeButton = '';
      isDropdownOpen = false;
    });
    _saveButtons();
    _initializeAnimationControllers();
  }

  Future<void> _addNewItem() async {
    if (newItemImage != null && newItemSound != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String imagePath =
          '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
      final String soundPath =
          '${directory.path}/sound_${DateTime.now().millisecondsSinceEpoch}.mp3';

      await newItemImage!.copy(imagePath);
      await File(newItemSound!).copy(soundPath);

      setState(() {
        buttons.add(ButtonItem(
          id: 'custom_${buttons.length}',
          imagePath: imagePath,
          soundPath: soundPath,
          text: 'Item ${buttons.length + 1}',
          category: selectedCategory,
        ));
        newItemImage = null;
        newItemSound = null;
        isAddNewFormVisible = false;
        activeButton = '';
      });
      _saveButtons();
      _initializeAnimationControllers();
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        newItemImage = File(image.path);
      });
    }
  }

  Future<void> _pickSound() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        newItemSound = result.files.single.path;
      });
    }
  }

  Future<void> _playItemSound(String? soundPath) async {
    if (soundPath != null && soundPath.isNotEmpty) {
      await audioPlayer.play(DeviceFileSource(soundPath));
    }
  }

  void _animateButton(int index) {
    _animationControllers[index].forward().then((_) {
      _animationControllers[index].reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.groups)),
            Tab(icon: Icon(Icons.notification_important)),
            Tab(icon: Icon(Icons.star)),
            Tab(icon: Icon(Icons.select_all)),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF4D8FF8),
          isScrollable: false,
        ),
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(isAddNewFormVisible || isDropdownOpen ? 250 : 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Action Buttons Row
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF4D8FF8)),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4.0),
                        onTap: () => _setActiveButton('ADD NEW'),
                        highlightColor: const Color(0xFFD2D9F5),
                        splashColor: const Color(0xFFD2D9F5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: activeButton == 'ADD NEW'
                                ? const Color(0xFFD2D9F5)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Text(
                            'ADD NEW',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4.0),
                        onTap: () => _setActiveButton('DELETE'),
                        highlightColor: const Color(0xFFD2D9F5),
                        splashColor: const Color(0xFFD2D9F5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: activeButton == 'DELETE'
                                ? const Color(0xFFD2D9F5)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Text(
                            'DELETE',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Forms
              if (isAddNewFormVisible)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF4D8FF8)),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Select Category',
                            labelStyle: TextStyle(color: Color(0xFF4D8FF8)),
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text('All'),
                            ),
                            DropdownMenuItem(
                              value: 'category1',
                              child: Text('Category 1'),
                            ),
                            DropdownMenuItem(
                              value: 'category2',
                              child: Text('Category 2'),
                            ),
                            DropdownMenuItem(
                              value: 'category3',
                              child: Text('Category 3'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Pick Image'),
                        leading: const Icon(Icons.image),
                        onTap: _pickImage,
                      ),
                      ListTile(
                        title: const Text('Pick Sound'),
                        leading: const Icon(Icons.audio_file),
                        onTap: _pickSound,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text(
                                'Add',
                                style: TextStyle(color: Colors.green),
                                textAlign: TextAlign.center,
                              ),
                              onTap: _addNewItem,
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  isAddNewFormVisible = false;
                                  activeButton = '';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (isDropdownOpen)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF4D8FF8)),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Confirm Delete'),
                        onTap: _confirmDeletion,
                      ),
                      ListTile(
                        title: const Text('Cancel'),
                        onTap: () {
                          setState(() {
                            isDropdownOpen = false;
                            activeButton = '';
                          });
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      drawer: FractionallySizedBox(
        widthFactor: 0.75,
        child: Drawer(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Ulayaw',
                          style: TextStyle(
                            color: Color(0xFF4D8FF8),
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Tutorial', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/tutorial');
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/about');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    color: activeButton == 'About'
                        ? const Color(0xFFD2D9F5)
                        : Colors.white,
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 10),
                        Text('About', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Category1(),
          Category2(),
          Category3(),
          All(
            buttons: [],
          ),
        ],
      ),
    );
  }
}

class ButtonItem {
  final String id;
  final String text;
  final bool isPlaceholder;
  String? imagePath;
  String? soundPath;
  bool isSelected;
  String category;

  ButtonItem({
    required this.id,
    required this.text,
    this.isPlaceholder = false,
    this.imagePath,
    this.soundPath,
    this.isSelected = false,
    this.category = 'all',
  });

  factory ButtonItem.fromJson(Map<String, dynamic> json) {
    return ButtonItem(
      id: json['id'],
      text: json['text'],
      isPlaceholder: json['isPlaceholder'] ?? false,
      imagePath: json['imagePath'],
      soundPath: json['soundPath'],
      isSelected: json['isSelected'] ?? false,
      category: json['category'] ?? 'all',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isPlaceholder': isPlaceholder,
      'imagePath': imagePath,
      'soundPath': soundPath,
      'isSelected': isSelected,
      'category': category,
    };
  }
}
