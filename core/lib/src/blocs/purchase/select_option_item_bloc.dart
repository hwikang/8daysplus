import 'package:rxdart/rxdart.dart';

import '../../../core.dart';

class SelectOptionItemBloc {
  SelectOptionItemBloc() {
    selectedOptionCount.add(selectedOptionCountModel);
  }

  final BehaviorSubject<bool> isSelectedTimeSlot =
      BehaviorSubject<bool>(); //타임슬롯 선택여부(없는것은 바로 true)

  List<OrderProductOptionModel> selectedOption = <OrderProductOptionModel>[];
  BehaviorSubject<SelectedOptionCountModel> selectedOptionCount =
      BehaviorSubject<SelectedOptionCountModel>();

  SelectedOptionCountModel selectedOptionCountModel =
      SelectedOptionCountModel(); //선택한 option,갯수

  final BehaviorSubject<String> timeSlotIdController =
      BehaviorSubject<String>();

  void addOption(
      String optionId, String optionItemId, int amount, int salePrice) {
    print(salePrice);
    //이미 있는경우 지웠다다시 저장
    if (selectedOption.isNotEmpty) {
      selectedOption = selectedOption.where((option) {
        return option.optionItemId != optionItemId;
      }).toList();
    }
    if (amount == 0) {
    } else {
      final orderProductOptionModel = OrderProductOptionModel(
          //cart, order로 보낼 내용
          optionId: optionId,
          optionItemId: optionItemId,
          amount: amount,
          salePrice: salePrice,
          timeSlotId: '');

      selectedOption.add(orderProductOptionModel);
    }

    //선택 갯수, 가격
    var totalAmout = 0;
    var totalOptionCount = 0;
    selectedOption.map((option) {
      totalAmout += option.salePrice * option.amount;
      totalOptionCount += option.amount;
    }).toList();
    selectedOptionCountModel.totalAmount = totalAmout;
    selectedOptionCountModel.totalOptionCount = totalOptionCount;

    selectedOptionCount.add(selectedOptionCountModel);
  }

  void setTimeSlotIdOnSelectedOptions() {
    selectedOption.map((model) {
      model.timeSlotId = timeSlotIdController.value ?? '';
    }).toList();
  }

  void resetTimeSlotAndCount() {
    //뒤로가기 할떄 초기화
    isSelectedTimeSlot.add(false);
    // _selectCountController.add(0);
  }

  void changeTimeSlotId(String timeSlot) {
    timeSlotIdController.add(timeSlot);
  }
}

class SelectedOptionCountModel {
  SelectedOptionCountModel({
    this.totalOptionCount = 0,
    this.totalAmount = 0,
  });

  int totalAmount; //총합 가격
  int totalOptionCount; //고른 옵션들 갯수
}
