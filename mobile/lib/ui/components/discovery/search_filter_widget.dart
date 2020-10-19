import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/assets.dart';
import '../../../utils/device_ratio.dart';
import '../../../utils/routes.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../../modules/discovery/category_filter_module.dart';
import 'basic_filter_modal_widget.dart';

class SearchFilterWidget extends StatelessWidget {
  const SearchFilterWidget({
    this.typeName,
    this.searchFilterModel,
    this.changeBasicFilterStateFunction,
    this.showLocationTypeFilter,
  });

  final SearchFilterModel searchFilterModel;
  final bool showLocationTypeFilter;
  final String typeName;

  final Function(MoneyFilterModel, SortFilterModel)
      changeBasicFilterStateFunction;

  Widget _buildLocationTypeFilter(BuildContext context, String typeName) {
    final searchFilterBloc = Provider.of<SearchFilterBloc>(context);

    if (typeName == 'EXPERIENCE') {
      return Row(children: <Widget>[
        _buildFilter(
          context,
          searchFilterBloc.getFilterModel().location,
          'LOCATION',
        ),
        const SizedBox(
          width: 20,
        ),
        _buildFilter(
          context,
          searchFilterBloc.getFilterModel().type,
          'TYPE',
        ),
      ]);
    }
    return _buildFilter(
      context,
      searchFilterBloc.getFilterModel().type,
      'TYPE',
    );
  }

  Widget _buildFilter(
      BuildContext context, CategoryModel category, String filterType) {
    final searchFilterBloc = Provider.of<SearchFilterBloc>(context);

    final searchListBloc = Provider.of<SearchListBloc>(context);
    final categoryBloc = Provider.of<CategoryBloc>(context);

    return GestureDetector(
      onTap: category.isTail
          ? () {
              print('isTail ${category.isTail}');
            }
          : () {
              //지역 필터
              AppRoutes.buildButtonModalBottomSheet(
                context: context,
                child: CategoryFilterModule(
                  filterType: filterType,
                  searchFilterBloc: searchFilterBloc,
                  searchListBloc: searchListBloc,
                  categoryBloc: categoryBloc,
                ),
              );
            },
      child: Row(children: <Widget>[
        Text(
          category.name == ''
              ? filterType == 'LOCATION'
                  ? DiscoveryPageStrings.filterLocation
                  : DiscoveryPageStrings.filterType
              : category.name,
          style: TextStyles.grey14TextStyle,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          width: 4,
        ),
        if (!category.isTail)
          Image.asset(
            ImageAssets.arrowDownImage,
            width: 10,
          ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchListBloc = Provider.of<SearchListBloc>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: const Color(0xfffafafa),
      height: 36,
      child: Row(
        children: <Widget>[
          ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: 268 * DeviceRatio.scaleWidth(context)),
            child: showLocationTypeFilter == true
                ? _buildLocationTypeFilter(context, typeName)
                : Container(),
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            child: GestureDetector(
              child: Image(
                width: 24,
                image: AssetImage(
                  ImageAssets.searchFilterIcon,
                ),
              ),
              onTap: () {
                AppRoutes.buildButtonModalBottomSheet(
                  context: context,
                  child: Scaffold(
                    body: BasicFilterModalWidget(
                        searchFilterModel: searchFilterModel,
                        productType: typeName,
                        searchListBloc: searchListBloc,
                        changeStateFunction: changeBasicFilterStateFunction),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
