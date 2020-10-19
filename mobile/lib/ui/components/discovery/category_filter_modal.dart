import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../utils/text_styles.dart';
import '../common/expansion_tile_widget.dart';

class CategoryFilterModal extends StatefulWidget {
  const CategoryFilterModal({
    this.filterType, //TYPE,LOCATION
    this.searchFilterBloc,
    this.searchListBloc,
    this.depth,
    this.categoryList,
  });

  final List<CategoryModel> categoryList;
  final int depth;
  final String filterType;
  final SearchFilterBloc searchFilterBloc;
  final SearchListBloc searchListBloc;

  @override
  _CategoryFilterModalState createState() => _CategoryFilterModalState();
}

class _CategoryFilterModalState extends State<CategoryFilterModal> {
  int tabIndex;
  final tabs = <Widget>[];

  @override
  void initState() {
    tabIndex = 0;
    super.initState();

    widget.categoryList.map((model) {
      tabs.add(Tab(
        text: model.name,
      ));
    }).toList();
  }

  List<Widget> _buildPages(
      BuildContext context, List<CategoryModel> categoryList) {
    final page = <Widget>[];
    categoryList.map((rootCategory) {
      page.add(ListView.builder(
        itemBuilder: (context, index) {
          return Container(
              margin: const EdgeInsets.only(left: 24),
              child: CategoryListTileWidget(
                model: rootCategory.nodes[index],
                index: index,
                filterType: widget.filterType,
                searchFilterBloc: widget.searchFilterBloc,
                searchListBloc: widget.searchListBloc,
              ));
        },
        itemCount: rootCategory.nodes.length,
      ));
    }).toList();

    return page;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.depth == 2) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemCount: widget.categoryList.length,
          itemBuilder: (context, index) {
            return Container(
                margin: const EdgeInsets.only(left: 24),
                child: CategoryListTileWidget(
                  model: widget.categoryList[index],
                  index: index,
                  filterType: widget.filterType,
                  searchFilterBloc: widget.searchFilterBloc,
                  searchListBloc: widget.searchListBloc,
                ));
          },
        ),
      );
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            48,
          ),
          child: AppBar(
            elevation: 1.0,
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Container(
              padding: const EdgeInsets.only(left: 24.0),
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: TabBar(
                  onTap: (newIndex) {
                    setState(() {
                      tabIndex = newIndex;
                    });
                  },
                  indicatorColor: Colors.black,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.only(right: 20),
                  indicatorPadding: const EdgeInsets.only(right: 20),
                  indicatorWeight: 2.0,
                  labelStyle: TextStyles.black14TextStyle,
                  labelColor: Colors.black,
                  unselectedLabelStyle: TextStyles.grey14TextStyle,
                  unselectedLabelColor: Colors.grey,
                  tabs: tabs,
                ),
              ),
            ),
          ),
        ),
        body: IndexedStack(
          index: tabIndex,
          children: _buildPages(context, widget.categoryList),
        ),
      ),
    );
  }
}

class CategoryListTileWidget extends StatefulWidget {
  const CategoryListTileWidget({
    this.model,
    this.index,
    this.filterType,
    this.searchFilterBloc,
    this.searchListBloc,
  });

  final String filterType;
  final int index;
  final CategoryModel model;
  final SearchFilterBloc searchFilterBloc;
  final SearchListBloc searchListBloc;

  @override
  _CategoryListTileWidgetState createState() => _CategoryListTileWidgetState();
}

class _CategoryListTileWidgetState extends State<CategoryListTileWidget> {
  bool isOpened;

  @override
  void initState() {
    super.initState();
    widget.index == 0 ? isOpened = true : isOpened = false;
  }

  Widget _buildGrid(BuildContext context, CategoryModel child, bool isFirst) {
    Widget childWidget;
    if (isFirst) {
      childWidget = Text('${child.name}전체', maxLines: 1);
    } else {
      childWidget = Text(
        child.name,
        maxLines: 1,
      );
    }

    return GestureDetector(
        onTap: () {
          _onTabCategory(child);
        },
        child: childWidget);
  }

  void _onTabCategory(CategoryModel child) {
    switch (widget.filterType) {
      case 'TYPE':
        widget.searchFilterBloc.changeTypeFilter(child);

        break;
      case 'LOCATION':
        widget.searchFilterBloc.changeLocationFilter(child);

        break;
    }
    widget.searchListBloc.search(
      categoryRegionIds: '${widget.searchFilterBloc.model.location.id}',
      categoryIds: '${widget.searchFilterBloc.model.type.id}',
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.nodes == null || widget.model.nodes.isEmpty) {
      return GestureDetector(
          child: TileWidget(
        onEvent: () {
          _onTabCategory(widget.model);
        },
        title: Text(
          widget.model.name,
          style: TextStyles.black14TextStyle,
        ),
      ));
    }

    return ExpansionTileWidget(
      onEvent: () {
        setState(() {
          isOpened = !isOpened;
        });
      },
      initiallyOpened: isOpened,
      title: Text(
        widget.model.name,
        style: isOpened
            ? TextStyles.black14BoldTextStyle
            : TextStyles.black14TextStyle,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio:
                  149 / (20 * MediaQuery.of(context).textScaleFactor),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16),
          itemCount: widget.model.nodes.length + 1, //서울전체
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildGrid(context, widget.model, true);
            }
            return _buildGrid(context, widget.model.nodes[index - 1], false);
          },
        ),
      ),
    );
  }
}
