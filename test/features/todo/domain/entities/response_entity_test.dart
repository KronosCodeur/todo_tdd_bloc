import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_tdd_bloc/features/todo/domain/entities/response_entity.dart';

void main() {
  group('Response Entity', () {
    test('should be a subclass of Equatable', () {
      final response = ResponseEntity<bool>(
        success: true,
        message: 'Success',
        data: true,
      );
      expect(response, isA<Equatable>());
    });
    test('two responses with same properties should be equal', () {
      final response1 = ResponseEntity<bool>(
        success: true,
        message: 'Success',
        data: false,
      );
      final response2 = ResponseEntity<bool>(
        success: true,
        message: 'Success',
        data: false,
      );
      expect(response1, equals(response2));
    });
    test('response data type must be the  same as specified', () {
      final response = ResponseEntity<int>(
        success: true,
        message: 'Success',
        data: 42,
      );
      final responseString = ResponseEntity<String>(
        success: true,
        message: 'Success',
        data: 'Hello',
      );
      expect(response.data, isA<int>());
      expect(responseString.data, isA<String>());
    });
  });
}
