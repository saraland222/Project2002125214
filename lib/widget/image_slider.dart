import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _index = 0;
  int _dataLength = 1;

  Future getSliderImageFromDb() async {
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _fireStore.collection('slider').get();
    if(mounted) {
      setState(() {
      _dataLength = snapshot.docs.length;
    });
    }
    return snapshot.docs;
  }

  @override
  void initState() {
    getSliderImageFromDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if(_dataLength!=0)
          FutureBuilder(
            future: getSliderImageFromDb(),
            builder: (_, snapshot) {
              return snapshot.data == null
                  ? Center(
                    child: CircularProgressIndicator(),
                  )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CarouselSlider.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          DocumentSnapshot sliderImage = snapshot.data[index];
                          Map getImage = sliderImage.data();
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              getImage['image'],
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                        options: CarouselOptions(
                          viewportFraction: 1,
                            initialPage: 0,
                            autoPlay: true,
                            height: 150,
                            onPageChanged: (int i, carouselPageChangedReason) {
                              setState(() {
                                _index =i;
                              });
                            }),
                      ),
                    );
            },
          ),
          if(_dataLength!=0)
          DotsIndicator(
            dotsCount: _dataLength,
            position: _index.toDouble(),
            decorator: DotsDecorator(
              size: Size.square(5.0),
              activeSize: Size(18.0, 9.0),
              color: Colors.black,
              activeColor: Colors.amber,
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ],
      ),
    );
  }
}
