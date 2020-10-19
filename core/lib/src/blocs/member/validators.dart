import 'dart:async';

import '../../states/base.dart';

class Validators {
  final StreamTransformer<StateEventModel, StateEventModel> validatedState =
      StreamTransformer<StateEventModel, StateEventModel>.fromHandlers(
          handleData: (event, sink) {
    sink.add(event);
  });

  final StreamTransformer<String, String> validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('이메일 형식이 올바르지 않습니다.');
    }
  });

  final StreamTransformer<String, String> validateKeyword =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (keyword, sink) {
    sink.add(keyword);
  });

  final StreamTransformer<String, String> validatePassword =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (password, sink) {
    if (password.length > 3) {
      sink.add(password);
    } else {
      sink.addError('4글자 이상을 입력하세요.');
    }
  });

  final StreamTransformer<StateEvent, StateEvent> validateState =
      StreamTransformer<StateEvent, StateEvent>.fromHandlers(
          handleData: (event, sink) {
    sink.add(event);
  });
}
