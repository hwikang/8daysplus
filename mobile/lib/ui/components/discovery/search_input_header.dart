import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../utils/assets.dart';
import '../../../utils/debouncer.dart';
import '../../../utils/singleton.dart';
import '../../../utils/text_styles.dart';

class SearchInputHeader extends StatefulWidget {
  const SearchInputHeader({
    this.controller,
  });

  final TextEditingController controller;

  @override
  _SearchInputHeaderState createState() => _SearchInputHeaderState();
}

class _SearchInputHeaderState extends State<SearchInputHeader> {
  final FocusNode searchFocus = FocusNode();
  final debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    searchFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
          FocusScope.of(context).requestFocus(searchFocus);
        }));
  }

  @override
  Widget build(BuildContext context) {
    final searchBodyBloc = Provider.of<SearchStateBloc>(context);
    final searchKeywordBloc = Provider.of<SearchKeywordBloc>(context);
    final searchListBloc = Provider.of<SearchListBloc>(context);

    return Container(
      child: TextField(
        controller: widget.controller,
        focusNode: searchFocus,
        onSubmitted: (data) {
          searchListBloc.search(
              keyword: data,
              type: 'EXPERIENCE',
              location: LocationModel(
                  lat: Singleton.instance.curLat,
                  lng: Singleton.instance.curLng));
          searchBodyBloc.changeTabState(0);
          searchBodyBloc.changeBodyState(SearchBodyState.Result);
        },
        onTap: () {
          if (searchBodyBloc.searchBodyState.value == SearchBodyState.Result) {
            searchBodyBloc.changeBodyState(SearchBodyState.Suggestion);
          }
        },
        onChanged: (value) {
          debouncer.run(() {
            searchKeywordBloc.search(value);
          });
        },
        textAlignVertical: TextAlignVertical.center,
        style: TextStyles.black14TextStyle,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          prefixIcon: Container(
            width: 48, //prefix icon minimum size
            padding: const EdgeInsets.only(
              left: 12,
              top: 13,
              bottom: 12,
            ),
            alignment: Alignment.centerLeft,
            child: Image.asset(
              ImageAssets.searchIconImage,
              color: const Color(0xff404040),
              width: 18,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xffe0e0e0), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xff404040), width: 1.0),
          ),
          suffixIcon: IconButton(
            icon: Container(
              width: 20,
              child: Image(image: AssetImage(ImageAssets.searchClearIcon)),
            ),
            onPressed: () {
              widget.controller.text = '';
            },
          ),
        ),
      ),
    );
  }
}
