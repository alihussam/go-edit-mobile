import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goedit/blocs/create_new_asset_page_bloc.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/utils/field_validators.dart';
import 'package:goedit/utils/global_navigation.dart';
import 'package:image_picker/image_picker.dart';

class CreateNewAssetPage extends StatefulWidget {
  @override
  _CreateNewAssetPageState createState() => _CreateNewAssetPageState();
}

class _CreateNewAssetPageState extends State<CreateNewAssetPage>
    with FieldValidators {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  Asset _asset = new Asset(currency: 'PKR');

  @override
  void initState() {
    createNewAssetPageBloc.init(_key);
    super.initState();
  }

  @override
  void dispose() {
    createNewAssetPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // pick image from camera
    imageFromCamera() async {
      PickedFile image = (await _imagePicker.getImage(
          source: ImageSource.camera, imageQuality: 100));

      setState(() {
        if (image != null) {
          _asset.imageFile = new File(image.path);
        }
      });
    }

    imageFromGallery() async {
      PickedFile image = (await _imagePicker.getImage(
          source: ImageSource.gallery, imageQuality: 100));

      setState(() {
        if (image != null) {
          _asset.imageFile = new File(image.path);
        }
      });
    }

    // attach a listener to pop on success
    createNewAssetPageBloc.asset.listen((event) {
      // Timer(Duration(milliseconds: 500),
      //     () => GlobalNavigation.key.currentState.pop());
    });

    Future<bool> _willPopCallBack() async {
      return false;
    }

    Widget _buildPageHeader() {
      return Container(
          padding: EdgeInsets.all(40),
          child: Text(
            'Create New Asset',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ));
    }

    Widget _buildFormFields() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildFormField(
              labelText: 'Title',
              validator: (value) => validateRequired(value),
              onChanged: (value) => {_asset.title = value.trim()}),
          buildFormField(
              labelText: 'Description',
              maxLines: 5,
              validator: (value) => validateRequired(value),
              onChanged: (value) => {_asset.description = value.trim()}),
          buildNumericOnlyFormField(
              labelText: 'Price',
              validator: (value) => validateRequired(value),
              onChanged: (String value) =>
                  {_asset.price = double.parse(value.trim())}),
          DropdownButton(
              hint: Text('Currency'),
              icon: Icon(Icons.money),
              isExpanded: true,
              value: _asset.currency,
              items: ['PKR', 'USD']
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) => {
                    setState(() {
                      _asset.currency = value;
                    }),
                    createNewAssetPageBloc
                  }),
          Container(
            child: OutlineButton(
              onPressed: () => imageFromGallery(),
              child: _asset.imageFile == null
                  ? Container(
                      padding: EdgeInsets.all(35),
                      child: Center(
                        child: Text('+ Add Conver Image'),
                      ),
                    )
                  : Image.file(
                      _asset.imageFile,
                      fit: BoxFit.cover,
                      height: 200,
                    ),
            ),
          ),
          // buildFormField(
          //     labelText: 'createNewAssetPageBloc',
          //     validator: (value) => validateRequired(value),
          //     onChanged: (value) => {_asset.Asset = value.trim()}),
        ],
      );
    }

    Widget _buildActionButtonBar() {
      return Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          initialData: false,
          stream: createNewAssetPageBloc.isCreatingAsset,
          builder: (context, snapshot) {
            if (snapshot.data) {
              return LoadSpinner(
                size: 10,
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FlatButton(
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        createNewAssetPageBloc.createAsset(_asset);
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlineButton(
                    child: Text('Cancel',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        )),
                    onPressed: () => GlobalNavigation.key.currentState.pop(),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    return WillPopScope(
      onWillPop: _willPopCallBack,
      child: SafeArea(
        child: Scaffold(
          key: _key,
          bottomNavigationBar: Container(
            child: _buildActionButtonBar(),
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPageHeader(),
                    _buildFormFields(),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
