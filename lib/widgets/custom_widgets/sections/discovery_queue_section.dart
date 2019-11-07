import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/screens/discovery_queue/discovery_queue.dart';
import 'package:movie_finder/widgets/custom_widgets/sections/shared/section_header.dart';

class DiscoveryQueueSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: InkWell(
          onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => DiscoveryQueue()));},
          child: Container(
            width: double.infinity,
            height: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SectionHeader("Discovery Queue"),
                _buildThumbnailStack(),
                Text(
                  "TAP TO START",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailStack() {
    return Stack(
      children: <Widget>[
        Container(
            height: 100,
            child: new Image(
                image: new CachedNetworkImageProvider(
                    "https://image.tmdb.org/t/p/w185_and_h278_bestv2/iiZZdoQBEYBv6id8su7ImL0oCbD.jpg"))),
        Container(
            height: 100,
            padding: EdgeInsets.only(left: 35.0),
            child: new Image(
                image: new CachedNetworkImageProvider(
                    "https://image.tmdb.org/t/p/w185_and_h278_bestv2/2uNW4WbgBXL25BAbXGLnLqX71Sw.jpg"))),
        Container(
            height: 100,
            padding: EdgeInsets.only(left: 70.0),
            child: new Image(
                image: new CachedNetworkImageProvider(
                    "https://image.tmdb.org/t/p/w185_and_h278_bestv2/lHu1wtNaczFPGFDTrjCSzeLPTKN.jpg")))
      ],
    );
  }
}
