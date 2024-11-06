import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import categories
import '../screens/all.dart';
import '../screens/category1.dart';
import '../screens/category2.dart';
import '../screens/category3.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController; // for tab
  String activeButton = '';
  bool isDropdownOpen = false;
  bool isAddNewFormVisible = false;
  AudioPlayer audioPlayer = AudioPlayer();

  List<ButtonItem> buttons = [];
  List<AnimationController> _animationControllers = [];

  File? newItemImage;
  String? newItemSound;

  // Zoom and pan control variables
  TransformationController _transformationController =
      TransformationController();
  double _minScale = 1.0;
  double _maxScale = 2.0;

  @override
  void initState() {
    super.initState();
    _loadButtons();
    _tabController = TabController(length: 4, vsync: this); // for tab

    // Add a listener to reset transformation if zoomed out too far
    _transformationController.addListener(_onTransformationChanged);
  }

  @override
  void dispose() {
    _tabController.dispose(); // for tab
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    audioPlayer.dispose();
    super.dispose();
  }

// Method to reset the transformation if scale is below 1.0
  void _onTransformationChanged() {
    final double scale = _transformationController.value.getMaxScaleOnAxis();
    if (scale < _minScale) {
      _transformationController.value = Matrix4.identity();
    }
  }

  Future<void> _loadButtons() async {
    final prefs = await SharedPreferences.getInstance();
    final buttonData = prefs.getStringList('buttons') ?? [];

    if (buttonData.isEmpty) {
      setState(() {
        buttons = List.generate(
          12,
          (index) => ButtonItem(
            id: 'placeholder_$index',
            text: 'Button ${index + 1}',
            isPlaceholder: true,
          ),
        );
      });
    } else {
      setState(() {
        buttons = buttonData
            .map((item) => ButtonItem.fromJson(json.decode(item)))
            .toList();
      });
    }

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
      if (activeButton == 'ADD NEW') {
        isAddNewFormVisible = true;
        isDropdownOpen = false;
      } else if (activeButton == 'DELETE') {
        isDropdownOpen = true;
        isAddNewFormVisible = false;
      } else {
        isAddNewFormVisible = false;
        isDropdownOpen = false;
      }
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
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
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
        bottom: TabBar(
          // added for tab bar
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.groups)),
            Tab(icon: Icon(Icons.notification_important)),
            Tab(icon: Icon(Icons.star)),
            Tab(icon: Icon(Icons.select_all)),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFF4D8FF8),
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
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
                  leading: Icon(Icons.help_outline),
                  title: Text(
                    'Tutorial',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    // Tap gesture for Tutorial list item: Closes the drawer and navigates to the TutorialPage when tapped
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/tutorial');
                  },
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/about');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: activeButton == 'About'
                        ? Color(0xFFD2D9F5)
                        : Colors.white,
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 10),
                        Text(
                          'About',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF4D8FF8)),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    // Tap gesture for "ADD NEW" button: Sets the active button to "ADD NEW" and displays the form for adding a new item.
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4.0),
                      onTap: () => _setActiveButton('ADD NEW'),
                      highlightColor: Color(0xFFD2D9F5),
                      splashColor: Color(0xFFD2D9F5),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: activeButton == 'ADD NEW'
                              ? Color(0xFFD2D9F5)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          'ADD NEW',
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    // Tap gesture for "DELETE" button: Sets the active button to "DELETE" and displays the dropdown for deletion confirmation.
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4.0),
                      onTap: () => _setActiveButton('DELETE'),
                      highlightColor: Color(0xFFD2D9F5),
                      splashColor: Color(0xFFD2D9F5),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: activeButton == 'DELETE'
                              ? Color(0xFFD2D9F5)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
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
            if (isAddNewFormVisible)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFF4D8FF8)),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Pick Image'),
                      onTap:
                          _pickImage, // Tap gesture to open the image picker for selecting an image from local device
                    ),
                    ListTile(
                      title: Text(
                          'Pick Sound'), // Tap gesture to open the file picker for selecting mp3 file from local device.
                      onTap: _pickSound,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              'Add',
                              style: TextStyle(color: Colors.green),
                              textAlign: TextAlign.center,
                            ),
                            onTap:
                                _addNewItem, // Tap gesture to add the new item with the selected image and sound.
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                isAddNewFormVisible =
                                    false; // Tap gesture to hide the add new item form.
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
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFF4D8FF8)),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Confirm Delete'),
                      onTap:
                          _confirmDeletion, // Tap gesture to confirm the deletion of selected items.
                    ),
                    ListTile(
                      title: Text('Cancel'),
                      onTap: () {
                        setState(() {
                          isDropdownOpen =
                              false; // Tap gesture to close the dropdown menu without taking action.
                          activeButton = '';
                        });
                      },
                    ),
                  ],
                ),
              ),
            // Zoomable grid view
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        minScale: _minScale,
                        maxScale: _maxScale,
                        boundaryMargin: EdgeInsets.all(0),
                        child: Category1(
                          buttons: buttons
                              .where((button) =>
                                  button.id.startsWith('category1_'))
                              .toList(),
                          onButtonTap: _playItemSound,
                          isDeleteMode: activeButton == 'DELETE',
                          onToggleSelection: _toggleSelection,
                          animationControllers: _animationControllers,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        minScale: _minScale,
                        maxScale: _maxScale,
                        boundaryMargin: EdgeInsets.all(0),
                        child: Category2(
                          buttons: buttons
                              .where((button) =>
                                  button.id.startsWith('category2_'))
                              .toList(),
                          onButtonTap: _playItemSound,
                          isDeleteMode: activeButton == 'DELETE',
                          onToggleSelection: _toggleSelection,
                          animationControllers: _animationControllers,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        minScale: _minScale,
                        maxScale: _maxScale,
                        boundaryMargin: EdgeInsets.all(0),
                        child: Category3(
                          buttons: buttons
                              .where((button) =>
                                  button.id.startsWith('category3_'))
                              .toList(),
                          onButtonTap: _playItemSound,
                          isDeleteMode: activeButton == 'DELETE',
                          onToggleSelection: _toggleSelection,
                          animationControllers: _animationControllers,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        minScale: _minScale,
                        maxScale: _maxScale,
                        boundaryMargin: EdgeInsets.all(0),
                        child: All(
                          buttons: buttons,
                          onButtonTap: _playItemSound,
                          isDeleteMode: activeButton == 'DELETE',
                          onToggleSelection: _toggleSelection,
                          animationControllers: _animationControllers,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  ButtonItem({
    required this.id,
    required this.text,
    this.isPlaceholder = false,
    this.imagePath,
    this.soundPath,
    this.isSelected = false,
  });

  factory ButtonItem.fromJson(Map<String, dynamic> json) {
    return ButtonItem(
      id: json['id'],
      text: json['text'],
      isPlaceholder: json['isPlaceholder'] ?? false,
      imagePath: json['imagePath'],
      soundPath: json['soundPath'],
      isSelected: json['isSelected'] ?? false,
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
    };
  }
}
