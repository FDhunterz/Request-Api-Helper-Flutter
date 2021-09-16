import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart' show BuildContext;
import 'package:request_api_helper/model/redirect_helper.dart';

enum RESTAPI { POST, GET, PUT, DELETE, PATCH }
BuildContext? currentContext;

// example https://this.com/api/
String? _url;

// example https://this.com/
String? _noapiurl;

// config Request
String? _errorMessage;
String? _successMessage;
bool? _logResponse;
bool? _exception;
Redirects? _timeoutRedirect;
Redirects? _socketRedirect;
Duration? _timeout;
String? _timeoutMessage;
String? _socketMessage;
Function(TimeoutException)? _onTimeout;
Function(SocketException)? _onSocket;
Function(dynamic data)? _onCompleteRawRespose;
Future? _beforeSend;
Function(Object e)? _onException;
Function(dynamic response)? _onSuccess;
Function(int code, dynamic data)? _onError;
Redirects? _authErrorRedirect;
Redirects? _withLoading;
String? _version;

class RequestApiHelperConfig {
  static load({RequestApiHelperConfigData? config}) {
    return RequestApiHelperConfigData(
      authErrorRedirect: config != null ? config.authErrorRedirect ?? _authErrorRedirect : _authErrorRedirect,
      beforeSend: config != null ? config.beforeSend ?? _beforeSend : _beforeSend,
      errorMessage: config != null ? config.errorMessage ?? _errorMessage : _errorMessage,
      exception: config != null ? config.exception ?? _exception : _exception,
      logResponse: config != null ? config.logResponse ?? _logResponse : _logResponse,
      noapiurl: config != null ? config.noapiurl ?? _noapiurl : _noapiurl,
      onCompleteRawRespose: config != null ? config.onCompleteRawRespose ?? _onCompleteRawRespose : _onCompleteRawRespose,
      onError: config != null ? config.onError ?? _onError : _onError,
      onException: config != null ? config.onException ?? _onException : _onException,
      onSocket: config != null ? config.onSocket ?? _onSocket : _onSocket,
      onSuccess: config != null ? config.onSuccess ?? _onSuccess : _onSuccess,
      onTimeout: config != null ? config.onTimeout ?? _onTimeout : _onTimeout,
      socketMessage: config != null ? config.socketMessage ?? _socketMessage : _socketMessage,
      socketRedirect: config != null ? config.socketRedirect ?? _socketRedirect : _socketRedirect,
      successMessage: config != null ? config.successMessage ?? _successMessage : _successMessage,
      timeout: config != null ? config.timeout ?? _timeout : _timeout,
      timeoutMessage: config != null ? config.timeoutMessage ?? _timeoutMessage : _timeoutMessage,
      timeoutRedirect: config != null ? config.timeoutRedirect ?? _timeoutRedirect : _timeoutRedirect,
      url: config != null ? config.url ?? _url : _url,
      version: config != null ? config.version ?? _version : _version,
      withLoading: config != null ? config.withLoading ?? _withLoading : _withLoading,
    );
  }

  static save(RequestApiHelperConfigData config) {
    // example https://this.com/api/
    _url = config.url;

    // example https://this.com/
    _noapiurl = config.noapiurl;

    // config Request
    _errorMessage = config.errorMessage;
    _successMessage = config.successMessage;
    _logResponse = config.logResponse;
    _exception = config.exception;
    _timeoutRedirect = config.timeoutRedirect;
    _socketRedirect = config.socketRedirect;
    _timeout = config.timeout;
    _timeoutMessage = config.timeoutMessage;
    _socketMessage = config.socketMessage;
    _onTimeout = config.onTimeout;
    _onSocket = config.onSocket;
    _onCompleteRawRespose = config.onCompleteRawRespose;
    _beforeSend = config.beforeSend;
    _onException = config.onException;
    _onSuccess = config.onSuccess;
    _onError = config.onError;
    _authErrorRedirect = config.authErrorRedirect;
    _withLoading = config.withLoading;
    _version = config.version;
  }
}

class RequestApiHelperConfigData {
  // example https://this.com/api/
  String? url;

// example https://this.com/
  String? noapiurl;

// config Request
  String? errorMessage;
  String? successMessage;
  bool? logResponse;
  bool? exception;
  Redirects? timeoutRedirect;
  Redirects? socketRedirect;
  Duration? timeout;
  String? timeoutMessage;
  String? socketMessage;
  Function(TimeoutException)? onTimeout;
  Function(SocketException)? onSocket;
  Function(dynamic data)? onCompleteRawRespose;
  Future? beforeSend;
  Function(Object e)? onException;
  Function(dynamic response)? onSuccess;
  Function(int code, dynamic data)? onError;
  Redirects? authErrorRedirect;
  Redirects? withLoading;
  String? version;

  RequestApiHelperConfigData({
    this.authErrorRedirect,
    this.beforeSend,
    this.errorMessage,
    this.exception,
    this.logResponse,
    this.noapiurl,
    this.onCompleteRawRespose,
    this.onError,
    this.onException,
    this.onSocket,
    this.onSuccess,
    this.onTimeout,
    this.socketMessage,
    this.socketRedirect,
    this.successMessage,
    this.timeout,
    this.timeoutMessage,
    this.timeoutRedirect,
    this.url,
    this.version,
    this.withLoading,
  });
}

class RequestFileData {
  List<String> filePath, fileRequestName;

  RequestFileData({required this.filePath, required this.fileRequestName});
}

class RequestData {
  Map<String, dynamic>? body;

  /// only used for type POST request
  RequestFileData? file;
  RequestData({this.body, this.file});
}

class CustomRequestData {
  Map<String, dynamic>? body;
  Map<String, String>? header;
  String? url;

  /// only used for type POST request
  RequestFileData? file;
  CustomRequestData({this.body, this.header, this.url, this.file});
}