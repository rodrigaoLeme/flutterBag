import 'package:ebolsaapp/share/utils/jwt_decoder.dart';
import 'package:flutter_test/flutter_test.dart';

const _tokenValid = 'eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9'
    '.eyJzdWIiOiAidXNlci0xMjMiLCAibmFtZSI6ICJSb2RyaWdvIExlbWUiLCAiZW1haWwiOiAicm9kcmlnb0B0ZXN0LmNvbSIsICJleHAiOiAxNzc2MzY1ODQ5fQ'
    '.fakesignature';

const _tokenExpired = 'eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9'
    '.eyJzdWIiOiAidXNlci00NTYiLCAibmFtZSI6ICJUZXN0IFVzZXIiLCAiZW1haWwiOiAidGVzdEB0ZXN0LmNvbSIsICJleHAiOiAxNzc2MzU4NjQ5fQ'
    '.fakesignature';

const _tokenNoExp = 'eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9'
    '.eyJzdWIiOiAidXNlci03ODkiLCAibmFtZSI6ICJObyBFeHAiLCAiZW1haWwiOiAibm9leHBAdGVzdC5jb20ifQ'
    '.fakesignature';

const _tokenExtraFields = 'eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9'
    '.eyJzdWIiOiAidXNlci05OTkiLCAibmFtZSI6ICJFeHRyYSIsICJlbWFpbCI6ICJleHRyYUB0ZXN0LmNvbSIsICJleHAiOiAxNzc2MzY5NDQ5LCAicm9sZSI6ICJhZG1pbiIsICJjdXN0b20iOiA0Mn0'
    '.fakesignature';

void main() {
  group('JwtDecoder.decode', () {
    test('retorna payload correto de token válido', () {
      final payload = JwtDecoder.decode(_tokenValid);

      expect(payload['sub'], equals('user-123'));
      expect(payload['name'], equals('Rodrigo Leme'));
      expect(payload['email'], equals('rodrigo@test.com'));
      expect(payload['exp'], isA<int>());
    });

    test('retorna payload de token sem campo exp', () {
      final payload = JwtDecoder.decode(_tokenNoExp);

      expect(payload['sub'], equals('user-789'));
      expect(payload.containsKey('exp'), isFalse);
    });

    test('retorna campos extras corretamente', () {
      final payload = JwtDecoder.decode(_tokenExtraFields);

      expect(payload['role'], equals('admin'));
      expect(payload['custom'], equals(42));
    });

    test('lança FormatException para token com menos de 3 partes', () {
      expect(
        () => JwtDecoder.decode('parteUm.parteDois'),
        throwsA(isA<FormatException>()),
      );
    });

    test('lança FormatException para token com mais de 3 partes', () {
      expect(
        () => JwtDecoder.decode('a.b.c.d'),
        throwsA(isA<FormatException>()),
      );
    });

    test('lança FormatException para token com payload inválido', () {
      expect(
        () => JwtDecoder.decode('header.nao_e_base64_valido!!.sig'),
        throwsA(isA<FormatException>()),
      );
    });

    test('lança FormatException para string vazia', () {
      expect(
        () => JwtDecoder.decode(''),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('JwtDecoder.isExpired', () {
    test('retorna false para token válido (exp no futuro)', () {
      expect(JwtDecoder.isExpired(_tokenValid), isFalse);
    });

    test('retorna true para token expirado (exp no passado)', () {
      expect(JwtDecoder.isExpired(_tokenExpired), isTrue);
    });

    test('retorna false para token sem campo exp', () {
      expect(JwtDecoder.isExpired(_tokenNoExp), isFalse);
    });

    test('retorna true para token malformado', () {
      expect(JwtDecoder.isExpired('token.invalido'), isTrue);
    });

    test('retorna true para string vazia', () {
      expect(JwtDecoder.isExpired(''), isTrue);
    });
  });
}
