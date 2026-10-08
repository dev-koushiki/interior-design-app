import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/project_service.dart';
import 'services/design_service.dart';
import 'screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    providerAndroid: const AndroidDebugProvider(),
  );

  runApp(const HavenAiApp());
}

const Color forest = Color(0xFF254D3A);
const Color forestDark = Color(0xFF183B2B);
const Color canvas = Color(0xFFF8F7F3);
const Color ink = Color(0xFF202B24);
const Color muted = Color(0xFF777D78);
const Color line = Color(0xFFE7E9E3);

const List<String> roomTypes = [
'Living room',
'Bedroom',
'Kitchen',
'Bathroom',
'Dining room',
'Office',
'Balcony',
'Kids room',
'Study room',
];

const List<IconData> roomIcons = [
Icons.weekend_outlined,
Icons.bed_outlined,
Icons.kitchen_outlined,
Icons.bathtub_outlined,
Icons.dining_outlined,
Icons.desk_outlined,
Icons.deck_outlined,
Icons.toys_outlined,
Icons.menu_book_outlined,
];

const List<String> designStyles = [
'Modern',
'Minimalist',
'Luxury',
'Scandinavian',
'Industrial',
'Bohemian',
'Contemporary',
'Traditional',
];

class HavenAiApp extends StatelessWidget {
const HavenAiApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'ArchiNest',
debugShowCheckedModeBanner: false,
theme: ThemeData(
useMaterial3: true,
scaffoldBackgroundColor: canvas,
colorScheme: ColorScheme.fromSeed(
seedColor: forest,
surface: canvas,
),
appBarTheme: const AppBarTheme(
backgroundColor: canvas,
foregroundColor: ink,
elevation: 0,
centerTitle: false,
),
fontFamily: 'Roboto',
),
home: const MainNavigation(),
);
}
}

class MainNavigation extends StatefulWidget {
const MainNavigation({super.key});

@override
State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
int selectedIndex = 0;

void openDesign({String? room, String? style}) {
Navigator.of(context).push(
MaterialPageRoute(
builder: (_) => DesignPage(
initialRoom: room,
initialStyle: style,
),
),
);
}

@override
Widget build(BuildContext context) {
final pages = [
HomePage(
onStartDesign: () => openDesign(),
onRoomSelected: (room) => openDesign(room: room),
onStyleSelected: (style) => openDesign(style: style),
),
const ProjectsPage(),
DesignPage(
onBackToHome: () {
setState(() => selectedIndex = 0);
},
),
const FavoritesPage(),
const ProfilePage(),
];

return Scaffold(
body: IndexedStack(
index: selectedIndex,
children: pages,
),
bottomNavigationBar: NavigationBar(
selectedIndex: selectedIndex,
onDestinationSelected: (index) {
setState(() => selectedIndex = index);
},
backgroundColor: Colors.white,
indicatorColor: const Color(0xFFE2EBE4),
destinations: const [
NavigationDestination(
icon: Icon(Icons.home_outlined),
selectedIcon: Icon(Icons.home),
label: 'Home',
),
NavigationDestination(
icon: Icon(Icons.folder_outlined),
selectedIcon: Icon(Icons.folder),
label: 'Projects',
),
NavigationDestination(
icon: Icon(Icons.auto_awesome_outlined),
selectedIcon: Icon(Icons.auto_awesome),
label: 'Design',
),
NavigationDestination(
icon: Icon(Icons.favorite_border),
selectedIcon: Icon(Icons.favorite),
label: 'Favorites',
),
NavigationDestination(
icon: Icon(Icons.person_outline),
selectedIcon: Icon(Icons.person),
label: 'Profile',
),
],
),
);
}
}

class HomePage extends StatelessWidget {
final VoidCallback onStartDesign;
final ValueChanged<String> onRoomSelected;
final ValueChanged<String> onStyleSelected;

const HomePage({
super.key,
required this.onStartDesign,
required this.onRoomSelected,
required this.onStyleSelected,
});

@override
Widget build(BuildContext context) {
return SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
height: 46,
width: 46,
decoration: BoxDecoration(
color: forest,
borderRadius: BorderRadius.circular(15),
),
child: const Icon(
Icons.chair_alt_rounded,
color: Colors.white,
size: 26,
),
),
const SizedBox(width: 11),
const Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'ArchiNest',
style: TextStyle(
fontSize: 21,
fontWeight: FontWeight.bold,
color: forest,
),
),
Text(
'Design your dream home',
style: TextStyle(
fontSize: 11,
color: muted,
),
),
],
),
),
IconButton(
tooltip: 'Notifications',
onPressed: () => _showMessage(
context,
'Notifications will appear here.',
),
icon: const Icon(Icons.notifications_none_rounded),
style: IconButton.styleFrom(
backgroundColor: Colors.white,
foregroundColor: forest,
),
),
const SizedBox(width: 3),
const CircleAvatar(
radius: 21,
backgroundColor: Color(0xFFE4E8DF),
child: Icon(
Icons.person,
color: forest,
),
),
],
),
const SizedBox(height: 28),
const Text(
'Good morning!',
style: TextStyle(
fontSize: 14,
color: muted,
),
),
const SizedBox(height: 5),
const Text(
'Let’s design your\ndream space.',
style: TextStyle(
fontSize: 29,
height: 1.18,
fontWeight: FontWeight.bold,
color: ink,
),
),
const SizedBox(height: 20),
Container(
width: double.infinity,
padding: const EdgeInsets.all(21),
decoration: BoxDecoration(
color: forest,
borderRadius: BorderRadius.circular(25),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
padding: const EdgeInsets.symmetric(
horizontal: 11,
vertical: 7,
),
decoration: BoxDecoration(
color: Colors.white.withOpacity(.14),
borderRadius: BorderRadius.circular(30),
),
child: const Text(
'AI-POWERED INTERIOR DESIGN',
style: TextStyle(
color: Colors.white,
fontSize: 9,
letterSpacing: .8,
fontWeight: FontWeight.w700,
),
),
),
const SizedBox(height: 17),
const Text(
'Your room,\nreimagined.',
style: TextStyle(
color: Colors.white,
fontSize: 27,
height: 1.16,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 9),
Text(
'Upload a photo and explore beautiful designs made for your space.',
style: TextStyle(
color: Colors.white.withOpacity(.82),
fontSize: 13,
height: 1.5,
),
),
const SizedBox(height: 18),
FilledButton.icon(
onPressed: onStartDesign,
icon: const Icon(
Icons.auto_awesome,
size: 18,
),
label: const Text('Start designing'),
style: FilledButton.styleFrom(
backgroundColor: Colors.white,
foregroundColor: forest,
padding: const EdgeInsets.symmetric(
horizontal: 17,
vertical: 13,
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(13),
),
),
),
],
),
),
const SizedBox(height: 27),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
'Explore rooms',
style: TextStyle(
fontSize: 19,
fontWeight: FontWeight.bold,
color: ink,
),
),
TextButton(
onPressed: () {
Navigator.of(context).push(
MaterialPageRoute(
builder: (_) => AllRoomsPage(
onRoomSelected: onRoomSelected,
),
),
);
},
child: const Text(
'View all',
style: TextStyle(
color: forest,
fontWeight: FontWeight.w600,
),
),
),
],
),
const SizedBox(height: 9),
SizedBox(
height: 112,
child: ListView.separated(
scrollDirection: Axis.horizontal,
itemCount: 5,
separatorBuilder: (_, __) =>
const SizedBox(width: 10),
itemBuilder: (context, index) => RoomCard(
title: roomTypes[index],
icon: roomIcons[index],
onTap: () => onRoomSelected(roomTypes[index]),
),
),
),
const SizedBox(height: 25),
const Text(
'Popular design styles',
style: TextStyle(
fontSize: 19,
fontWeight: FontWeight.bold,
color: ink,
),
),
const SizedBox(height: 13),
Wrap(
spacing: 8,
runSpacing: 9,
children: designStyles
    .take(6)
    .map(
(style) => StyleChip(
title: style,
onTap: () => onStyleSelected(style),
),
)
    .toList(),
),
const SizedBox(height: 22),
Container(
padding: const EdgeInsets.all(15),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(18),
border: Border.all(color: line),
),
child: Row(
children: [
const Icon(
Icons.compare_arrows_rounded,
color: forest,
size: 25,
),
const SizedBox(width: 11),
const Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Before & after comparison',
style: TextStyle(
fontWeight: FontWeight.bold,
color: ink,
),
),
SizedBox(height: 3),
Text(
'Compare your room with a redesigned version.',
style: TextStyle(
fontSize: 11,
color: muted,
),
),
],
),
),
const Icon(
Icons.chevron_right,
color: muted,
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

void _showMessage(BuildContext context, String message) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(message),
),
);
}

class RoomCard extends StatelessWidget {
final IconData icon;
final String title;
final VoidCallback onTap;

const RoomCard({
super.key,
required this.icon,
required this.title,
required this.onTap,
});

@override
Widget build(BuildContext context) {
return SizedBox(
width: 100,
child: Material(
color: Colors.white,
borderRadius: BorderRadius.circular(17),
child: InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(17),
child: Container(
padding: const EdgeInsets.all(10),
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(17),
border: Border.all(color: line),
),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
icon,
size: 29,
color: forest,
),
const SizedBox(height: 8),
Text(
title,
textAlign: TextAlign.center,
maxLines: 2,
style: const TextStyle(
fontSize: 11,
fontWeight: FontWeight.w600,
color: ink,
),
),
],
),
),
),
),
);
}
}

class StyleChip extends StatelessWidget {
final String title;
final VoidCallback onTap;

const StyleChip({
super.key,
required this.title,
required this.onTap,
});

@override
Widget build(BuildContext context) {
return ActionChip(
label: Text(title),
onPressed: onTap,
backgroundColor: Colors.white,
side: const BorderSide(color: line),
labelStyle: const TextStyle(
color: forest,
fontSize: 12,
fontWeight: FontWeight.w500,
),
shape: const StadiumBorder(),
padding: const EdgeInsets.symmetric(
horizontal: 5,
vertical: 3,
),
);
}
}

class AllRoomsPage extends StatelessWidget {
final ValueChanged<String> onRoomSelected;

const AllRoomsPage({
super.key,
required this.onRoomSelected,
});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
'Explore all rooms',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),
body: GridView.builder(
padding: const EdgeInsets.all(20),
itemCount: roomTypes.length,
gridDelegate:
const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 2,
mainAxisSpacing: 13,
crossAxisSpacing: 13,
childAspectRatio: 1.15,
),
itemBuilder: (context, index) => RoomCard(
title: roomTypes[index],
icon: roomIcons[index],
onTap: () {
Navigator.pop(context);
onRoomSelected(roomTypes[index]);
},
),
),
);
}
}

class DesignPage extends StatefulWidget {
final String? initialRoom;
final String? initialStyle;
final VoidCallback? onBackToHome;

const DesignPage({
super.key,
this.initialRoom,
this.initialStyle,
this.onBackToHome,
});

@override
State<DesignPage> createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
final ImagePicker _picker = ImagePicker();
File? selectedImage;
late String selectedRoom;
late String selectedStyle;

@override
void initState() {
super.initState();
selectedRoom = widget.initialRoom ?? roomTypes.first;
selectedStyle = widget.initialStyle ?? designStyles.first;
}

Future<void> _chooseImageSource() async {
FocusScope.of(context).unfocus();

final source = await showModalBottomSheet<ImageSource>(
context: context,
backgroundColor: Colors.white,
shape: const RoundedRectangleBorder(
borderRadius: BorderRadius.vertical(
top: Radius.circular(24),
),
),
builder: (sheetContext) => SafeArea(
child: Padding(
padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Container(
width: 38,
height: 4,
decoration: BoxDecoration(
color: const Color(0xFFD8DCD6),
borderRadius: BorderRadius.circular(8),
),
),
const SizedBox(height: 18),
const Text(
'Add a room photo',
style: TextStyle(
fontSize: 19,
fontWeight: FontWeight.bold,
color: ink,
),
),
const SizedBox(height: 5),
const Text(
'Take a new photo or choose one from your device.',
style: TextStyle(
color: muted,
fontSize: 12,
),
),
const SizedBox(height: 20),
Row(
children: [
Expanded(
child: _SourceTile(
icon: Icons.camera_alt_outlined,
title: 'Take photo',
onTap: () {
Navigator.pop(
sheetContext,
ImageSource.camera,
);
},
),
),
const SizedBox(width: 12),
Expanded(
child: _SourceTile(
icon: Icons.photo_library_outlined,
title: 'Choose from gallery',
onTap: () {
Navigator.pop(
sheetContext,
ImageSource.gallery,
);
},
),
),
],
),
],
),
),
),
);

if (source == null) return;

try {
final XFile? image = await _picker.pickImage(
source: source,
// Prefer the phone's rear camera for photographing a real room.
// On an emulator, the camera feed still depends on its camera settings.
preferredCameraDevice: CameraDevice.rear,
imageQuality: 95,
maxWidth: 3000,
requestFullMetadata: false,
);

if (image != null && mounted) {
setState(() {
selectedImage = File(image.path);
});
}
} catch (e) {
if (mounted) {
_showMessage(
context,
'Could not open ${source == ImageSource.camera ? 'camera' : 'gallery'}. Check app permissions and try again.',
);
}
}
}

void _generateDesign() {
if (selectedImage == null) {
_showMessage(
context,
'Please take or choose a room photo first.',
);
return;
}

Navigator.of(context).push(
MaterialPageRoute(
builder: (_) => RoomMeasurementPage(
originalImage: selectedImage!,
room: selectedRoom,
style: selectedStyle,
),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
'AI Design Studio',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
leading: widget.onBackToHome == null
? null
    : IconButton(
icon: const Icon(Icons.arrow_back),
onPressed: widget.onBackToHome,
),
),
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Transform your space',
style: TextStyle(
fontSize: 25,
fontWeight: FontWeight.bold,
color: ink,
),
),
const SizedBox(height: 6),
const Text(
'Start with a clear photo. Then choose the room and style you want to explore.',
style: TextStyle(
fontSize: 13,
height: 1.5,
color: muted,
),
),
const SizedBox(height: 23),
const _StepHeading(
number: '1',
title: 'Add your room photo',
subtitle: 'Use your camera or select an existing photo.',
),
const SizedBox(height: 12),
InkWell(
onTap: _chooseImageSource,
borderRadius: BorderRadius.circular(20),
child: Container(
width: double.infinity,
height: 225,
decoration: BoxDecoration(
color: const Color(0xFFEDEFE9),
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: const Color(0xFFD8DED5),
),
),
child: selectedImage == null
? const Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.add_photo_alternate_outlined,
size: 45,
color: forest,
),
SizedBox(height: 10),
Text(
'Tap to add a photo',
style: TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
color: forest,
),
),
SizedBox(height: 5),
Text(
'Camera or photo gallery',
style: TextStyle(
fontSize: 12,
color: muted,
),
),
],
)
    : Stack(
fit: StackFit.expand,
children: [
ClipRRect(
borderRadius: BorderRadius.circular(19),
child: Image.file(
selectedImage!,
fit: BoxFit.cover,
),
),
Positioned(
right: 10,
top: 10,
child: Container(
decoration: const BoxDecoration(
color: Colors.white,
shape: BoxShape.circle,
),
child: IconButton(
icon: const Icon(
Icons.edit,
color: forest,
),
onPressed: _chooseImageSource,
tooltip: 'Change photo',
),
),
),
],
),
),
),
if (selectedImage != null) ...[
const SizedBox(height: 8),
const Row(
children: [
Icon(
Icons.check_circle,
color: forest,
size: 16,
),
SizedBox(width: 6),
Text(
'Photo added. Tap the image to change it.',
style: TextStyle(
color: forest,
fontSize: 11,
),
),
],
),
],
const SizedBox(height: 24),
const _StepHeading(
number: '2',
title: 'Choose a room',
subtitle: 'Tell us which space you want to redesign.',
),
const SizedBox(height: 12),
Wrap(
spacing: 8,
runSpacing: 8,
children: roomTypes
    .map(
(room) => ChoiceChip(
label: Text(room),
selected: selectedRoom == room,
onSelected: (_) {
setState(() {
selectedRoom = room;
});
},
selectedColor: const Color(0xFFDDE9DF),
checkmarkColor: forest,
side: BorderSide(
color: selectedRoom == room ? forest : line,
),
),
)
    .toList(),
),
const SizedBox(height: 24),
const _StepHeading(
number: '3',
title: 'Choose a design style',
subtitle: 'You can change this later and compare versions.',
),
const SizedBox(height: 12),
Wrap(
spacing: 8,
runSpacing: 8,
children: designStyles
    .map(
(style) => ChoiceChip(
label: Text(style),
selected: selectedStyle == style,
onSelected: (_) {
setState(() {
selectedStyle = style;
});
},
selectedColor: const Color(0xFFDDE9DF),
checkmarkColor: forest,
side: BorderSide(
color: selectedStyle == style ? forest : line,
),
),
)
    .toList(),
),
const SizedBox(height: 28),
SizedBox(
width: double.infinity,
height: 54,
child: FilledButton.icon(
onPressed: _generateDesign,
icon: const Icon(Icons.auto_awesome),
label: const Text(
'Continue to design preview',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
style: FilledButton.styleFrom(
backgroundColor: forest,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(15),
),
),
),
),
const SizedBox(height: 9),
const Center(
child: Text(
'AI image generation will be connected to the backend.',
style: TextStyle(
color: muted,
fontSize: 11,
),
),
),
],
),
),
),
);
}
}

class _SourceTile extends StatelessWidget {
final IconData icon;
final String title;
final VoidCallback onTap;

const _SourceTile({
required this.icon,
required this.title,
required this.onTap,
});

@override
Widget build(BuildContext context) => Material(
color: canvas,
borderRadius: BorderRadius.circular(16),
child: InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(16),
child: Padding(
padding: const EdgeInsets.symmetric(
vertical: 19,
horizontal: 8,
),
child: Column(
children: [
Icon(
icon,
color: forest,
size: 29,
),
const SizedBox(height: 8),
Text(
title,
textAlign: TextAlign.center,
style: const TextStyle(
color: ink,
fontSize: 12,
fontWeight: FontWeight.w600,
),
),
],
),
),
),
);
}

class _StepHeading extends StatelessWidget {
final String number;
final String title;
final String subtitle;

const _StepHeading({
required this.number,
required this.title,
required this.subtitle,
});

@override
Widget build(BuildContext context) => Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
width: 27,
height: 27,
alignment: Alignment.center,
decoration: const BoxDecoration(
color: forest,
shape: BoxShape.circle,
),
child: Text(
number,
style: const TextStyle(
color: Colors.white,
fontSize: 12,
fontWeight: FontWeight.bold,
),
),
),
const SizedBox(width: 10),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: ink,
),
),
const SizedBox(height: 3),
Text(
subtitle,
style: const TextStyle(
fontSize: 11,
color: muted,
),
),
],
),
),
],
);
}

class RoomMeasurementPage extends StatefulWidget {
final File originalImage;
final String room;
final String style;

const RoomMeasurementPage({
super.key,
required this.originalImage,
required this.room,
required this.style,
});

@override
State<RoomMeasurementPage> createState() => _RoomMeasurementPageState();
}

class _RoomMeasurementPageState extends State<RoomMeasurementPage> {
final _formKey = GlobalKey<FormState>();
final _lengthController = TextEditingController();
final _widthController = TextEditingController();
final _heightController = TextEditingController();
String _unit = 'ft';

@override
void dispose() {
_lengthController.dispose();
_widthController.dispose();
_heightController.dispose();
super.dispose();
}

String? _validateDimension(String? value) {
final number = double.tryParse((value ?? '').trim());
if (number == null || number <= 0) {
return 'Enter a valid measurement';
}
if (number > 1000) return 'Measurement is too large';
return null;
}

void _continue() {
if (!_formKey.currentState!.validate()) return;
Navigator.of(context).push(
MaterialPageRoute(
builder: (_) => DesignResultPage(
originalImage: widget.originalImage,
room: widget.room,
style: widget.style,
roomLength: _lengthController.text.trim(),
roomWidth: _widthController.text.trim(),
roomHeight: _heightController.text.trim(),
measurementUnit: _unit,
),
),
);
}

Widget _measurementField({
required String label,
required String hint,
required TextEditingController controller,
required IconData icon,
}) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(label, style: const TextStyle(
color: ink, fontSize: 13, fontWeight: FontWeight.w600,
)),
const SizedBox(height: 8),
TextFormField(
controller: controller,
keyboardType: const TextInputType.numberWithOptions(decimal: true),
validator: _validateDimension,
decoration: InputDecoration(
hintText: hint,
prefixIcon: Icon(icon, color: forest),
suffixText: _unit,
filled: true,
fillColor: Colors.white,
contentPadding: const EdgeInsets.symmetric(vertical: 16),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(color: line),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(color: line),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(color: forest, width: 1.5),
),
),
),
],
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Room measurements', style: TextStyle(fontWeight: FontWeight.bold)),
),
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
child: Form(
key: _formKey,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text('Tell us the room size', style: TextStyle(
fontSize: 25, fontWeight: FontWeight.bold, color: ink,
)),
const SizedBox(height: 7),
const Text(
'Enter approximate measurements so your design can be planned around your space.',
style: TextStyle(color: muted, fontSize: 13, height: 1.5),
),
const SizedBox(height: 18),
ClipRRect(
borderRadius: BorderRadius.circular(18),
child: Image.file(widget.originalImage, height: 190, width: double.infinity, fit: BoxFit.cover),
),
const SizedBox(height: 10),
Text('${widget.room} · ${widget.style}', style: const TextStyle(color: muted, fontSize: 12)),
const SizedBox(height: 22),
const Text('Measurement unit', style: TextStyle(color: ink, fontWeight: FontWeight.w600, fontSize: 13)),
const SizedBox(height: 8),
SegmentedButton<String>(
segments: const [
ButtonSegment(value: 'ft', label: Text('Feet (ft)')),
ButtonSegment(value: 'm', label: Text('Meters (m)')),
],
selected: {_unit},
onSelectionChanged: (selection) => setState(() => _unit = selection.first),
style: ButtonStyle(
foregroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? Colors.white : forest),
backgroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? forest : Colors.white),
),
),
const SizedBox(height: 18),
_measurementField(label: 'Room length', hint: 'e.g. 12', controller: _lengthController, icon: Icons.straighten),
const SizedBox(height: 16),
_measurementField(label: 'Room width', hint: 'e.g. 10', controller: _widthController, icon: Icons.width_full),
const SizedBox(height: 16),
_measurementField(label: 'Room height', hint: 'e.g. 9', controller: _heightController, icon: Icons.height),
const SizedBox(height: 24),
SizedBox(
width: double.infinity,
height: 54,
child: FilledButton.icon(
onPressed: _continue,
icon: const Icon(Icons.arrow_forward),
label: const Text('Continue to design preview', style: TextStyle(fontWeight: FontWeight.bold)),
style: FilledButton.styleFrom(
backgroundColor: forest,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
),
),
),
const SizedBox(height: 8),
const Center(child: Text('You can edit these measurements later.', style: TextStyle(color: muted, fontSize: 11))),
],
),
),
),
),
);
}
}

class DesignResultPage extends StatefulWidget {
final File originalImage;
final String room;
final String style;
final String roomLength;
final String roomWidth;
final String roomHeight;
final String measurementUnit;

const DesignResultPage({
super.key,
required this.originalImage,
required this.room,
required this.style,
required this.roomLength,
required this.roomWidth,
required this.roomHeight,
required this.measurementUnit,
});

@override
State<DesignResultPage> createState() => _DesignResultPageState();
}

class _DesignResultPageState extends State<DesignResultPage> {
final ImagePicker _picker = ImagePicker();
File? latestImage;
bool _isGenerating = false;

Future<void> _generateAiDesign() async {
if (_isGenerating) return;
setState(() => _isGenerating = true);
try {
final generatedFile = await DesignService.generateDesign(
imageFile: widget.originalImage,
room: widget.room,
style: widget.style,
roomLength: widget.roomLength,
roomWidth: widget.roomWidth,
roomHeight: widget.roomHeight,
measurementUnit: widget.measurementUnit,
);
if (!mounted) return;
setState(() => latestImage = generatedFile);
_showMessage(context, 'AI design generated successfully.');
} catch (error) {
if (!mounted) return;
_showMessage(context, error.toString().replaceFirst('Exception: ', ''));
} finally {
if (mounted) setState(() => _isGenerating = false);
}
}

Future<void> _saveProject() async {
try {
final project = await ProjectService.createProject(
projectName: '${widget.room} - ${widget.style}',
roomType: widget.room,
description: 'Interior design in ${widget.style} style. Room size: ${widget.roomLength} x ${widget.roomWidth} x ${widget.roomHeight} ${widget.measurementUnit}.',
originalImage: widget.originalImage.path,
generatedDesigns: latestImage == null ? [] : [latestImage!.path],
);
if (!mounted) return;
_showMessage(context, 'Project saved successfully.');
} catch (error) {
if (!mounted) return;
_showMessage(context, error.toString().replaceFirst('Exception: ', ''));
}
}

Future<void> _chooseLatestImage() async {
try {
final image = await _picker.pickImage(
source: ImageSource.gallery,
imageQuality: 90,
maxWidth: 2200,
);

if (image != null && mounted) {
setState(() {
latestImage = File(image.path);
});
}
} catch (_) {
if (mounted) {
_showMessage(
context,
'Could not open the gallery. Please try again.',
);
}
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
'Design preview',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.fromLTRB(20, 8, 20, 25),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'${widget.room} · ${widget.style}',
style: const TextStyle(
color: muted,
fontSize: 13,
),
),
const SizedBox(height: 5),
Text(
'Room size: ${widget.roomLength} × ${widget.roomWidth} × ${widget.roomHeight} ${widget.measurementUnit}',
style: const TextStyle(color: muted, fontSize: 11),
),
const SizedBox(height: 8),
const Text(
'Your room, reimagined',
style: TextStyle(
fontSize: 25,
fontWeight: FontWeight.bold,
color: ink,
),
),
const SizedBox(height: 7),
const Text(
'Your original photo is ready. The AI-generated result will appear here once generation is connected.',
style: TextStyle(
color: muted,
fontSize: 12,
height: 1.5,
),
),
const SizedBox(height: 18),
ClipRRect(
borderRadius: BorderRadius.circular(20),
child: Image.file(
widget.originalImage,
height: 220,
width: double.infinity,
fit: BoxFit.cover,
),
),
const SizedBox(height: 8),
const Text(
'BEFORE · ORIGINAL ROOM',
style: TextStyle(
fontSize: 10,
letterSpacing: .8,
fontWeight: FontWeight.bold,
color: muted,
),
),
const SizedBox(height: 16),
SizedBox(
width: double.infinity,
height: 52,
child: FilledButton.icon(
onPressed: _isGenerating ? null : _generateAiDesign,
icon: _isGenerating
? const SizedBox(
width: 18,
height: 18,
child: CircularProgressIndicator(
strokeWidth: 2,
color: Colors.white,
),
)
    : const Icon(Icons.auto_awesome),
label: Text(
_isGenerating ? 'Generating your design...' : 'Generate AI design',
style: const TextStyle(fontWeight: FontWeight.w600),
),
style: FilledButton.styleFrom(
backgroundColor: forest,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
),
),
const SizedBox(height: 8),
const Text(
'Creates a redesign using your room photo and selected style.',
style: TextStyle(color: muted, fontSize: 11),
),
const SizedBox(height: 16),
Container(
width: double.infinity,
height: 180,
decoration: BoxDecoration(
color: const Color(0xFFE9ECE6),
borderRadius: BorderRadius.circular(18),
border: Border.all(color: line),
),
child: latestImage == null
? Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Icon(
Icons.auto_awesome,
color: forest,
size: 32,
),
const SizedBox(height: 8),
const Text(
'Your latest design will appear here',
style: TextStyle(
color: ink,
fontWeight: FontWeight.w600,
),
),
const SizedBox(height: 4),
const Text(
'Generate a design above or choose an image to test',
style: TextStyle(
color: muted,
fontSize: 11,
),
),
const SizedBox(height: 8),
OutlinedButton.icon(
onPressed: _chooseLatestImage,
icon: const Icon(Icons.image_outlined),
label: const Text('Choose result image to test'),
),
],
)
    : ClipRRect(
borderRadius: BorderRadius.circular(17),
child: Image.file(
latestImage!,
fit: BoxFit.cover,
width: double.infinity,
),
),
),
const SizedBox(height: 8),
const Text(
'AFTER · LATEST DESIGN',
style: TextStyle(
fontSize: 10,
letterSpacing: .8,
fontWeight: FontWeight.bold,
color: muted,
),
),
const SizedBox(height: 20),
SizedBox(
width: double.infinity,
height: 52,
child: FilledButton.icon(
onPressed: () async {
final editedImage = await Navigator.of(context).push<File>(
MaterialPageRoute(
builder: (_) => RoomCustomizerPage(
imageFile: latestImage ?? widget.originalImage,
),
),
);
if (editedImage != null && mounted) {
setState(() => latestImage = editedImage);
_showMessage(context, 'Your customized design is ready.');
}
},
icon: const Icon(Icons.palette_outlined),
label: const Text('Customize your room'),
style: FilledButton.styleFrom(
backgroundColor: forest,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
),
),
const SizedBox(height: 10),
SizedBox(
width: double.infinity,
height: 52,
child: OutlinedButton.icon(
onPressed: _saveProject,
icon: const Icon(Icons.bookmark_add_outlined),
label: const Text('Save project'),
style: OutlinedButton.styleFrom(
foregroundColor: forest,
side: const BorderSide(color: forest),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
),
),
const SizedBox(height: 10),
SizedBox(
width: double.infinity,
height: 52,
child: FilledButton.icon(
onPressed: latestImage == null
? null
    : () {
Navigator.of(context).push(
MaterialPageRoute(
builder: (_) => ComparePage(
beforeImage: widget.originalImage,
afterImage: latestImage!,
),
),
);
},
icon: const Icon(Icons.compare_arrows),
label: const Text('Compare before & after'),
style: FilledButton.styleFrom(
backgroundColor: forest,
foregroundColor: Colors.white,
disabledBackgroundColor: const Color(0xFFD9DED9),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
),
),
const SizedBox(height: 8),
Center(
child: TextButton.icon(
onPressed: _chooseLatestImage,
icon: const Icon(
Icons.add_photo_alternate_outlined,
),
label: Text(
latestImage == null
? 'Add a result image for comparison'
    : 'Change result image',
),
),
),
],
),
),
),
);
}
}

class RoomCustomizerPage extends StatefulWidget {
final File imageFile;
const RoomCustomizerPage({super.key, required this.imageFile});

@override
State<RoomCustomizerPage> createState() => _RoomCustomizerPageState();
}

class _RoomCustomizerPageState extends State<RoomCustomizerPage> {
final GlobalKey _imageKey = GlobalKey();
final TransformationController _zoomController = TransformationController();
String _selectedPart = 'Wall';
Color _selectedColor = const Color(0xFFB7D7A8);
String? _selectedItem;
int? _selectedPlacedIndex;
final List<_RoomOverlayItem> _addedItems = [];
final List<_RoomOverlayItem> _removedItems = [];

final List<Color> _colors = const [
Color(0xFFF4F0E6), Color(0xFFE6C9A8), Color(0xFFD8B4A0),
Color(0xFFB7D7A8), Color(0xFF7FA58A), Color(0xFF254D3A),
Color(0xFFB8C9DD), Color(0xFF7D91B5), Color(0xFFD7B9D8),
Color(0xFFE7B6A2), Color(0xFF5B5B5B), Color(0xFF303030),
];

final Map<String, List<_RoomOption>> _options = const {
'Wall': [
_RoomOption('Solid paint', Icons.format_paint_outlined),
_RoomOption('Warm neutral', Icons.palette_outlined),
_RoomOption('Pastel', Icons.color_lens_outlined),
_RoomOption('Accent wall', Icons.wallpaper_outlined),
],
'Floor': [
_RoomOption('Wood', Icons.grid_on_outlined),
_RoomOption('Marble', Icons.texture_outlined),
_RoomOption('Tile', Icons.dashboard_outlined),
_RoomOption('Carpet', Icons.layers_outlined),
],
'Furniture': [
_RoomOption('Sofa', Icons.weekend_outlined),
_RoomOption('Chair', Icons.chair_outlined),
_RoomOption('Table', Icons.table_restaurant_outlined),
_RoomOption('Bed', Icons.bed_outlined),
_RoomOption('Cabinet', Icons.kitchen_outlined),
],
'Decor': [
_RoomOption('Plant', Icons.local_florist_outlined),
_RoomOption('Painting', Icons.image_outlined),
_RoomOption('Lamp', Icons.light_outlined),
_RoomOption('Vase', Icons.emoji_objects_outlined),
_RoomOption('Curtains', Icons.curtains_outlined),
_RoomOption('Rug', Icons.crop_square_rounded),
],
};

void _selectPart(String part) {
setState(() {
_selectedPart = part;
_selectedItem = null;
_selectedPlacedIndex = null;
});
}

void _addItem(Offset point, Size size) {
if (_selectedPart != 'Furniture' && _selectedPart != 'Decor') return;
if (_selectedItem == null) {
_showMessage(context, 'Choose an item below, then tap the room to place it.');
return;
}
setState(() {
_removedItems.clear();
_addedItems.add(_RoomOverlayItem(
name: _selectedItem!,
part: _selectedPart,
color: _selectedColor,
position: Offset(
(point.dx / size.width).clamp(0.0, 1.0),
(point.dy / size.height).clamp(0.0, 1.0),
),
));
_selectedPlacedIndex = _addedItems.length - 1;
});
}

void _moveItem(int index, Offset delta, Size size) {
if (index < 0 || index >= _addedItems.length) return;
final item = _addedItems[index];
setState(() {
_addedItems[index] = item.copyWith(
position: Offset(
(item.position.dx + delta.dx / size.width).clamp(0.0, 1.0),
(item.position.dy + delta.dy / size.height).clamp(0.0, 1.0),
),
);
_selectedPlacedIndex = index;
});
}

void _resizeItem(int index, double delta) {
if (index < 0 || index >= _addedItems.length) return;
final item = _addedItems[index];
setState(() {
_addedItems[index] = item.copyWith(
scale: (item.scale + delta / 100).clamp(.45, 3.0),
);
_selectedPlacedIndex = index;
});
}

void _deleteSelectedItem() {
final index = _selectedPlacedIndex;
if (index == null || index >= _addedItems.length) return;
setState(() {
_removedItems.add(_addedItems.removeAt(index));
_selectedPlacedIndex = null;
});
}

Future<void> _finish() async {
try {
setState(() => _selectedPlacedIndex = null);
await WidgetsBinding.instance.endOfFrame;
final boundary = _imageKey.currentContext?.findRenderObject()
as RenderRepaintBoundary?;
if (boundary == null) throw Exception('Could not capture the edited image.');
final image = await boundary.toImage(pixelRatio: 2);
final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
image.dispose();
if (byteData == null) throw Exception('Could not export the edited image.');
final file = File(
'${Directory.systemTemp.path}/archinest_${DateTime.now().millisecondsSinceEpoch}.png',
);
await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
if (mounted) Navigator.of(context).pop(file);
} catch (error) {
if (mounted) {
_showMessage(context, error.toString().replaceFirst('Exception: ', ''));
}
}
}

@override
void dispose() {
_zoomController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
final isPlacementMode = _selectedPart == 'Furniture' || _selectedPart == 'Decor';
final options = _options[_selectedPart] ?? const <_RoomOption>[];
final selected = _selectedPlacedIndex == null ||
_selectedPlacedIndex! >= _addedItems.length
? null
    : _addedItems[_selectedPlacedIndex!];

return Scaffold(
appBar: AppBar(
title: const Text('Customize your room',
style: TextStyle(fontWeight: FontWeight.bold)),
actions: [
IconButton(
tooltip: 'Zoom to fit',
onPressed: () => _zoomController.value = Matrix4.identity(),
icon: const Icon(Icons.fit_screen_outlined),
),
IconButton(
tooltip: 'Undo',
onPressed: _addedItems.isEmpty ? null : () => setState(() {
_removedItems.add(_addedItems.removeLast());
_selectedPlacedIndex = null;
}),
icon: const Icon(Icons.undo),
),
IconButton(
tooltip: 'Redo',
onPressed: _removedItems.isEmpty ? null : () => setState(() {
_addedItems.add(_removedItems.removeLast());
_selectedPlacedIndex = _addedItems.length - 1;
}),
icon: const Icon(Icons.redo),
),
],
),
body: SafeArea(
child: Column(
children: [
Padding(
padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
child: Row(children: const [
Icon(Icons.touch_app, color: forest, size: 19),
SizedBox(width: 8),
Expanded(
child: Text(
'Pinch to zoom • Drag an item to move • Drag a corner to resize',
style: TextStyle(color: muted, fontSize: 12),
),
),
]),
),
Expanded(
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 12),
child: LayoutBuilder(builder: (context, constraints) {
final size = constraints.biggest;
return RepaintBoundary(
key: _imageKey,
child: ClipRect(
child: InteractiveViewer(
transformationController: _zoomController,
minScale: 1,
maxScale: 4,
boundaryMargin: const EdgeInsets.all(120),
child: SizedBox(
width: size.width,
height: size.height,
child: Stack(
fit: StackFit.expand,
children: [
GestureDetector(
behavior: HitTestBehavior.opaque,
onTapDown: (details) {
final point = details.localPosition;
int? hit;
for (var i = _addedItems.length - 1; i >= 0; i--) {
final item = _addedItems[i];
final center = Offset(
item.position.dx * size.width,
item.position.dy * size.height,
);
if ((point.dx - center.dx).abs() <= 48 * item.scale &&
(point.dy - center.dy).abs() <= 40 * item.scale) {
hit = i;
break;
}
}
setState(() {
if (hit != null) {
_selectedPlacedIndex = hit;
} else {
_selectedPlacedIndex = null;
_addItem(point, size);
}
});
},
child: Image.file(widget.imageFile, fit: BoxFit.contain),
),
for (int index = 0; index < _addedItems.length; index++)
_EditorItem(
key: ValueKey('room-item-$index'),
item: _addedItems[index],
canvasSize: size,
selected: _selectedPlacedIndex == index,
onSelect: () => setState(() => _selectedPlacedIndex = index),
onMove: (delta) => _moveItem(index, delta, size),
onResize: (delta) => _resizeItem(index, delta),
onDelete: () {
setState(() => _selectedPlacedIndex = index);
_deleteSelectedItem();
},
),
],
),
),
),
),
);
}),
),
),
Container(
padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
decoration: const BoxDecoration(
color: canvas,
border: Border(top: BorderSide(color: line)),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisSize: MainAxisSize.min,
children: [
SingleChildScrollView(
scrollDirection: Axis.horizontal,
child: Row(
children: ['Wall', 'Floor', 'Furniture', 'Decor']
    .map((part) => Padding(
padding: const EdgeInsets.only(right: 7),
child: ChoiceChip(
label: Text(part),
selected: _selectedPart == part,
selectedColor: const Color(0xFFDDE9DF),
onSelected: (_) => _selectPart(part),
),
))
    .toList(),
),
),
const SizedBox(height: 8),
Text(
isPlacementMode ? '$_selectedPart options' : '$_selectedPart color and finish',
style: const TextStyle(fontWeight: FontWeight.w600, color: ink),
),
const SizedBox(height: 7),
if (isPlacementMode)
SizedBox(
height: 86,
child: ListView.separated(
scrollDirection: Axis.horizontal,
itemCount: options.length,
separatorBuilder: (_, __) => const SizedBox(width: 8),
itemBuilder: (context, index) {
final option = options[index];
final isChosen = _selectedItem == option.name;
return InkWell(
borderRadius: BorderRadius.circular(12),
onTap: () => setState(() {
_selectedItem = option.name;
_selectedColor = const Color(0xFFB7A18D);
_selectedPlacedIndex = null;
}),
child: Container(
width: 82,
padding: const EdgeInsets.all(5),
decoration: BoxDecoration(
color: isChosen ? const Color(0xFFDDE9DF) : Colors.white,
borderRadius: BorderRadius.circular(12),
border: Border.all(color: isChosen ? forest : line, width: isChosen ? 2 : 1),
),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
SizedBox(
height: 51,
width: 70,
child: CustomPaint(
painter: _FurniturePainter(name: option.name, color: _selectedColor),
),
),
Text(option.name, maxLines: 1, overflow: TextOverflow.ellipsis,
style: const TextStyle(fontSize: 10)),
],
),
),
);
},
),
)
else ...[
Wrap(
spacing: 10,
runSpacing: 8,
children: _colors.map((color) => GestureDetector(
onTap: () => setState(() => _selectedColor = color),
child: Container(
width: 29,
height: 29,
decoration: BoxDecoration(
color: color,
shape: BoxShape.circle,
border: Border.all(color: _selectedColor == color ? forest : line,
width: _selectedColor == color ? 3 : 1),
),
),
)).toList(),
),
const SizedBox(height: 5),
Wrap(
spacing: 7,
children: options.map((option) => ActionChip(
avatar: Icon(option.icon, size: 16, color: forest),
label: Text(option.name, style: const TextStyle(fontSize: 11)),
onPressed: () => setState(() => _selectedItem = option.name),
)).toList(),
),
],
if (isPlacementMode && selected != null)
Padding(
padding: const EdgeInsets.only(top: 3),
child: Row(
children: [
Expanded(
child: Text('${selected.name} selected · pinch room to zoom',
style: const TextStyle(fontSize: 11, color: muted)),
),
IconButton(
tooltip: 'Delete selected item',
visualDensity: VisualDensity.compact,
onPressed: _deleteSelectedItem,
icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
),
],
),
)
else if (isPlacementMode && _selectedItem != null)
Padding(
padding: const EdgeInsets.only(top: 4),
child: Text('Selected: $_selectedItem • tap the room to place it',
style: const TextStyle(fontSize: 11, color: muted)),
),
const SizedBox(height: 8),
SizedBox(
width: double.infinity,
height: 46,
child: FilledButton.icon(
onPressed: _finish,
icon: const Icon(Icons.check),
label: const Text('Apply design'),
style: FilledButton.styleFrom(
backgroundColor: forest,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
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

class _EditorItem extends StatelessWidget {
final _RoomOverlayItem item;
final Size canvasSize;
final bool selected;
final VoidCallback onSelect;
final ValueChanged<Offset> onMove;
final ValueChanged<double> onResize;
final VoidCallback onDelete;

const _EditorItem({
super.key,
required this.item,
required this.canvasSize,
required this.selected,
required this.onSelect,
required this.onMove,
required this.onResize,
required this.onDelete,
});

@override
Widget build(BuildContext context) {
final w = 88.0 * item.scale;
final h = 70.0 * item.scale;
return Positioned(
left: item.position.dx * canvasSize.width - w / 2 - 12,
top: item.position.dy * canvasSize.height - h / 2 - 12,
child: GestureDetector(
behavior: HitTestBehavior.translucent,
onTap: onSelect,
onPanStart: (_) => onSelect(),
onPanUpdate: (details) => onMove(details.delta),
child: SizedBox(
width: w + 24,
height: h + 24,
child: Stack(
clipBehavior: Clip.none,
children: [
Positioned(
left: 12,
top: 12,
width: w,
height: h,
child: Container(
decoration: BoxDecoration(
border: selected
? Border.all(color: const Color(0xFF2F80ED), width: 1.5)
    : null,
),
child: CustomPaint(
painter: _FurniturePainter(name: item.name, color: item.color),
),
),
),
if (selected) ...[
Positioned(
right: -1,
top: -1,
child: GestureDetector(
onTap: onDelete,
child: Container(
width: 25,
height: 25,
decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
child: const Icon(Icons.close, color: Colors.white, size: 16),
),
),
),
Positioned(
right: -2,
bottom: -2,
child: GestureDetector(
onPanUpdate: (details) => onResize(details.delta.dx + details.delta.dy),
child: Container(
width: 22,
height: 22,
decoration: BoxDecoration(
color: Colors.white,
border: Border.all(color: const Color(0xFF2F80ED), width: 2),
borderRadius: BorderRadius.circular(4),
),
child: const Icon(Icons.open_in_full, size: 12, color: Color(0xFF2F80ED)),
),
),
),
Positioned(
left: -2,
bottom: -2,
child: GestureDetector(
onPanUpdate: (details) => onResize(-details.delta.dx - details.delta.dy),
child: Container(
width: 22,
height: 22,
decoration: BoxDecoration(
color: Colors.white,
border: Border.all(color: const Color(0xFF2F80ED), width: 2),
borderRadius: BorderRadius.circular(4),
),
child: const Icon(Icons.open_in_full, size: 12, color: Color(0xFF2F80ED)),
),
),
),
],
],
),
),
),
);
}
}

class _RoomOption {
final String name;
final IconData icon;
const _RoomOption(this.name, this.icon);
}

class _RoomOverlayItem {
final String name;
final String part;
final Color color;
final Offset position;
final double scale;

const _RoomOverlayItem({
required this.name,
required this.part,
required this.color,
required this.position,
this.scale = 1.0,
});

_RoomOverlayItem copyWith({Offset? position, double? scale, Color? color}) =>
_RoomOverlayItem(
name: name,
part: part,
color: color ?? this.color,
position: position ?? this.position,
scale: scale ?? this.scale,
);
}

class _PlacedRoomItem extends StatelessWidget {
final _RoomOverlayItem item;
final bool selected;
const _PlacedRoomItem({super.key, required this.item, this.selected = false});

@override
Widget build(BuildContext context) {
return Container(
width: 88 * item.scale,
height: 70 * item.scale,
padding: const EdgeInsets.all(2),
decoration: BoxDecoration(
border: selected
? Border.all(color: forest, width: 2)
    : Border.all(color: Colors.transparent),
borderRadius: BorderRadius.circular(8),
),
child: CustomPaint(
painter: _FurniturePainter(name: item.name, color: item.color),
),
);
}
}

class _FurniturePainter extends CustomPainter {
final String name;
final Color color;
_FurniturePainter({required this.name, required this.color});

@override
void paint(Canvas canvas, Size size) {
final sx = size.width / 100;
final sy = size.height / 80;
canvas.save();
canvas.scale(sx, sy);
final dark = Color.lerp(color, Colors.black, .25)!;
final light = Color.lerp(color, Colors.white, .22)!;
final wood = const Color(0xFF9A6845);
final edge = Paint()..color = const Color(0xFF4B4037)..style = PaintingStyle.stroke..strokeWidth = 2.2..strokeJoin = StrokeJoin.round;
final fill = Paint()..color = color;
final shade = Paint()..color = dark;
final highlight = Paint()..color = light;
final legs = Paint()..color = const Color(0xFF654A37)..strokeWidth = 4..strokeCap = StrokeCap.round;
final shadow = Paint()..color = Colors.black.withOpacity(.12);
canvas.drawOval(const Rect.fromLTWH(15, 65, 70, 8), shadow);

switch (name) {
case 'Sofa':
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(12, 26, 76, 36), const Radius.circular(9)), shade);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(17, 20, 66, 35), const Radius.circular(8)), fill);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(5, 35, 18, 27), const Radius.circular(6)), highlight);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(77, 35, 18, 27), const Radius.circular(6)), highlight);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(23, 27, 24, 21), const Radius.circular(5)), highlight);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(51, 27, 24, 21), const Radius.circular(5)), highlight);
canvas.drawLine(const Offset(20, 61), const Offset(18, 70), legs);
canvas.drawLine(const Offset(80, 61), const Offset(82, 70), legs);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(5, 35, 90, 27), const Radius.circular(7)), edge);
break;
case 'Chair':
canvas.drawLine(const Offset(29, 43), const Offset(26, 69), legs);
canvas.drawLine(const Offset(70, 43), const Offset(74, 69), legs);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(26, 34, 48, 24), const Radius.circular(6)), fill);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(27, 12, 46, 30), const Radius.circular(7)), shade);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(31, 16, 38, 24), const Radius.circular(5)), highlight);
canvas.drawLine(const Offset(26, 40), const Offset(26, 68), legs);
canvas.drawLine(const Offset(74, 40), const Offset(74, 68), legs);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(26, 34, 48, 24), const Radius.circular(6)), edge);
break;
case 'Table':
canvas.drawLine(const Offset(28, 35), const Offset(25, 68), legs);
canvas.drawLine(const Offset(72, 35), const Offset(75, 68), legs);
canvas.drawLine(const Offset(38, 39), const Offset(36, 68), legs);
canvas.drawLine(const Offset(62, 39), const Offset(64, 68), legs);
final top = Path()..moveTo(12, 27)..lineTo(27, 19)..lineTo(89, 25)..lineTo(73, 34)..close();
canvas.drawPath(top, Paint()..color = wood);
canvas.drawPath(top, edge);
canvas.drawLine(const Offset(27, 23), const Offset(75, 28), Paint()..color = const Color(0xFFC18B61)..strokeWidth = 2);
break;
case 'Bed':
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(12, 15, 76, 49), const Radius.circular(5)), shade);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(17, 22, 66, 39), const Radius.circular(4)), fill);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(20, 25, 27, 16), const Radius.circular(4)), highlight);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(53, 25, 27, 16), const Radius.circular(4)), highlight);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(17, 42, 66, 17), const Radius.circular(3)), Paint()..color = const Color(0xFFE9E3D8));
canvas.drawLine(const Offset(15, 60), const Offset(15, 70), legs);
canvas.drawLine(const Offset(85, 60), const Offset(85, 70), legs);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(12, 15, 76, 49), const Radius.circular(5)), edge);
break;
case 'Cabinet':
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(23, 10, 54, 54), const Radius.circular(3)), fill);
canvas.drawRect(const Rect.fromLTWH(27, 15, 46, 44), highlight);
canvas.drawLine(const Offset(50, 15), const Offset(50, 59), edge);
canvas.drawCircle(const Offset(46, 37), 1.8, Paint()..color = dark);
canvas.drawCircle(const Offset(54, 37), 1.8, Paint()..color = dark);
canvas.drawLine(const Offset(29, 65), const Offset(29, 71), legs);
canvas.drawLine(const Offset(71, 65), const Offset(71, 71), legs);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(23, 10, 54, 54), const Radius.circular(3)), edge);
break;
case 'Plant':
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(35, 51, 30, 17), const Radius.circular(3)), Paint()..color = const Color(0xFFB66E4E));
canvas.drawLine(const Offset(50, 53), const Offset(50, 20), Paint()..color = const Color(0xFF477A4C)..strokeWidth = 3);
for (final leaf in [
const Rect.fromLTWH(24, 17, 27, 12), const Rect.fromLTWH(49, 11, 28, 13),
const Rect.fromLTWH(19, 31, 31, 12), const Rect.fromLTWH(49, 28, 31, 12),
]) {
canvas.drawOval(leaf, Paint()..color = const Color(0xFF548B58));
}
canvas.drawOval(const Rect.fromLTWH(24, 17, 27, 12), edge);
break;
case 'Painting':
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(17, 9, 66, 54), const Radius.circular(3)), Paint()..color = wood);
canvas.drawRect(const Rect.fromLTWH(22, 14, 56, 44), Paint()..color = const Color(0xFFE7E2D6));
canvas.drawCircle(const Offset(61, 27), 8, Paint()..color = const Color(0xFFD9A85D));
final hill = Path()..moveTo(22, 53)..lineTo(39, 33)..lineTo(49, 43)..lineTo(61, 34)..lineTo(78, 52)..close();
canvas.drawPath(hill, Paint()..color = const Color(0xFF789B78));
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(17, 9, 66, 54), const Radius.circular(3)), edge);
break;
case 'Lamp':
canvas.drawLine(const Offset(50, 29), const Offset(50, 64), Paint()..color = const Color(0xFF77736B)..strokeWidth = 4);
canvas.drawOval(const Rect.fromLTWH(35, 61, 30, 7), Paint()..color = const Color(0xFF77736B));
final shadePath = Path()..moveTo(32, 30)..lineTo(41, 11)..lineTo(59, 11)..lineTo(68, 30)..close();
canvas.drawPath(shadePath, Paint()..color = const Color(0xFFE9C98A));
canvas.drawPath(shadePath, edge);
break;
case 'Vase':
final vase = Path()..moveTo(43, 17)..lineTo(57, 17)..lineTo(56, 30)..quadraticBezierTo(75, 47, 63, 65)..lineTo(37, 65)..quadraticBezierTo(25, 47, 44, 30)..close();
canvas.drawPath(vase, Paint()..color = color);
canvas.drawPath(vase, edge);
canvas.drawLine(const Offset(50, 17), const Offset(50, 5), Paint()..color = const Color(0xFF548B58)..strokeWidth = 2);
canvas.drawOval(const Rect.fromLTWH(42, 5, 12, 7), Paint()..color = const Color(0xFF548B58));
break;
case 'Curtains':
canvas.drawLine(const Offset(17, 12), const Offset(83, 12), Paint()..color = const Color(0xFF77736B)..strokeWidth = 3);
final curtain = Paint()..color = color;
canvas.drawPath(Path()..moveTo(20, 15)..lineTo(44, 15)..lineTo(40, 62)..lineTo(20, 57)..close(), curtain);
canvas.drawPath(Path()..moveTo(56, 15)..lineTo(80, 15)..lineTo(80, 57)..lineTo(60, 62)..close(), curtain);
canvas.drawLine(const Offset(20, 15), const Offset(20, 57), edge);
canvas.drawLine(const Offset(80, 15), const Offset(80, 57), edge);
break;
case 'Rug':
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(12, 21, 76, 42), const Radius.circular(12)), Paint()..color = color);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(19, 27, 62, 30), const Radius.circular(8)), Paint()..color = Colors.white.withOpacity(.15)..style = PaintingStyle.stroke..strokeWidth = 2);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(12, 21, 76, 42), const Radius.circular(12)), edge);
break;
default:
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(20, 18, 60, 45), const Radius.circular(8)), fill);
canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(20, 18, 60, 45), const Radius.circular(8)), edge);
}
canvas.restore();
}

@override
bool shouldRepaint(covariant _FurniturePainter oldDelegate) =>
oldDelegate.name != name || oldDelegate.color != color;
}

class ComparePage extends StatefulWidget {
final File beforeImage;
final File afterImage;

const ComparePage({
super.key,
required this.beforeImage,
required this.afterImage,
});

@override
State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
double position = .5;

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
'Before & after',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),
body: SafeArea(
child: Padding(
padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Compare your room',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: ink,
),
),
const SizedBox(height: 6),
const Text(
'Drag the divider to reveal the original and latest design.',
style: TextStyle(
color: muted,
fontSize: 12,
),
),
const SizedBox(height: 18),
Expanded(
child: LayoutBuilder(
builder: (context, constraints) {
return GestureDetector(
onHorizontalDragUpdate: (details) {
setState(() {
position = (position +
details.delta.dx /
constraints.maxWidth)
    .clamp(0.0, 1.0);
});
},
onTapDown: (details) {
setState(() {
position = (details.localPosition.dx /
constraints.maxWidth)
    .clamp(0.0, 1.0);
});
},
child: ClipRRect(
borderRadius: BorderRadius.circular(20),
child: Stack(
fit: StackFit.expand,
children: [
Image.file(
widget.afterImage,
fit: BoxFit.cover,
),
ClipRect(
child: Align(
alignment: Alignment.centerLeft,
widthFactor: position,
child: SizedBox(
width: constraints.maxWidth,
height: constraints.maxHeight,
child: Image.file(
widget.beforeImage,
fit: BoxFit.cover,
),
),
),
),
Positioned(
left: 12,
top: 12,
child: _CompareTag(text: 'BEFORE'),
),
Positioned(
right: 12,
top: 12,
child: _CompareTag(text: 'AFTER'),
),
Positioned(
left: constraints.maxWidth * position - 1,
top: 0,
bottom: 0,
child: Container(
width: 2,
color: Colors.white,
),
),
Positioned(
left: (constraints.maxWidth * position - 21)
    .clamp(
0.0,
constraints.maxWidth - 42,
),
top: constraints.maxHeight / 2 - 21,
child: Container(
width: 42,
height: 42,
decoration: BoxDecoration(
color: Colors.white,
shape: BoxShape.circle,
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(.18),
blurRadius: 8,
),
],
),
child: const Icon(
Icons.compare_arrows,
color: forest,
),
),
),
],
),
),
);
},
),
),
const SizedBox(height: 14),
Row(
children: [
const Text(
'BEFORE',
style: TextStyle(
fontSize: 10,
fontWeight: FontWeight.bold,
color: muted,
letterSpacing: .8,
),
),
Expanded(
child: Slider(
value: position,
onChanged: (value) {
setState(() {
position = value;
});
},
activeColor: forest,
inactiveColor: const Color(0xFFD8DED8),
),
),
const Text(
'AFTER',
style: TextStyle(
fontSize: 10,
fontWeight: FontWeight.bold,
color: muted,
letterSpacing: .8,
),
),
],
),
const Text(
'Note: Use an AI-generated image for the “after” photo. The current app uses a selected image to test the comparison UI.',
style: TextStyle(
color: muted,
fontSize: 11,
height: 1.4,
),
),
],
),
),
),
);
}
}

class _CompareTag extends StatelessWidget {
final String text;

const _CompareTag({
required this.text,
});

@override
Widget build(BuildContext context) => Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 6,
),
decoration: BoxDecoration(
color: Colors.white.withOpacity(.92),
borderRadius: BorderRadius.circular(30),
),
child: Text(
text,
style: const TextStyle(
fontSize: 10,
fontWeight: FontWeight.bold,
color: forest,
letterSpacing: .6,
),
),
);
}

class ProjectsPage extends StatefulWidget {
const ProjectsPage({super.key});

@override
State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
bool _loading = true;
String? _error;
List<Map<String, dynamic>> _projects = [];

@override
void initState() {
super.initState();
_loadProjects();
}

Future<void> _loadProjects() async {
if (mounted) {
setState(() {
_loading = true;
_error = null;
});
}
try {
final projects = await ProjectService.getProjects();
if (!mounted) return;
setState(() {
_projects = projects;
_loading = false;
});
} catch (e) {
if (!mounted) return;
setState(() {
_error = e.toString().replaceFirst('Exception: ', '');
_loading = false;
});
}
}

Future<void> _deleteProject(Map<String, dynamic> project) async {
final id = (project['_id'] ?? project['id'] ?? '').toString();
if (id.isEmpty) {
_showMessage('This project has no valid ID.');
return;
}
final confirm = await showDialog<bool>(
context: context,
builder: (context) => AlertDialog(
title: const Text('Delete project?'),
content: const Text('This project will be removed from your account.'),
actions: [
TextButton(
onPressed: () => Navigator.pop(context, false),
child: const Text('Cancel'),
),
FilledButton(
onPressed: () => Navigator.pop(context, true),
style: FilledButton.styleFrom(backgroundColor: forest),
child: const Text('Delete'),
),
],
),
);
if (confirm != true) return;
try {
await ProjectService.deleteProject(id);
await _loadProjects();
if (mounted) _showMessage('Project deleted.');
} catch (e) {
if (mounted) _showMessage(e.toString().replaceFirst('Exception: ', ''));
}
}

void _showMessage(String message) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text(message)),
);
}

@override
Widget build(BuildContext context) {
return SafeArea(
child: RefreshIndicator(
color: forest,
onRefresh: _loadProjects,
child: ListView(
padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
children: [
const Text(
'My Projects',
style: TextStyle(
fontSize: 27,
fontWeight: FontWeight.bold,
color: ink,
),
),
const SizedBox(height: 7),
const Text(
'Your saved room designs and previous projects.',
style: TextStyle(color: muted, fontSize: 13),
),
const SizedBox(height: 22),
if (_loading)
const Padding(
padding: EdgeInsets.only(top: 90),
child: Center(child: CircularProgressIndicator(color: forest)),
)
else if (_error != null)
_ProjectsMessage(
icon: Icons.cloud_off_outlined,
title: 'Could not load projects',
message: _error!,
buttonText: 'Try again',
onPressed: _loadProjects,
)
else if (_projects.isEmpty)
_ProjectsMessage(
icon: Icons.folder_open_outlined,
title: 'No projects yet',
message: 'Create a design and save it to see it here.',
buttonText: 'Refresh',
onPressed: _loadProjects,
)
else ...[
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
'${_projects.length} ${_projects.length == 1 ? 'project' : 'projects'}',
style: const TextStyle(
color: muted,
fontWeight: FontWeight.w600,
),
),
IconButton(
onPressed: _loadProjects,
tooltip: 'Refresh',
icon: const Icon(Icons.refresh, color: forest),
),
],
),
const SizedBox(height: 8),
..._projects.map((project) {
final name = (project['projectName'] ?? 'Untitled project').toString();
final room = (project['roomType'] ?? 'Room').toString();
final status = (project['status'] ?? 'Planning').toString();
final description = (project['description'] ?? '').toString();
final imagePath = (project['originalImage'] ?? '').toString();
return Container(
margin: const EdgeInsets.only(bottom: 13),
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(18),
border: Border.all(color: line),
),
child: Row(
children: [
Container(
width: 74,
height: 82,
decoration: BoxDecoration(
color: const Color(0xFFE3EBE4),
borderRadius: BorderRadius.circular(13),
),
clipBehavior: Clip.antiAlias,
child: imagePath.startsWith('http')
? Image.network(
imagePath,
fit: BoxFit.cover,
errorBuilder: (_, __, ___) => const Icon(
Icons.weekend_outlined,
color: forest,
size: 30,
),
)
    : const Icon(
Icons.weekend_outlined,
color: forest,
size: 30,
),
),
const SizedBox(width: 13),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
name,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
color: ink,
fontSize: 15,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 4),
Text(room, style: const TextStyle(color: muted, fontSize: 12)),
if (description.isNotEmpty) ...[
const SizedBox(height: 4),
Text(
description,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(color: muted, fontSize: 11),
),
],
const SizedBox(height: 7),
Container(
padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
decoration: BoxDecoration(
color: const Color(0xFFE3EBE4),
borderRadius: BorderRadius.circular(20),
),
child: Text(
status,
style: const TextStyle(
color: forest,
fontSize: 10,
fontWeight: FontWeight.w600,
),
),
),
],
),
),
IconButton(
tooltip: 'Delete project',
onPressed: () => _deleteProject(project),
icon: const Icon(Icons.delete_outline, color: muted),
),
],
),
);
}),
],
],
),
),
);
}
}

class _ProjectsMessage extends StatelessWidget {
final IconData icon;
final String title;
final String message;
final String buttonText;
final VoidCallback onPressed;

const _ProjectsMessage({
required this.icon,
required this.title,
required this.message,
required this.buttonText,
required this.onPressed,
});

@override
Widget build(BuildContext context) => Padding(
padding: const EdgeInsets.only(top: 65),
child: Column(
children: [
Icon(icon, size: 54, color: forest),
const SizedBox(height: 15),
Text(
title,
style: const TextStyle(
color: ink,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 7),
Text(
message,
textAlign: TextAlign.center,
style: const TextStyle(color: muted, fontSize: 12, height: 1.5),
),
const SizedBox(height: 16),
OutlinedButton(
onPressed: onPressed,
child: Text(buttonText),
),
],
),
);
}

class FavoritesPage extends StatelessWidget {
const FavoritesPage({super.key});

@override
Widget build(BuildContext context) {
return const _PlaceholderPage(
icon: Icons.favorite_border,
title: 'Favorites',
description:
'Save your favorite interior designs and find them here.',
);
}
}

class ProfilePage extends StatefulWidget {
const ProfilePage({super.key});

@override
State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
bool _isLoading = true;
bool _isLoggedIn = false;
String _userName = '';
String _userEmail = '';

@override
void initState() {
super.initState();
_loadUser();
}

Future<void> _loadUser() async {
final loggedIn = await AuthService.isLoggedIn();
final name = await AuthService.getUserName();
final email = await AuthService.getUserEmail();

if (!mounted) return;
setState(() {
_isLoggedIn = loggedIn;
_userName = name ?? '';
_userEmail = email ?? '';
_isLoading = false;
});
}

Future<void> _openLogin() async {
await Navigator.push<bool>(
context,
MaterialPageRoute(builder: (context) => const LoginScreen()),
);
await _loadUser();
}

Future<void> _openRegister() async {
await Navigator.push<void>(
context,
MaterialPageRoute(builder: (context) => const RegisterScreen()),
);
await _loadUser();
}

Future<void> _logout() async {
await AuthService.logout();
if (!mounted) return;
setState(() {
_isLoggedIn = false;
_userName = '';
_userEmail = '';
});
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('You have logged out successfully.'),
backgroundColor: forest,
),
);
}

@override
Widget build(BuildContext context) {
return SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'My Profile',
style: TextStyle(
fontSize: 27,
fontWeight: FontWeight.bold,
color: ink,
),
),
const SizedBox(height: 8),
const Text(
'Manage your ArchiNest account.',
style: TextStyle(color: muted, fontSize: 14),
),
const SizedBox(height: 28),
Container(
width: double.infinity,
padding: const EdgeInsets.all(22),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
border: Border.all(color: line),
),
child: _isLoading
? const Center(
child: CircularProgressIndicator(color: forest),
)
    : _isLoggedIn
? _buildLoggedInProfile()
    : _buildGuestProfile(),
),
],
),
),
);
}

Widget _buildGuestProfile() {
return Column(
children: [
const CircleAvatar(
radius: 38,
backgroundColor: Color(0xFFE3EBE4),
child: Icon(Icons.person, size: 42, color: forest),
),
const SizedBox(height: 14),
const Text(
'Welcome to ArchiNest',
style: TextStyle(
fontSize: 19,
fontWeight: FontWeight.bold,
color: ink,
),
),
const SizedBox(height: 6),
const Text(
'Create an account to get started.',
style: TextStyle(fontSize: 13, color: muted),
),
const SizedBox(height: 22),
SizedBox(
width: double.infinity,
height: 50,
child: FilledButton.icon(
onPressed: _openRegister,
icon: const Icon(Icons.person_add_alt_1),
label: const Text('Create an account'),
style: FilledButton.styleFrom(
backgroundColor: forest,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(13),
),
),
),
),
const SizedBox(height: 10),
SizedBox(
width: double.infinity,
height: 50,
child: OutlinedButton.icon(
onPressed: _openLogin,
icon: const Icon(Icons.login),
label: const Text('Log In'),
style: OutlinedButton.styleFrom(
foregroundColor: forest,
side: const BorderSide(color: forest),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(13),
),
),
),
),
],
);
}

Widget _buildLoggedInProfile() {
return Column(
children: [
const CircleAvatar(
radius: 38,
backgroundColor: Color(0xFFE3EBE4),
child: Icon(Icons.person, size: 42, color: forest),
),
const SizedBox(height: 14),
Text(
'Welcome, $_userName!',
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: ink,
),
),
const SizedBox(height: 8),
Text(
_userEmail,
textAlign: TextAlign.center,
style: const TextStyle(fontSize: 14, color: muted),
),
const SizedBox(height: 24),
SizedBox(
width: double.infinity,
height: 50,
child: FilledButton.icon(
onPressed: _logout,
icon: const Icon(Icons.logout),
label: const Text('Log Out'),
style: FilledButton.styleFrom(
backgroundColor: forest,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(13),
),
),
),
),
],
);
}
}

class _PlaceholderPage extends StatelessWidget {
final IconData icon;
final String title;
final String description;

const _PlaceholderPage({
required this.icon,
required this.title,
required this.description,
});

@override
Widget build(BuildContext context) => SafeArea(
child: Center(
child: Padding(
padding: const EdgeInsets.all(30),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Container(
height: 86,
width: 86,
decoration: BoxDecoration(
color: const Color(0xFFE3EBE4),
borderRadius: BorderRadius.circular(25),
),
child: Icon(
icon,
size: 42,
color: forest,
),
),
const SizedBox(height: 18),
Text(
title,
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: ink,
),
),
const SizedBox(height: 9),
Text(
description,
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 13,
color: muted,
height: 1.5,
),
),
],
),
),
),
);
}

