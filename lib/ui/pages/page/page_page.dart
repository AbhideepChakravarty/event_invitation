import 'package:carousel_slider/carousel_slider.dart';
import 'package:event_invitation/services/page/page_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/helper/language_provider.dart';
import '../../../services/page/page_data.dart';
import '../../helpers/media/audio_player.dart';
import '../../helpers/theme/font_provider.dart';

class PagePage extends StatelessWidget {
  final String pageRef;
  final PageService _pageService = PageService();

  PagePage({Key? key, required this.pageRef}) : super(key: key);

  Future<PageData> _fetchPageData(String languageCode) async {
    //print("Fetching data in language code: $languageCode");
    // Replace this with your actual data fetching logic
    return _pageService.fetchPageData(pageRef, languageCode);
  }

  @override
  Widget build(BuildContext context) {
    String languageCode = Provider.of<LanguageProvider>(context, listen: false)
        .locale
        .languageCode;

    return FutureBuilder<PageData>(
      future: _fetchPageData(languageCode),
      builder: (context, snapshot) {
        //print("Snapshot: $snapshot");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final pageData = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              pageData.title,
              style: Provider.of<FontProvider>(context).secondaryTextFont,
            ),
            automaticallyImplyLeading: false, // Disable the back button
          ),
          body: Stack(children: [
            _buildBackgroundImage(pageData, context),
            _buildContent(context, pageData),
          ]),
        );
      },
    );
  }

  List<Widget> _buildContentList(
      List<PageContent> contentList, BuildContext context) {
    List<Widget> widgets = [];
    final fontProvider = Provider.of<FontProvider>(context);

    for (var content in contentList) {
      if (content is TextContent) {
        widgets.add(
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(content.text.replaceAll('\\n', '\n'),
                  style: fontProvider.descriptionTextFont)),
        );
      } else if (content is ImageContent) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.network(content.image.toString()),
          ),
        );
      } else if (content is ImageCarouselContent) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                pauseAutoPlayOnTouch: true,
              ),
              items: content.imageList.map((image) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Image.network(image.toString(), fit: BoxFit.scaleDown),
                );
              }).toList(),
            ),
          ),
        );
      } else if (content is AudioContent) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AudioPlayerWidget(audioUri: content.audio),
          ),
        );
      }
      widgets.add(Container(height: 30, color: Colors.white));
    }

    return widgets;
  }

  _buildContent(BuildContext context, PageData pageData) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.35),
        Container(
            decoration: const BoxDecoration(
              color: Colors.white, // White background color
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), // Rounded top left corner
                topRight: Radius.circular(20), // Rounded top right corner
              ),
            ),
            child: Column(children: [
              ..._buildContentList(pageData.contentList, context)
            ])),
      ],
    );
  }

  _buildBackgroundImage(PageData pageData, BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.40,
          child: Image.network(
            pageData.headerImage,
            width: double.infinity,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}
