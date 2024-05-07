import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/config/themes/main_text_style.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/shared_components/dot_divider.dart';
import 'package:media_player/utils/extension_function.dart';

class VideoInformation extends StatefulWidget {
  const VideoInformation({
    super.key,
    required this.video,
  });

  final Video video;
  @override
  State<VideoInformation> createState() => _VideoInformationState();
}

class _VideoInformationState extends State<VideoInformation> {
  bool _canShowMore = true;

  switchShowMore() {
    setState(() {
      _canShowMore = !_canShowMore;
    });
  }

  bool _hasMoreThanThreeLine(String? deskripsi) {
    final span = TextSpan(
      text: deskripsi,
      style: MainTextStyle.poppinsW400.copyWith(
        fontSize: 12,
      ),
    );
    final tp = TextPainter(
      text: span,
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 16);
    return tp.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.video.title!,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: MainTextStyle.poppinsW600.copyWith(
            fontSize: 18,
            color: MainColor.whiteF2F0EB,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CachedNetworkImage(
                    imageUrl: widget.video.creatorPhoto!,
                    progressIndicatorBuilder: (context, url, progress) =>
                        const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: MainColor.purple5A579C,
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                widget.video.creator!,
                style: MainTextStyle.poppinsW500.copyWith(
                  fontSize: 14,
                  color: MainColor.whiteFFFFFF,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              "${widget.video.viewsCount!.formatViewsCount()} x views",
              style: MainTextStyle.poppinsW500.copyWith(
                fontSize: 13,
                color: MainColor.whiteFFFFFF,
              ),
            ),
            const DotDivider(),
            Text(
              widget.video.releaseDate!.toLocalTime(),
              style: MainTextStyle.poppinsW500.copyWith(
                fontSize: 13,
                color: MainColor.whiteFFFFFF,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        if (_hasMoreThanThreeLine(widget.video.description) &&
            _canShowMore) ...[
          Text(
            widget.video.description!,
            maxLines: 3,
            style: MainTextStyle.poppinsW400.copyWith(
              fontSize: 12,
              color: MainColor.whiteFFFFFF,
            ),
          ),
          InkWell(
            onTap: switchShowMore,
            child: Text(
              '...other',
              style: MainTextStyle.poppinsW400.copyWith(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
          ),
        ] else ...[
          Text(
            widget.video.description!,
            style: MainTextStyle.poppinsW400.copyWith(
              fontSize: 12,
              color: MainColor.whiteFFFFFF,
            ),
          ),
          const SizedBox(height: 12),
          if (_hasMoreThanThreeLine(widget.video.description))
            InkWell(
              onTap: switchShowMore,
              child: Text(
                'Less',
                style: MainTextStyle.poppinsW400.copyWith(
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
            ),
        ]
      ],
    );
  }
}
