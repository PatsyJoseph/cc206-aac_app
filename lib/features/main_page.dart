/// main_page.dart is the core screen of the application that handles buttons,
/// tab navigation, drawer navigation, and button management features.
///
/// Key features include:
/// 1. Tab-based navigation for different button categories
/// 2. Sound playback on button press
/// 3. Button management (add/delete buttons)
/// 4. Interactive viewing with zoom and pan capabilities
/// 5. Persistent storage of button data from user added files/buttons

// Importing necessary libraries
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/screens/nav.dart';
// Importing necessary dart files
import '../screens/all.dart';
import '../screens/button_item.dart';
import '../screens/category1.dart';
import '../screens/category2.dart';
import '../screens/category3.dart';

class UlayawMainPage extends StatefulWidget {
  final String loggedInUser; // Add this to accept the logged-in user

  const UlayawMainPage({Key? key, required this.loggedInUser})
      : super(key: key);

  @override
  _UlayawMainPageState createState() => _UlayawMainPageState();
}

class _UlayawMainPageState extends State<UlayawMainPage>
    with TickerProviderStateMixin {
  late String _loggedInUser;
  // Controller for tab navigation: This controls switching between different categories
  late TabController _tabController;

  // Button Management State: This tracks if user is currently deleting buttons and the IDs of the
  // buttons selected for deletion
  bool ButtonDeleteMode = false;
  List<String> selectedItemIds = [];

  // Dialog state for adding new buttons
  bool showAddNewDialog = false;

  // Audio player instance for sound playback
  AudioPlayer audioPlayer = AudioPlayer();

  // Category Management: Tracks currently selected category and active button
  String selectedCategory = 'all';
  String activeButton = '';

  // Button Data: Stores all button data and controls button press animation
  List<CategoryButtonItem> buttons = [];
  List<AnimationController> _animationControllers = [];

  // New Button Creation: Temporarili stores image and sound for new button added by user
  File? newItemImage;
  String? newItemSound;

  // Interactive viewer control for zoom and pan functionality
  final TransformationController _transformationController =
      TransformationController();
  final double _minScale = 1.0;
  final double _maxScale = 2.0;

  /// Initializes the state of the widget
  /// Sets up controllers and loads saved buttons from user
  @override
  void initState() {
    super.initState();
    _loggedInUser = widget.loggedInUser;
    _loadAddedButtons();
    _tabController = TabController(length: 4, vsync: this);
    _transformationController.addListener(_onTransformationChanged);
  }

  // Method for lifecycle: Cleans up resources when a widget (button) is disposed
  @override
  void dispose() {
    _tabController.dispose();
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    // Dispose all button animation controllers
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    // Dispose audio player
    audioPlayer.dispose();
    super.dispose();
  }

  // Zoom and Pan Control: Allows the user to zoom and pan the section for the buttons
  void _onTransformationChanged() {
    // Get current scale level from transformation matrix
    final double scale = _transformationController.value.getMaxScaleOnAxis();
    if (scale < _minScale) {
      // Reset to minimum scale if zoomed out too far. This is needed to make sure
      // that the button interface will go back to its standard size when zoomed out.
      _transformationController.value = Matrix4.identity();
      // Limit maximum zoom level
    } else if (scale > _maxScale) {
      final Matrix4 matrix = Matrix4.copy(_transformationController.value);
      matrix.scale(_maxScale / scale);
      _transformationController.value = matrix;
    }
  }

  Future<void> _loadAddedButtons() async {
    final prefs = await SharedPreferences.getInstance();
    final buttonData = prefs.getStringList('buttons') ?? [];

    setState(() {
      buttons = buttonData.isEmpty
          ? List.generate(
              12,
              (index) => CategoryButtonItem(
                id: 'placeholder_$index',
                text: 'Button ${index + 1}',
                isPlaceholder: true,
              ),
            )
          : buttonData
              .map((item) => CategoryButtonItem.fromJson(json.decode(item)))
              .toList();
    });

    _setupButtonAnimations();
  }

  void _setupButtonAnimations() {
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

  Future<void> _showAddNewFormDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Add New Button'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      dropdownColor: Colors.white,
                      decoration: const InputDecoration(
                        labelText: 'Select Category',
                        labelStyle: TextStyle(color: Color(0xFF4D8FF8)),
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF4D8FF8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF4D8FF8)),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(
                            value: 'category1', child: Text('Pangngalan')),
                        DropdownMenuItem(
                            value: 'category2', child: Text('Kilos')),
                        DropdownMenuItem(
                            value: 'category3', child: Text('Direksyon')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: const Text('Pick Image'),
                      leading: const Icon(Icons.image),
                      onTap: () async {
                        await _pickImage();
                        setState(() {});
                      },
                    ),
                    ListTile(
                      title: const Text('Pick Sound'),
                      leading: const Icon(Icons.audio_file),
                      onTap: () async {
                        await _pickSound();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addNewButton();
                  },
                  child:
                      const Text('Add', style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      buttons[index].isSelected = !buttons[index].isSelected;
    });
  }

  Future<void> _addNewButton() async {
    if (newItemImage != null && newItemSound != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String imagePath =
          '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
      final String soundPath =
          '${directory.path}/sound_${DateTime.now().millisecondsSinceEpoch}.mp3';

      await newItemImage!.copy(imagePath);
      await File(newItemSound!).copy(soundPath);

      setState(() {
        buttons.add(CategoryButtonItem(
          id: 'custom_${buttons.length}',
          imagePath: imagePath,
          soundPath: soundPath,
          text: 'Item ${buttons.length + 1}',
          category: selectedCategory,
        ));
        newItemImage = null;
        newItemSound = null;
      });
      _saveButtons();
      _setupButtonAnimations();
    }
  }

  // Media Picker Method: Allows user to select image for new button from their local device
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        newItemImage = File(image.path);
      });
    }
  }

  // Sound Picker Method: Allows user to select mp3 file for new button from their local device
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

  // Audio Playback: Plays sound if path exists and is valid
  Future<void> _playItemSound(String? soundPath) async {
    if (soundPath != null && soundPath.isNotEmpty) {
      await audioPlayer.play(DeviceFileSource(soundPath));
    }
  }

  // Button Animation: Creates animation for the button when it is pressed
  void _animateButtonPress(int index) {
    _animationControllers[index].forward().then((_) {
      _animationControllers[index].reverse();
    });
  }

  // UI Building methods
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // App bar containing the icon for drawer, add, and delete buttons
        title: Text('Welcome, $_loggedInUser'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color: const Color(0xFF4D8FF8),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          if (!ButtonDeleteMode) ...[
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: const Color(0xFF4D8FF8),
              onPressed: _showAddNewFormDialog,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: const Color(0xFF4D8FF8),
              onPressed: () {
                setState(() {
                  ButtonDeleteMode = true;
                  selectedItemIds = [];
                });
              },
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.check),
              color: const Color(0xFF4D8FF8),
              onPressed: selectedItemIds.isNotEmpty
                  ? _showDeleteConfirmationDialog
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: const Color(0xFF4D8FF8),
              onPressed: () {
                setState(() {
                  ButtonDeleteMode = false;
                  selectedItemIds = [];
                  // Deselect all buttons
                  for (var button in buttons) {
                    button.isSelected = false;
                  }
                });
              },
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
      // Side navigation drawer: Contains the navigation to tutorial_page.dart and about_page.dart
      drawer: NavDrawer(activeNav: 'Main'), // Replaced the drawer with nav.dart
      body: Column(
        children: [
          if (ButtonDeleteMode)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.blue.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Select buttons to delete (${selectedItemIds.length} selected)',
                    style: const TextStyle(color: Color(0xFF4D8FF8)),
                  ),
                ],
              ),
            ),
          // Tab navigation bar: Contains the tabs for categories. This allows the navigation from one category to another
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.select_all)),
              Tab(icon: Icon(Icons.groups)),
              Tab(icon: Icon(Icons.notification_important)),
              Tab(icon: Icon(Icons.star)),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF4D8FF8),
            isScrollable: false,
          ),
          // Main content area with buttons
          Expanded(
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: _minScale,
              maxScale: _maxScale,
              boundaryMargin: const EdgeInsets.all(0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  All(
                    buttons: buttons,
                    onButtonPressed: (index) {
                      if (ButtonDeleteMode) {
                        _toggleDeleteSelection(index);
                      } else {
                        _playItemSound(buttons[index].soundPath);
                        _animateButtonPress(index);
                      }
                    },
                    onButtonLongPress:
                        ButtonDeleteMode ? null : _toggleSelection,
                    animationControllers: _animationControllers,
                    isDeleteMode: ButtonDeleteMode,
                  ),
                  Category1(
                    buttons: buttons,
                    onButtonPressed: (index) {
                      if (ButtonDeleteMode) {
                        _toggleDeleteSelection(index);
                      } else {
                        _playItemSound(buttons[index].soundPath);
                        _animateButtonPress(index);
                      }
                    },
                    onButtonLongPress:
                        ButtonDeleteMode ? null : _toggleSelection,
                    animationControllers: _animationControllers,
                    isDeleteMode: ButtonDeleteMode,
                  ),
                  Category2(
                    buttons: buttons,
                    onButtonPressed: (index) {
                      if (ButtonDeleteMode) {
                        _toggleDeleteSelection(index);
                      } else {
                        _playItemSound(buttons[index].soundPath);
                        _animateButtonPress(index);
                      }
                    },
                    onButtonLongPress:
                        ButtonDeleteMode ? null : _toggleSelection,
                    animationControllers: _animationControllers,
                    isDeleteMode: ButtonDeleteMode,
                  ),
                  Category3(
                    buttons: buttons,
                    onButtonPressed: (index) {
                      if (ButtonDeleteMode) {
                        _toggleDeleteSelection(index);
                      } else {
                        _playItemSound(buttons[index].soundPath);
                        _animateButtonPress(index);
                      }
                    },
                    onButtonLongPress:
                        ButtonDeleteMode ? null : _toggleSelection,
                    animationControllers: _animationControllers,
                    isDeleteMode: ButtonDeleteMode,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // This allows user to select or toggle buttons for deletion
  void _toggleDeleteSelection(int index) {
    setState(() {
      buttons[index].isSelected = !buttons[index].isSelected;
      if (buttons[index].isSelected) {
        selectedItemIds.add(buttons[index].id);
      } else {
        selectedItemIds.remove(buttons[index].id);
      }
    });
  }

  // Deletes all selected buttons or toggled buttons.
  Future<void> _deleteConfirmedButtons() async {
    setState(() {
      buttons.removeWhere((button) => selectedItemIds.contains(button.id));
      ButtonDeleteMode = false;
      selectedItemIds = [];
    });
    await _saveButtons();
    _setupButtonAnimations();
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete ${selectedItemIds.length} selected button${selectedItemIds.length > 1 ? 's' : ''}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteConfirmedButtons();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
