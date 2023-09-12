import 'package:flutter/cupertino.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

class MultiPhotoWidget extends StatelessWidget {
  final List<Asset> photoList;
  final Function choosePhotoAction;
  final Function(int index) deleteAction;
  final int maxPhoto;

  const MultiPhotoWidget({
    Key key,
    @required this.photoList,
    this.choosePhotoAction,
    this.deleteAction,
    this.maxPhoto = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double space = 10;
    double photoWH = (MediaQuery.of(context).size.width - 16 * 4 - 20) / 3;
    int photoCount = this.photoList.length == this.maxPhoto
        ? this.photoList.length
        : this.photoList.length + 1;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: space,
        crossAxisSpacing: space,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        int photoCount = this.photoList.length;
        return GestureDetector(
          child: Container(
            width: photoWH,
            height: photoWH,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                index == photoCount && photoCount < this.maxPhoto
                    ? DYLocalImage(
                        imageName: "common_picture_add",
                        size: photoWH - 12,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 12, right: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AssetThumb(
                            asset: this.photoList[index],
                            width: photoWH.toInt() * 3,
                            height: photoWH.toInt() * 3,
                          ),
                        ),
                      ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Offstage(
                    offstage: index == photoCount && photoCount < this.maxPhoto,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      minSize: 32,
                      child: DYLocalImage(
                        imageName: "order_photo_delete",
                        size: 24,
                      ),
                      onPressed: () {
                        this.deleteAction(index);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            if (index == photoCount && photoCount < this.maxPhoto) {
              this.choosePhotoAction();
            }
          },
        );
      },
      itemCount: photoCount,
    );
  }
}
