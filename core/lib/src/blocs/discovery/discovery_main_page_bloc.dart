// enum DiscoveryMainPageState {ActivityPageModel,ContentsPageModel,EcouponPageModel}

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class DiscoveryMainPageBloc {
  DiscoveryMainPageBloc({this.model}) {
    mainModelState.add(model);
  }

  BehaviorSubject<DiscoveryMainPageModel> mainModelState =
      BehaviorSubject<DiscoveryMainPageModel>();

  DiscoveryMainPageModel model;

  DiscoveryMainPageModel getMainPageModel() => mainModelState.value;

  // int getActivityIndex() => mainModelState.value.activityPageState;
  // int getContentIndex() => mainModelState.value.contentsPageState;
  // int getEcouponIndex() => mainModelState.value.ecouponPageState;

  void dispose() {
    mainModelState.close();
  }

  void changeOuterPageState(int index, String id) {
    model.outerPageState = index;
    model.outerPageId = id;
    mainModelState.add(model);
  }

  void changeInnerPageState(int index, String id) {
    model.innerPageState = index;
    model.innerPageId = id;
    mainModelState.add(model);
  }

  // void changeActivityPageState(int index, String id) {
  //   model.activityPageState = index;
  //   model.activityPageStateId = id;
  //   mainModelState.add(model);
  // }

  // void changeContentsPageState(int index, String id) {
  //   model.contentsPageState = index;
  //   model.contentsPageStateId = id;
  //   mainModelState.add(model);
  // }

  // void changeEcouponPageState(int index, String id) {
  //   model.ecouponPageState = index;
  //   model.ecouponPageStateId = id;
  //   mainModelState.add(model);
  // }

}

class DiscoveryMainPageModel {
  DiscoveryMainPageModel({
    this.outerPageState = 0,
    this.outerPageId,
    this.innerPageId,
    this.innerPageState = 0,
    // this.activityPageStateId,
    // this.contentsPageStateId,
    // this.ecouponPageStateId
  });

  String innerPageId;
  int innerPageState;
  String outerPageId; //클릭된 카테고리 아이디
  int outerPageState;

  // int activityPageState;
  // String activityPageStateId;
  // int contentsPageState;
  // String contentsPageStateId;
  // int ecouponPageState;
  // String ecouponPageStateId;

}
