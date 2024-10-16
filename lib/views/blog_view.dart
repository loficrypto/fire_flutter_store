import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BlogView extends StatefulWidget {
  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _addPost() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image.')));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final imageName = _imageFile!.path.split('/').last;
      final storageRef = FirebaseStorage.instance.ref().child('blog/$imageName');
      await storageRef.putFile(_imageFile!);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('blogPosts').add({
        'title': _title,
        'content': _content,
        'imageUrl': imageUrl,
      });

      setState(() {
        _isLoading = false;
        _title = '';
        _content = '';
        _imageFile = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Blog post added successfully.')));
    }
  }

  Future<void> _deletePost(String id, String imageUrl) async {
    await FirebaseFirestore.instance.collection('blogPosts').doc(id).delete();
    await FirebaseStorage.instance.refFromURL(imageUrl).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      onSaved: (value) => _title = value!,
                      validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Content'),
                      maxLines: 5,
                      onSaved: (value) => _content = value!,
                      validator: (value) => value!.isEmpty ? 'Please enter content' : null,
                    ),
                    SizedBox(height: 10),
                    _imageFile == null
                        ? TextButton(
                            onPressed: _pickImage,
                            child: Text('Select Image'),
                          )
                        : Image.file(_imageFile!, height: 200, width: 200, fit: BoxFit.cover),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addPost,
                      child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Add Post'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('blogPosts').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((doc) {
                      return ListTile(
                        leading: Image.network(doc['imageUrl']),
                        title: Text(doc['title']),
                        subtitle: Text(doc['content']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deletePost(doc.id, doc['imageUrl']),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
