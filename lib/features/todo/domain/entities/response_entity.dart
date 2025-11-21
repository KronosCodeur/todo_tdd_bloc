import 'package:equatable/equatable.dart';

class ResponseEntity<T> extends Equatable {
  final bool success;
  final String message;
  final T data;

  const ResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [success, message, data];
}
