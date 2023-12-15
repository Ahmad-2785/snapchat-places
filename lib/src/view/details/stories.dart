import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapchat/src/res/routes/routes.dart';
import 'package:snapchat/src/view/details/video_play.dart';

class Stories extends StatefulWidget {
  const Stories({
    super.key,
    required this.stories,
  });
  final List<Map> stories;
  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 0),
      child: widget.stories.isNotEmpty
          ? FutureBuilder<List<Map>>(
              future: Future.value(widget.stories),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                      itemCount: snapshot.data?.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, childAspectRatio: 0.6),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 16, top: 0),
                          child: snapshot.data![index]['value']
                                      ['contentType'] ==
                                  'image/jpeg'
                              ? GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.imageDetailView,
                                        arguments: {
                                          'data': snapshot.data![index],
                                        });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                              image: NetworkImage(snapshot
                                                  .data![index]['value']['url']!),
                                              fit: BoxFit.cover))),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.videoDetailView,
                                        arguments: {
                                          'data': snapshot.data![index],
                                        });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        VideoPlay(
                                            pathh: snapshot.data![index]
                                                ['value']['url']),
                                        const Icon(
                                          Icons.play_arrow,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        );
                      });
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          : Center(
              child: Text(
                "There is no story",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
    );
  }
}
