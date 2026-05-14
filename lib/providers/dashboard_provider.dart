import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import '../models/file_preview.dart';
import '../models/transaction_report.dart';
import '../services/api_service.dart';

enum DashboardState { idle, loading, success, error }

class DashboardProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  DashboardState _state = DashboardState.idle;
  TransactionReport? _report;
  FilePreview? _preview;
  String _errorMessage = '';
  String _uploadedFileName = '';

  DashboardState get state       => _state;
  TransactionReport? get report  => _report;
  FilePreview? get preview       => _preview;
  String get errorMessage        => _errorMessage;
  String get uploadedFileName    => _uploadedFileName;

  bool get hasData   => _report != null;
  bool get isLoading => _state == DashboardState.loading;

  /// Works on all platforms — always receives bytes from file_picker
  Future<void> uploadFileBytes(List<int> bytes, String fileName) async {
    _state = DashboardState.loading;
    _errorMessage = '';
    _uploadedFileName = fileName;
    notifyListeners();

    try {
      final content = utf8.decode(bytes, allowMalformed: true);
      _preview = _parsePreview(content);
      _report  = await _apiService.uploadAndAnalyzeBytes(bytes, fileName);
      _state   = DashboardState.success;
    } catch (e) {
      _state        = DashboardState.error;
      _errorMessage = _parseError(e);
    }

    notifyListeners();
  }

  FilePreview _parsePreview(String content) {
    final rows = const CsvToListConverter(eol: '\n').convert(content);
    if (rows.isEmpty) return FilePreview(headers: [], rows: [], totalRows: 0);

    final headers = rows.first.map((e) => e.toString()).toList();
    final dataRows = rows.skip(1).take(10).map((row) =>
      row.map((cell) {
        final s = cell.toString();
        return s.length > 60 ? '${s.substring(0, 57)}...' : s;
      }).toList()
    ).toList();

    return FilePreview(headers: headers, rows: dataRows, totalRows: rows.length - 1);
  }

  void reset() {
    _state          = DashboardState.idle;
    _report         = null;
    _preview        = null;
    _errorMessage   = '';
    _uploadedFileName = '';
    notifyListeners();
  }

  String _parseError(dynamic e) {
    if (e is Exception) {
      final msg = e.toString();
      if (msg.contains('SocketException') || msg.contains('Connection refused')) {
        return 'Cannot connect to server. Make sure the backend is running.';
      }
      if (msg.contains('TimeoutException')) {
        return 'Request timed out. The file may be too large.';
      }
      return msg.replaceAll('Exception: ', '');
    }
    return 'An unexpected error occurred.';
  }
}
