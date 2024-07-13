import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../services/memento/media_provider.dart';

class FullScreenMediaPage extends StatefulWidget {
  final int initialPage;

  const FullScreenMediaPage({
    Key? key,
    required this.initialPage,
  }) : super(key: key);

  @override
  _FullScreenMediaPageState createState() => _FullScreenMediaPageState();
}

class _FullScreenMediaPageState extends State<FullScreenMediaPage> {
  late PageController _pageController;
  late MediaProvider _mediaProvider;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    RawKeyboard.instance.addListener(_handleKeyEvent);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    });
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _navigateToNextMedia();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _navigateToPreviousMedia();
      }
    }
  }

  void _navigateToPreviousMedia() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToNextMedia() {
    if (_pageController.page! < _mediaProvider.contentList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else if (_mediaProvider.paginationHandler.hasMoreIds()) {
      _mediaProvider.fetchNextPage().then((_) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Consumer<MediaProvider>(
        builder: (context, mediaProvider, child) {
          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: mediaProvider.contentList.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Image.network(
                      mediaProvider.contentList[index].compressedMediaURL,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              // Left navigation arrow
              if (mediaProvider.contentList.length > 1)
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 10,
                  child: Center(
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: _navigateToPreviousMedia,
                    ),
                  ),
                ),
              // Right navigation arrow
              if (mediaProvider.contentList.length > 1)
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 10,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white),
                      onPressed: _navigateToNextMedia,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }
}
