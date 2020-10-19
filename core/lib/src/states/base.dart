enum StateEvent { Normal, Logging, Success, Failed }
enum DataStateEvent { Normal, Logging, Success, Failed }

class StateEventModel {
  StateEventModel({
    this.data,
    this.event,
  });

  String data;
  StateEvent event;
}
