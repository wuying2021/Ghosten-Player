import 'package:api/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class AsyncImage extends StatelessWidget {
  const AsyncImage(
    this.src, {
    super.key,
    this.width,
    this.height,
    this.radius = BorderRadius.zero,
    this.alignment = Alignment.center,
    this.fit = BoxFit.cover,
    this.ink = false,
    this.needLoading = true,
    this.errorIconSize = 36,
    this.padding = EdgeInsets.zero,
    this.httpHeaders,
    this.viewable = false,
    this.showErrorWidget = true,
    this.errorWidget,
  });

  final String src;
  final double? width;
  final double? height;
  final BorderRadius radius;
  final Alignment alignment;
  final BoxFit fit;
  final bool ink;
  final bool needLoading;
  final double errorIconSize;
  final EdgeInsets padding;
  final Map<String, String>? httpHeaders;
  final bool viewable;
  final bool showErrorWidget;
  final LoadingErrorWidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final int? cacheWidth = width != null ? (devicePixelRatio * width!).round() : null;
    final int? cacheHeight = height != null ? (devicePixelRatio * height!).round() : null;
    final String imageUrl = _resoleSrc();
    final image = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: radius),
      child: CachedNetworkImage(
        cacheKey: imageUrl,
        imageUrl: imageUrl,
        alignment: alignment,
        fit: fit,
        filterQuality: FilterQuality.medium,
        width: width,
        height: height,
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
        httpHeaders: src.startsWith('https://media.themoviedb.org')
            ? httpHeaders ?? const {'referer': 'https://www.themoviedb.org/'}
            : httpHeaders,
        errorListener: (error) async {
          PaintingBinding.instance.imageCache.evict(CachedNetworkImageProvider(imageUrl));
          await CachedNetworkImage.evictFromCache(imageUrl);
        },
        errorWidget:
            errorWidget ??
            (context, url, error) => showErrorWidget
                ? Center(
                    child: Icon(
                      Icons.broken_image,
                      size: errorIconSize,
                      color: Theme.of(context).colorScheme.error.withAlpha(0x33),
                    ),
                  )
                : const SizedBox(),
        placeholder: (context, _) => needLoading ? const _AnimatedLoading() : const SizedBox(),
        imageBuilder: ink
            ? (context, imageProvider) {
                return Ink(
                  padding: padding,
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    image: DecorationImage(
                      image: ResizeImage.resizeIfNeeded(cacheWidth, cacheHeight, imageProvider),
                      fit: fit,
                      alignment: alignment,
                    ),
                  ),
                );
              }
            : null,
      ),
    );
    return viewable
        ? GestureDetector(
            onLongPress: () => context.pushNamed(.imageViewer, arguments: {'url': Uri.parse(src)}),
            child: image,
          )
        : image;
  }

  String _resoleSrc() {
    if (src.startsWith('/file/download')) {
      return '${Api.baseUrl}$src';
    } else {
      return src;
    }
  }
}

class _AnimatedLoading extends StatefulWidget {
  const _AnimatedLoading();

  @override
  State<_AnimatedLoading> createState() => _AnimatedLoadingState();
}

class _AnimatedLoadingState extends State<_AnimatedLoading> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) => DecoratedBox(
        decoration: BoxDecoration(
          color: Color.lerp(
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceContainerHigh,
            _animationController.value,
          ),
        ),
      ),
    );
  }
}
