import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:wide/core/screens/all.dart';
import 'package:wide/feature/posts/view_model/post_model.dart';

List<PostModel> yourPostList = [];

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _imageFile;
  final TextEditingController textController = TextEditingController();

  void _savePost() {
    if (_imageFile == null || textController.text.isEmpty) {
      return;
    }

    String text = textController.text;
    String username = "YourUsernameHere"; // Set the username

    PostModel post =
        PostModel(text: text, imagePath: _imageFile!, username: username);

    setState(() {
      yourPostList.add(post);
    });
  }

  @override
  void initState() {
    super.initState();
    _pickImage(ImageSource.camera);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    textController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  final List<String> postItems = [
    "Boshqalar +",
    "Avtomobillar",
    "Ovqatlar",
    "Darslar",
    "Aksiyalar",
    "Darslar",
    "Kiyimlar",
    "IT",
    "Texnologiya"
  ];

  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 52,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: GestureDetector(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(currentIndex: 3),
                      ),
                    ),
                child: SvgPicture.asset(AppImages.returnIcon,
                    width: 22, height: 22))),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: () {
                _savePost();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(currentIndex: 3),
                  ),
                );
              },
              child: const Text(
                "Joylash",
                style: TextStyle(
                  color: AppColors.c1a73e8,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Color(0xFFEFEFEF)),
              ),
            ),
          ),
        ),
      ),
      body: _imageFile == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: screenHeight * 0.050),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: screenWidth * 0.016),
                      SizedBox(
                        width: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_imageFile!, scale: 4),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      SizedBox(
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.45,
                        child: TextField(
                          controller: textController,
                          expands: true,
                          minLines: null,
                          maxLines: null,
                          cursorColor: AppColors.c1a73e8,
                          decoration: const InputDecoration(
                            hintText: "Izoh qoldiring",
                            hintStyle: TextStyle(
                              color: AppColors.cfcfdf0,
                              fontSize: 14,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.cfcfdf0),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.c1a73e8),
                            ),
                          ),
                          style: const TextStyle(color: AppColors.c1c1c1c),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: screenHeight * 0.1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: postItems.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            isTapped = !isTapped;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          height: 40,
                          decoration: BoxDecoration(
                            color: postItems[index] == "Boshqalar +"
                                ? const Color(0xff1A73E8)
                                : AppColors.cefefef,
                            borderRadius: BorderRadius.circular(8),
                            border: isTapped
                                ? Border.all(
                                    width: 1, color: const Color(0xFF1A73E8))
                                : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 16,
                              right: 16,
                            ),
                            child: Text(
                              postItems[index],
                              style: TextStyle(
                                color: postItems[index] == "Boshqalar +"
                                    ? Colors.white
                                    : AppColors.c1c1c1c,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
    );
  }
}

class ImageViewScreen extends StatelessWidget {
  final File? imageFile;

  const ImageViewScreen({super.key, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image View')),
      body: Center(
        child: imageFile == null
            ? const Text('No image selected.')
            : Image.file(imageFile!),
      ),
    );
  }
}
