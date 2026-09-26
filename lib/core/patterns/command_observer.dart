import 'package:medquest/core/failure/failure.dart';

import 'command.dart';
import 'result.dart';
import 'package:signals_flutter/signals_flutter.dart';



void observeCommand<T>(
  Command<T, Failure> command, {
  required void Function() clearMessage, //função nova
  required void Function(String) setMessage, //função nova
  required void Function(T data) onSuccess,
  void Function(Failure err)? onFailure,
}) {
  effect(() {
    if (command.isExecuting.value) return;

    final result = command.result.value;
    if (result == null) return;

    result.fold(
      onSuccess: (data) {
        clearMessage();
        onSuccess(data);
        command.clear();
      },
      onFailure: (err) {
        setMessage(err.msg);
        onFailure?.call(err);
        command.clear();
      },
    );
  });
}



/// Helpers para executar/observar comandos e propagar efeitos colaterais
/// (resultado e mensagens) de forma padronizada.
///
/// Uso típico:
/// ```dart
/// final res = await observeCommand(command,
///   resultSignal: someSignal,
///   message: messageSignal,
/// );
/// ```
// Future<Result<Success, Error>> observeCommand<Success, Error>(
//   Command<Success, Error> command, {

//   /// Opcional: sinal que receberá o `Result` retornado pelo comando
//   Signal<Result<Success, Error>?>? resultSignal,

//   /// Opcional: sinal que receberá a mensagem de erro (se houver)
//   Signal<String?>? message,
// }) async {
//   final res = await command.call();

//   if (resultSignal != null) {
//     resultSignal.value = res;
//   }

//   if (res.isFailure && message != null) {
//     // Apenas convertemos o valor de erro para string; o chamador pode
//     // escolher formatar de outra forma se precisar do tipo concreto.
//     message.value = res.failureValueOrNull?.toString();
//   }

//   return res;
// }

// /// Versão para `ParameterizedCommand` que recebe o parâmetro e executa
// Future<Result<Success, Error>> observeCommandWith<Success, Error, P>(
//   ParameterizedCommand<Success, Error, P> command,
//   P parameter, {
//   Signal<Result<Success, Error>?>? resultSignal,
//   Signal<String?>? message,
// }) async {
//   final res = await command.executeWith(parameter);

//   if (resultSignal != null) {
//     resultSignal.value = res;
//   }

//   if (res.isFailure && message != null) {
//     message.value = res.failureValueOrNull?.toString();
//   }

//   return res;
// }
