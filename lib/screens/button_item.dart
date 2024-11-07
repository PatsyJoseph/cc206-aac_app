class CategoryButtonItem {
  final String id;
  final String? imagePath;
  final String? soundPath;
  final String text;
  final String category;
  bool isSelected;
  final bool isPlaceholder;

  CategoryButtonItem({
    required this.id,
    this.imagePath,
    this.soundPath,
    required this.text,
    this.category = 'all',
    this.isSelected = false,
    this.isPlaceholder = false,
  });

  // Add these methods if you're using JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'soundPath': soundPath,
      'text': text,
      'category': category,
      'isPlaceholder': isPlaceholder,
    };
  }

  factory CategoryButtonItem.fromJson(Map<String, dynamic> json) {
    return CategoryButtonItem(
      id: json['id'],
      imagePath: json['imagePath'],
      soundPath: json['soundPath'],
      text: json['text'],
      category: json['category'] ?? 'all',
      isPlaceholder: json['isPlaceholder'] ?? false,
    );
  }
}
