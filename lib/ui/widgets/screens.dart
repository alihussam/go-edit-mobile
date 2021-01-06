import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/inputs.dart';
import 'package:goedit/ui/widgets/inputs/boxed_solo_file_picker.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/utils/field_validators.dart';
import 'package:goedit/utils/global_navigation.dart';
import 'package:image_picker/image_picker.dart';

class FullWidthFormController {
  Function(String message) showToast;
  Function(bool isShowSuccess) changeCurrentScreen;
  Function(bool isLoading) switchIsLoading;
  bool Function() validateForm;
}

class FullWidthFormState {
  String title;
  String description;
  double price;
  String currency = 'PKR';
  File singleImage;
  File singleFile;
}

class FullWidthFormScreen extends StatefulWidget {
  @required
  final FullWidthFormController fullWidthFormController;
  final String headerTitle;
  final String successScreenMessage;
  final Function() onSuccessButtonPress;
  final String actionButtonOneText;
  final Function() onActionButtonOnePress;
  final String actionButtonTwoText;
  final Function() onActionButtonTwoPress;
  final Function(FullWidthFormState formState) onValueChange;

  FullWidthFormScreen({
    this.headerTitle = 'Form',
    this.fullWidthFormController,
    this.successScreenMessage = 'Success',
    this.onSuccessButtonPress,
    this.actionButtonOneText = 'Save',
    this.onActionButtonOnePress,
    this.actionButtonTwoText = 'Cancel',
    this.onActionButtonTwoPress,
    this.onValueChange,
  });
  @override
  _FullWidthFormScreenState createState() =>
      _FullWidthFormScreenState(fullWidthFormController);
}

class _FullWidthFormScreenState extends State<FullWidthFormScreen>
    with FieldValidators {
  _FullWidthFormScreenState(FullWidthFormController _controller) {
    _controller.showToast = showToast;
    _controller.changeCurrentScreen = changeCurrentScreen;
    _controller.switchIsLoading = switchIsLoading;
    _controller.validateForm = validateForm;
  }

  FullWidthFormState _formState = FullWidthFormState();

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  StreamController<bool> _currentScreenController = StreamController<bool>();
  StreamController<bool> _isLoadingController = StreamController<bool>();

  // show toast on form screen
  void showToast(String message) {
    _key.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  // switch between active screen, i.e form or success screen
  void changeCurrentScreen(bool isShowSuccess) {
    _currentScreenController.sink.add(isShowSuccess);
  }

  // switch between is screen loading
  void switchIsLoading(bool isLoading) {
    _isLoadingController.sink.add(isLoading);
  }

  // validate form
  bool validateForm() => _formKey.currentState.validate();

  // on single image input
  void onSingleImageInput(File image) {
    _formState.singleImage = image;
    widget.onValueChange(_formState);
  }

  // on single image input
  void onFileSelect(File image) {
    _formState.singleFile = image;
    widget.onValueChange(_formState);
  }

  @override
  void dispose() {
    _isLoadingController.close();
    _currentScreenController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildFormFields() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildFormField(
                  labelText: 'Title',
                  validator: (value) => validateRequired(value),
                  onChanged: (value) => {
                        _formState.title = value.trim(),
                        widget.onValueChange(_formState),
                      }),
              buildFormField(
                  labelText: 'Description',
                  maxLines: 5,
                  validator: (value) => validateRequired(value),
                  onChanged: (value) => {
                        _formState.description = value.trim(),
                        widget.onValueChange(_formState)
                      }),
              buildNumericOnlyFormField(
                  labelText: 'Price',
                  validator: (value) => validateRequired(value),
                  onChanged: (String value) => {
                        _formState.price = double.parse(
                            value.trim(), widget.onValueChange(_formState))
                      }),
              DropdownButton(
                  hint: Text('Currency'),
                  icon: Icon(Icons.money),
                  isExpanded: true,
                  value: _formState.currency,
                  items: ['PKR', 'USD']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) => {
                        setState(() {
                          _formState.currency = value;
                          widget.onValueChange(_formState);
                        }),
                      }),
              SingleImageInput(
                placeHolderText: '+ Add Cover image',
                onImageSelect: onSingleImageInput,
              ),
              // BoxedSoloFilePicker(
              //   placeHolderText: '+ Add resource',
              //   onFileSelect: onFileSelect,
              // ),
            ],
          ),
        ),
      );
    }

    // action button bar
    Widget _buildActionButtonBar() {
      return Container(
        height: 80,
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          initialData: false,
          stream: _isLoadingController.stream,
          builder: (context, snapshot) {
            if (snapshot.data) {
              return LoadSpinner(size: 10);
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FlatButton(
                    child: Text(widget.actionButtonOneText,
                        style: TextStyle(color: Colors.white)),
                    color: Theme.of(context).primaryColor,
                    onPressed: widget.onActionButtonOnePress,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlineButton(
                    child: Text(widget.actionButtonTwoText,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        )),
                    onPressed: widget.onActionButtonTwoPress,
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    return WillPopScope(
      // prevent page from closing using back button
      // page can only be used using cancel button
      onWillPop: () async => false,
      child: SafeArea(
          child: StreamBuilder(
        stream: _currentScreenController.stream,
        initialData: false,
        builder: (context, snapshot) {
          // on show success screen
          if (snapshot.data) {
            return operationSuccessScafold(
              successMessage: widget.successScreenMessage,
              onPressed: widget.onSuccessButtonPress,
            );
          }
          // form screen
          return Scaffold(
            key: _key,
            bottomNavigationBar: _buildActionButtonBar(),
            // form body
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  headerContainerBottomCurve(
                      widget.headerTitle, Theme.of(context).primaryColor),
                  _buildFormFields(),
                ],
              ),
            ),
          );
        },
      )),
    );
  }
}
