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
        [KeyboardButton(text: 'Старт')],
        [
          KeyboardButton(text: 'Тест 1'),
          KeyboardButton(text: 'Тест 2'),
          KeyboardButton(text: 'Тест 3'),
        ]
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
    } else if (text.trim().toLowerCase() == 'тест 1') {
      teledart.sendMessage(message.chat.id, 'Нажата Тест 1');
    } else if (text.trim().toLowerCase() == 'тест 2') {
      teledart.sendMessage(message.chat.id, 'Нажата Тест 2');
    } else if (text.trim().toLowerCase() == 'тест 3') {
      teledart.sendMessage(message.chat.id, 'Нажата Тест 3');
    }
  });
}
