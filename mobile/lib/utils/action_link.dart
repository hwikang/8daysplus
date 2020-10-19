import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/handle_network_error.dart';

import '../ui/components/common/dialog_widget.dart';
import '../ui/components/common/payment_webview.dart';
import 'routes.dart';

class ActionLink {
  bool founded = false;

  Future<void> handleActionLink(BuildContext context,
      ActionLinkModel actionLinkModel, String title) async {
    switch (actionLinkModel.target) {
      case 'DISCOVERY':
        final Map<String, dynamic> value = json.decode(actionLinkModel.value);

        makeModelDiscoveryLinkType(value).then((searchFilterModel) {
          AppRoutes.discoveryListPage(
              context: context,
              typeName: value['where']['Type'][0],
              searchFilterModel: searchFilterModel,
              appTitle: title);
        }).catchError((error) {
          HandleNetworkError.showErrorDialog(context, error);
        });

        break;
      case 'PRODUCT_DETAIL':
        AppRoutes.productDetailSimplePage(
          context: context,
          productId: actionLinkModel.value,
        );

        break;
      case 'WEB':
        if (actionLinkModel.value.contains('couponId')) {
          final uri = Uri.parse(actionLinkModel.value);

          print(uri.queryParameters['couponId']);
          final couponId = uri.queryParameters['couponId'];

          final applyCouponBloc = ApplyCouponBloc();
          applyCouponBloc.getCoupon(couponId).then((model) {
            DialogWidget.showAlert(
                context: context, child: Text(model.message));
          }).catchError((dynamic error) {
            HandleNetworkError.showErrorSnackBar(context, error);
          });
        } else {
          AppRoutes.buildTitledModalBottomSheet(
              title: '',
              context: context,
              child: PaymentWebview(
                url: actionLinkModel.value,
              ));
        }

        break;
      case 'NOTICE_EVENT_DETAIL':
        AppRoutes.noticeEventDetailPage(
          context,
          actionLinkModel.value,
        );
        break;

        break;

      default:
    }
  }

  Future<SearchFilterModel> makeModelDiscoveryLinkType(
      Map<String, dynamic> value) async {
    getLogger(this).i(value);
    final searchFilterModel = SearchFilterModel();

    if (value['orderBy'] != null) {
      var name = '';
      switch (value['orderBy']['Field']) {
        case 'PRICE':
          if (value['orderBy']['Direction'] == 'ASC') {
            name = '낮은 가격순';
          } else {
            name = '높은 가격순';
          }
          break;
        case 'CREATED_AT':
          name = '최신순';
          break;
        case 'POPULARITY':
          name = '인기순';
          break;

        default:
      }
      searchFilterModel.sort = SortFilterModel(
        name: name,
        orderBy: OrderByModel(
          direction: value['orderBy']['Direction'],
          field: value['orderBy']['Field'],
        ),
      );
    }
    if (value['where']['PriceRange'] != null) {
      searchFilterModel.money = MoneyFilterModel(
        priceRange: PriceRangeModel(
          max: value['where']['PriceRange']['Max'],
          min: value['where']['PriceRange']['Min'],
        ),
      );
    }

    if (value['where']['CategoryIDs'] != null) {
      // print('category IDS');
      // print(value['where']['CategoryIDs']);
      await findCategoryNameById(
              value['where']['Type'][0], value['where']['CategoryIDs'][0])
          .then((categoryModel) {
        searchFilterModel.type = categoryModel;
        // print('in if ${searchFilterModel.type.id}');
      });
    }

    if (value['where']['CategoryRegionIDs'] != null) {
      await findCategoryNameById(
              value['where']['Type'][0], value['where']['CategoryRegionIDs'][0])
          .then((categoryModel) {
        searchFilterModel.location = categoryModel;
      });
    }

    // print('out  if ${searchFilterModel.type.id}');
    return searchFilterModel;
  }

  //카테고리 id 로 카테고리 모델 생성
  Future<CategoryModel> findCategoryNameById(
      String typeName, String categoryId) {
    final categoryBloc = CategoryBloc();
    return categoryBloc
        .getCategories(
            typeName: typeName, searchTypeName: '', categoryId: categoryId)
        .then((list) {
      final modelToFind = <CategoryModel>[];
      findCategory(modelToFind, categoryId, list);
      // print('find! ${modelToFind[0].toJSON}');
      return modelToFind[0];
    });
  }

  void findCategory(List<CategoryModel> modelToFind, String categoryId,
      List<CategoryModel> list) {
    if (founded) {
      //breaker
    } else {
      for (var model in list) {
        if (model.id == categoryId) {
          founded = true;
          // print('findCategoty ${model.toJSON()}');
          modelToFind.add(model);
        }
        if (model.nodes != null) {
          findCategory(modelToFind, categoryId, model.nodes);
        }
      }
    }
  }
}
