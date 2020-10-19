import '../../../core.dart';
import '../../providers/kakao_channel_provider.dart';

class KakaoChannelBloc {
  final KakaoChannelProvider kakaoProvider = KakaoChannelProvider();

  Future<String> getKakaoChannelURL() {
    return kakaoProvider
        .getKakaoChannelURL()
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
