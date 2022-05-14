import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user/models/businessLayer/global.dart' as global;

class ProfilePicture extends StatefulWidget {
  @required
  final String profilePictureUrl;
  final Function onPressed;
  final File tImage;
  @required
  final bool isShow;

  ProfilePicture({this.profilePictureUrl, this.onPressed, this.tImage, this.isShow}) : super();

  @override
  _ProfilePictureState createState() => _ProfilePictureState(profilePictureUrl: profilePictureUrl, onPressed: onPressed, tImage: tImage, isShow: isShow);
}

class _ProfilePictureState extends State<ProfilePicture> {
  String profilePictureUrl;
  Function onPressed;
  File tImage;
  bool isShow;

  _ProfilePictureState({this.profilePictureUrl, this.onPressed, this.tImage, this.isShow});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        tImage != null
            ? CircleAvatar(
                backgroundColor: Colors.white,
                radius: 60,
                backgroundImage: FileImage(File(tImage.path)),
              )
            : global.currentUser.userImage != null
                ? CachedNetworkImage(
                    imageUrl: global.appInfo.imageUrl + global.currentUser.userImage,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 60,
                      backgroundImage: imageProvider,
                      backgroundColor: Colors.white,
                    ),
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Theme.of(context).primaryColor,
                        )),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 60,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
        isShow
            ? Positioned(
                bottom: 0,
                right: -4,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      _showCupertinoModalSheet();
                      setState(() {});
                    },
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Future<File> openCamera() async {
    try {
      PermissionStatus permissionStatus = await Permission.camera.status;
      if (permissionStatus.isLimited || permissionStatus.isDenied) {
        permissionStatus = await Permission.camera.request();
      }
      XFile _selectedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      File imageFile = File(_selectedImage.path);
      if (imageFile != null) {
        File _finalImage = await _cropImage(imageFile.path);

        _finalImage = await _imageCompress(_finalImage, imageFile.path);

        return _finalImage;
      }
    } catch (e) {
      print("Exception - profile_picture.dart - openCamera():" + e.toString());
    }
    return null;
  }

  Future<File> selectImageFromGallery() async {
    try {
      PermissionStatus permissionStatus = await Permission.photos.status;
      if (permissionStatus.isLimited || permissionStatus.isDenied) {
        permissionStatus = await Permission.photos.request();
      }
      File imageFile;
      XFile _selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      imageFile = File(_selectedImage.path);
      if (imageFile != null) {
        File _byteData = await _cropImage(imageFile.path);
        _byteData = await _imageCompress(_byteData, imageFile.path);
        return _byteData;
      }
    } catch (e) {
      print("Exception - profile_picture.dart - selectImageFromGallery()" + e.toString());
    }
    return null;
  }

  Future<File> _cropImage(String sourcePath) async {
    try {
      File _croppedFile = await ImageCropper().cropImage(
        sourcePath: sourcePath,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.original,
          backgroundColor: Colors.white,
          toolbarColor: Colors.black,
          dimmedLayerColor: Colors.white,
          toolbarWidgetColor: Colors.white,
          cropGridColor: Colors.white,
          activeControlsWidgetColor: Color(0xFF46A9FC),
          cropFrameColor: Color(0xFF46A9FC),
          lockAspectRatio: true,
        ),
      );
      if (_croppedFile != null) {
        return _croppedFile;
      }
    } catch (e) {
      print("Exception - profile_picture.dart - _cropImage():" + e.toString());
    }
    return null;
  }

  Future<File> _imageCompress(File file, String targetPath) async {
    try {
      var result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        minHeight: 500,
        minWidth: 500,
        quality: 60,
      );

      return result;
    } catch (e) {
      print("Exception - profile_picture.dart - _cropImage():" + e.toString());
      return null;
    }
  }

  _showCupertinoModalSheet() {
    try {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text('${AppLocalizations.of(context).lbl_actions}'),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                '${AppLocalizations.of(context).lbl_take_picture}',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              onPressed: () async {
                Navigator.pop(context);

                tImage = await openCamera();
                global.selectedImage = tImage.path;

                setState(() {});
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                '${AppLocalizations.of(context).txt_upload_image_desc}',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              onPressed: () async {
                Navigator.pop(context);

                tImage = await selectImageFromGallery();
                global.selectedImage = tImage.path;

                setState(() {});
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('${AppLocalizations.of(context).lbl_cancel}', style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      print("Exception - profile_picture.dart - _showCupertinoModalSheet():" + e.toString());
    }
  }
}
