import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_player/config/routes/main_routes.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/config/themes/main_text_style.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/shared_components/dot_divider.dart';
import 'package:media_player/utils/extension_function.dart';

class CoverVideoCard extends StatelessWidget {
  const CoverVideoCard({super.key, required this.video});
  final Video video;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          MainRoute.videoPlayer,
          arguments: video,
        );
      },
      child: Column(
        key: const Key('column_card_wrapper'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).width * 9 / 16,
            child: video.sourceType == "local"
                ? Image.asset(
                    video.coverPath!,
                    fit: BoxFit.cover,
                  )
                : ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: video.coverPath!,
                      progressIndicatorBuilder: (context, url, progress) =>
                          const Center(
                              child: CircularProgressIndicator(
                                  color: MainColor.purple5A579C)),
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: MainTextStyle.poppinsW700
                      .copyWith(fontSize: 15, color: MainColor.whiteF2F0EB),
                ),
                const SizedBox(
                  height: 4,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 12,
                  children: [
                    Text(
                      video.creator!,
                      overflow: TextOverflow.ellipsis,
                      style: MainTextStyle.poppinsW400
                          .copyWith(fontSize: 12, color: MainColor.whiteF2F0EB),
                    ),
                    const DotDivider(),
                    Text(
                      "${video.viewsCount!.formatViewsCount()} x views",
                      overflow: TextOverflow.ellipsis,
                      style: MainTextStyle.poppinsW400
                          .copyWith(fontSize: 12, color: MainColor.whiteF2F0EB),
                    ),
                    const DotDivider(),
                    Text(
                      video.releaseDate!.toLocalTime(),
                      overflow: TextOverflow.ellipsis,
                      style: MainTextStyle.poppinsW400
                          .copyWith(fontSize: 12, color: MainColor.whiteF2F0EB),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
