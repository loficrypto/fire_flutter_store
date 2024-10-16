import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminProductForm extends StatefulWidget {
  @override
  _AdminProductFormState createState() => _AdminProductFormState();
}

class _AdminProductFormState extends State<AdminProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  double _price = 0;
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image.')));
        return;
      }

      final imageName = _imageFile!.path.split('/').last;
      final storageRef = FirebaseStorage.instance.ref().child('products/$imageName');
      await storageRef.putFile(_imageFile!);
      final imageUrl = await storageRef.getDownloadURL();

      final productRef = FirebaseFirestore.instance.collection('products').doc();
      await productRef.set({
        'name': _name,
        'description': _description,
        'price': _price,
        'imageUrl': imageUrl,
        'productFile': imageName, // Assuming this will be used for download
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product added successfully.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Product Name'),
            onSaved: (value) => _name = value!,
            validator: (value) => value!.isEmpty ? 'Please enter a product name' : null,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Product Description'),
            onSaved: (value) => _description = value!,
            validator: (value) => value!.isEmpty ? 'Please enter a product description' : null,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Product Price'),
            keyboardType: TextInputType.number,
            onSaved: (value) => _price = double.parse(value!),
            validator: (value) => value!.isEmpty ? 'Please enter a product price' : null,
          ),
          SizedBox(height: 10),
          _imageFile == null
              ? TextButton(
                  onPressed: _pickImage,
                  child: Text('Select Product Image'),
                )
              : Image.file(_imageFile!, height: 200, width: 200, fit: BoxFit.cover),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _uploadProduct,
            child: Text('Add Product'),
          ),
        ],
      ),
    );
  }
}
