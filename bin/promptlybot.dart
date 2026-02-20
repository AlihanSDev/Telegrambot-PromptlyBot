import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:teledart/src/telegram/model.dart';

Future<void> main() async {
  final env = dotenv.DotEnv(includePlatformEnvironment: true)..load();
  final token = env['TELEGRAM_TOKEN'];
  if (token == null || token.isEmpty) {
    print('Please set TELEGRAM_TOKEN in .env');
    return;
  }
  final tg = Telegram(token);
  final me = await tg.getMe();
  final username = me.username ?? 'bot';

  final teledart = TeleDart(token, Event(username));
  teledart.start();

  teledart.onCommand('start').listen((message) {
    final keyboard = ReplyKeyboardMarkup(
      keyboard: [
        [KeyboardButton(text: 'Старт')]
      ],
      resizeKeyboard: true,
    );

    teledart.sendMessage(
      message.chat.id,
      'Привет! Нажми кнопку ниже:',
      replyMarkup: keyboard,
    );
  });

  teledart.onMessage().listen((message) {
    final text = message.text ?? '';
    if (text.trim().toLowerCase() == 'старт') {
      teledart.sendMessage(message.chat.id, 'Кнопка "Старт" нажата');
    }
  });
}
