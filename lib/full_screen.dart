import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  final image, tag;

  FullScreen({this.image, this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  padding: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  color: Colors.white,
                  minWidth: 0,
                  height: 40,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: tag,
                  child: Image.file(
                    image,
                    width: 270,
                    height: 270,
                    errorBuilder: (context, url, error) =>
                        Icon(Icons.error_outline),
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black45,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.crop,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Crop',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
