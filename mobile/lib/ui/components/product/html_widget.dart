import 'package:flutter/material.dart' hide Element;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:html_widget/flutter_html.dart';
import 'package:html_widget/html_parser.dart';
import 'package:html_widget/style.dart';

import '../../../utils/routes.dart';
import '../../../utils/text_styles.dart';
import '../common/list_style_text_widget.dart';

class HtmlWidget extends StatefulWidget {
  const HtmlWidget(
      {this.html,
      // this.padding,
      this.fontHeight = 2.0,
      this.typeName = 'CONTENT'});

  final double fontHeight;
  final String html;
  // final EdgeInsetsGeometry padding;
  final String typeName;

  @override
  _HtmlWidgetState createState() => _HtmlWidgetState();
}

class _HtmlWidgetState extends State<HtmlWidget> {
  @override
  Widget build(BuildContext context) {
    // print(html);
    // void printWrapped(String text) {
    //   final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    //   pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
    // }
    // printWrapped(widget.html);

    print('type Name ${widget.typeName}');

    return Html(
      data: widget.html,
      customRender: <String, CustomRender>{
        'li': (renderContext, child, attributes, element) {
          return Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: ListStyleTextWidget(
                text: element.text,
              ));
        },
      },
      style: <String, Style>{
        '.align-center': Style(alignment: Alignment.center),
        '.align-right': Style(alignment: Alignment.centerRight),
        '.align-left': Style(alignment: Alignment.centerLeft),
        'html': Style(
          // color: Colors.black,
          fontSize:
              FontSize(15.0 * MediaQuery.of(context).textScaleFactor.round()),
          fontFamily: 'Spoqa',
        ),
        'body': Style(
          margin: const EdgeInsets.all(0),
        ),
        'img': Style(margin: const EdgeInsets.all(0)),
        'p': Style(
          // backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          margin: const EdgeInsets.only(bottom: 6),
          color: const Color(0xff404040),
          fontSize: FontSize(14.0 * MediaQuery.of(context).textScaleFactor),
          fontFamily: FontFamily.regular,
          fontStyle: FontStyle.normal,
          fontHeight: widget.fontHeight,
        ),
        'p *': Style(
          fontHeight: widget.fontHeight,
        ),
        'a': Style(
            color: const Color(0xffff7500),
            textDecoration: TextDecoration.none,
            fontSize: widget.typeName == 'CONTENT'
                ? const FontSize(20)
                : const FontSize(12)),
        'table': Style(
          backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
        ),
        'tr': Style(
          border: const Border(bottom: BorderSide(color: Colors.grey)),
        ),
        'th': Style(
          padding: const EdgeInsets.all(6),
          backgroundColor: Colors.grey,
        ),
        'td': Style(
          padding: const EdgeInsets.all(6),
        ),
        'var': Style(fontFamily: 'Spoqa'),
        'li': Style(
          // fontHeight: 2,
          display: Display.BLOCK,
          // padding: const EdgeInsets.only(right: 24),
          fontSize: FontSize.percent(
              (100 * MediaQuery.of(context).textScaleFactor).round()),
        ),
        'h1': Style(
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        'h2': Style(
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        'h3': Style(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            fontSize: FontSize(
                20.0 * MediaQuery.of(context).textScaleFactor.round())),
        'h4': Style(
            fontSize: FontSize(
                15.0 * MediaQuery.of(context).textScaleFactor.round())),
        'h5': Style(
            fontSize:
                FontSize(10.0 * MediaQuery.of(context).textScaleFactor.round()),
            fontWeight: FontWeight.normal),
        'hr': Style(
          height: 1,
          border: const Border(
              top: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide.none,
              left: BorderSide.none),
          backgroundColor: Colors.black12,
          margin: const EdgeInsets.fromLTRB(130, 40, 130, 40),
        ),
      },
      onLinkTap: (url) {
        if (url.contains('mtravel.assistcard.co.kr')) {
          url =
              'https://www.carrotins.com/mobile/calculation/general/overseas/intro/?adcd=2_1_1_26_10_5&utm_campaign=home&utm_medium=cpt&utm_source=naver_pc_brandsa_title&utm_content=base_easier_orange';
        }
        AppRoutes.buildTitledModalBottomSheet(
            context: context,
            title: url,
            child: WebviewScaffold(
              url: url,
            ));
      },
      onImageTap: (url) {},
    );
  }
}
