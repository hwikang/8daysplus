import '../../../core.dart';
import '../../models/purchase/create_order_input_model.dart';
import '../../models/purchase/create_order_prepare_model.dart';
import '../../models/purchase/order_info_request_model.dart';
import '../../providers/purchase/create_order_prepare_provider.dart';

class CreateOrderPrepareBloc {
  CreateOrderPrepareBloc(
      {this.inputModel = const CreateOrderInputModel(
        fields: <OrderInfoFieldModel>[],
        options: <OrderInfoOptionsModel>[],
      )}) {
    print('init prepare bloc');
  }

  CreateOrderInputModel inputModel;

  final CreateOrderPrepareProvider _createOrderPrepareProvider =
      CreateOrderPrepareProvider();

  Future<CreateOrderPrepareModel> createOrderPrepare() {
    return _createOrderPrepareProvider
        .createOrderPrepare(inputModel)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
