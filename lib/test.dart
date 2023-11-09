import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

void main() => runApp(contraventions());

class contraventions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload Example',
      home: ImageUploadScreen(),
    );
  }
}

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final String serverUrl = 'https://www.mycarapp.fr:8443/mca/contraventions/pictures'; // Replace with your server endpoint

  Future getImage() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    print(' image selection');
    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
        uploadImage;
      });
    }
  }

  Future uploadImage() async {
    if (_image == null) {
      print('No image selected');
      return;
    }

    print ("envoi image ok ");
    print (_image);

    var stream = http.ByteStream(DelegatingStream.typed(_image!.openRead()));
    var length = await _image!.length();
    var uri = Uri.parse(serverUrl);



    var request = http.MultipartRequest('POST', uri);
    var multipartFile = http.MultipartFile('file', stream, length, filename: basename(_image!.path));

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Image upload failed with status code ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Text(' image selected.'), //Image.file(_image!),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
