import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/routes.dart';
import '../../../utils/text_styles.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    this.categoryList,
    this.selectType,
  });

  final List<CategoryModel> categoryList;
  final String selectType;

  Widget _buildCategories(
      BuildContext context, List<CategoryModel> categoryList) {
    if (categoryList.isEmpty) return Container();
    // when first category node has no child , other node will not showing it's child either
    if (categoryList[0].nodes.isEmpty) {
      return Container(
          width: MediaQuery.of(context).size.width,
          child: _buildSelectContainer(context, categoryList));
    }
    return _buildContainer(context, categoryList);
  }

  Widget _buildContainer(
      BuildContext context, List<CategoryModel> categoryList) {
    return Container(
      child: ListView.builder(
        addRepaintBoundaries: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: (categoryList.length) * 2 - 1,
        itemBuilder: (context, index) {
          if (index.isOdd) {
            return Container(
              margin: const EdgeInsets.only(
                bottom: 40,
              ),
            );
          }
          final trueIndex = (index / 2).ceil();
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  categoryList[trueIndex].name,
                  style: TextStyles.cyan12TextStyle,
                ),
                const SizedBox(
                  height: 12,
                ),
                _buildSelectContainer(
                    context, categoryList[trueIndex].nodes), //00,2->12
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectContainer(
      BuildContext context, List<CategoryModel> items) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.map((data) => _buildSelect(context, data)).toList(),
    );
  }

  Widget _buildSelect(BuildContext context, CategoryModel data) {
    final categoryBloc = Provider.of<CategoryBloc>(context);
    final discoveryMainPageBloc = Provider.of<DiscoveryMainPageBloc>(context);
    return GestureDetector(
      onTap: () {
        SearchFilterModel searchFilterModel;
        final outerCategory = categoryBloc.repoList
            .value[discoveryMainPageBloc.mainModelState.value.outerPageState];
        final innerCategory = outerCategory
            .nodes[discoveryMainPageBloc.mainModelState.value.innerPageState];

        switch (selectType) {
          case 'EXPERIENCE':
            //여행타입 지역 id , 클래스타입 지역 id
            if (innerCategory.id == 'Q0FURUdPUlkjMzkx' ||
                innerCategory.id == 'Q0FURUdPUlkjODAz') {
              searchFilterModel = SearchFilterModel(location: data);
              //여행타입 예산 id
            } else if (innerCategory.id == 'Q0FURUdPUlkjNTY3') {
              searchFilterModel = SearchFilterModel(
                  money: MoneyFilterModel(
                      id: data.id,
                      name: data.name,
                      priceRange: PriceRangeModel(
                        min: data.priceRangeModel.min,
                        max: data.priceRangeModel.max,
                      )));
            } else {
              searchFilterModel = SearchFilterModel(type: data);
            }

            break;
          case 'CONTENT':
            searchFilterModel = SearchFilterModel(type: data);
            break;
          case 'ECOUPON':
            searchFilterModel = SearchFilterModel(type: data);
            break;

          default:
            searchFilterModel = SearchFilterModel();
        }
        AppRoutes.discoveryListPage(
            context: context,
            typeName: selectType,
            searchFilterModel: searchFilterModel,
            appTitle: outerCategory.name);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffd0d0d0), width: 1),
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          data.name,
          maxLines: 1,
          style: TextStyles.black14TextStyle,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  // final int innerPageState;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: _buildCategories(context, categoryList),
          ),
          const Divider(
            height: 1,
            color: Color(0xffeeeeee),
          ),
        ],
      ),
    );
  }
}
