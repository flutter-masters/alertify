import 'package:flutter/material.dart';

import '../failures/failure.dart';
import 'result.dart';

typedef Json = Map<String, dynamic>;
typedef FutureAuthResult<T, E> = Future<Result<T, E>>;
typedef FutureResult<T> = Future<Result<T, Failure>>;
typedef UserListItemBuilder<T> = Widget Function(BuildContext, T);
