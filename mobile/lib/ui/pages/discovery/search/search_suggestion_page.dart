import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/network_delay_widget.dart';
import '../../../components/discovery/search_input_header.dart';
import 'body/search_suggestion_body.dart';

class SearchSuggestionPage extends StatefulWidget {
  @override
  _SearchSuggestionPageState createState() => _SearchSuggestionPageState();
}

class _SearchSuggestionPageState extends State<SearchSuggestionPage> {
  String searchValue;

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_handleText);
  }

  void _handleText() {
    setState(() {
      searchValue = _textController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          titleSpacing: 0.0,
          title: Container(
              height: 44,
              margin: const EdgeInsets.only(top: 8, left: 24),
              child: SearchInputHeader(controller: _textController)),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                // color: Colors.transparent,
                width: 58,
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    CommonTexts.cancel,
                    style: TextStyles.black14TextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<SearchKeywordModel>(
          stream: Provider.of<SearchKeywordBloc>(context).repoList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return NetworkDelayPage(
                retry: () {
                  Provider.of<SearchKeywordBloc>(context).search(searchValue);
                },
              );
            }
            if (!snapshot.hasData) {
              return Container();
            }

            return SearchSuggestionBody(
              textController: _textController,
              results: snapshot.data,
              // query: textController.text,
            );
          }),
    );
  }
}
