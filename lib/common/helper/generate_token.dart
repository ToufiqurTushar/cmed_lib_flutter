import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
/// Generates a custom registration token equivalent to the JS implementation
String generateRegistrationClientToken({
  required String username,
}) {
  final secret = "0cd4b6030185a512b93e23824150aab2";
  // 1. Get current timestamp in milliseconds
  final int issuedAtMillis = DateTime.now().millisecondsSinceEpoch;
  // 2. Generate a 24-character random nonce
  final String nonce = _generateRandomNonce(24);
  // 3. Normalize username (trim and lowercase)
  final String normalizedUsername = username.trim().toLowerCase();
  // 4. Create the payload string
  final String payload = "$normalizedUsername.$issuedAtMillis.$nonce";
  // 5. Generate HMAC-SHA256 Signature
  final List<int> keyBytes = utf8.encode(secret);
  final List<int> payloadBytes = utf8.encode(payload);

  final hmacSha256 = Hmac(sha256, keyBytes);
  final digest = hmacSha256.convert(payloadBytes);
  // 6. Encode signature to Base64Url and remove padding
  final String signature = base64Url.encode(digest.bytes).replaceAll('=', '');
  // 7. Return the final token
  return "v1.$issuedAtMillis.$nonce.$signature";
}
/// Helper to generate a random alphanumeric string
String _generateRandomNonce(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final Random rnd = Random.secure();
  return List.generate(length, (index) => chars[rnd.nextInt(chars.length)]).join();
}
