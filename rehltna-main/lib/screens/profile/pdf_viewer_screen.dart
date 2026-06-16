import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.url,
    this.title = 'وثيقة PDF',
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  String? _localPath;
  bool _isChecking = true;
  bool _isDownloading = false;
  double _progress = 0;
  String _downloadedMB = '0';
  String _totalMB = '?';
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    _checkCache();
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }

  String _cacheFileName() {
    final name = widget.url.split('/').last.split('?').first;
    return name.isEmpty ? 'document.pdf' : name;
  }

  Future<File> _cacheFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final pdfsDir = Directory('${dir.path}/pdfs');
    if (!await pdfsDir.exists()) await pdfsDir.create(recursive: true);
    return File('${pdfsDir.path}/${_cacheFileName()}');
  }

  Future<void> _checkCache() async {
    try {
      final file = await _cacheFile();
      if (await file.exists() && await file.length() > 0) {
        if (mounted) setState(() { _localPath = file.path; _isChecking = false; });
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _isChecking = false);
  }

  Future<void> _downloadPdf() async {
    setState(() { _isDownloading = true; _progress = 0; _downloadedMB = '0'; _totalMB = '?'; });
    _cancelToken = CancelToken();

    try {
      final file = await _cacheFile();
      final dio = Dio();

      await dio.download(
        widget.url,
        file.path,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (!mounted) return;
          setState(() {
            _downloadedMB = (received / 1048576).toStringAsFixed(1);
            if (total > 0) {
              _progress = received / total;
              _totalMB = (total / 1048576).toStringAsFixed(1);
            }
          });
        },
      );

      if (mounted) setState(() { _localPath = file.path; _isDownloading = false; });
    } on DioException catch (e) {
      if (mounted && e.type != DioExceptionType.cancel) {
        setState(() => _isDownloading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل التحميل، تحقق من الاتصال وحاول مرة أخرى')),
        );
      }
    }
  }

  void _cancelDownload() {
    _cancelToken?.cancel();
    if (mounted) setState(() => _isDownloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_localPath != null)
            IconButton(
              icon: const Icon(Icons.bookmark_outline_rounded),
              tooltip: 'إشارة مرجعية',
              onPressed: () => _pdfViewerKey.currentState?.openBookmarkView(),
            ),
        ],
      ),
      body: _isChecking
          ? const Center(child: CircularProgressIndicator())
          : _localPath != null
              ? SfPdfViewer.file(
                  File(_localPath!),
                  key: _pdfViewerKey,
                  canShowScrollHead: true,
                  canShowScrollStatus: true,
                  enableDoubleTapZooming: true,
                  enableTextSelection: true,
                )
              : _isDownloading
                  ? _buildDownloadProgress()
                  : _buildDownloadButton(),
    );
  }

  Widget _buildDownloadButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.picture_as_pdf_rounded, size: 56, color: Colors.red.shade400),
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'الملف غير محمَّل بعد. اضغط لتحميله وعرضه داخل التطبيق.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _downloadPdf,
                icon: const Icon(Icons.download_rounded),
                label: const Text('تحميل الوثيقة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadProgress() {
    final pct = (_progress * 100).toStringAsFixed(0);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: _progress > 0 ? _progress : null,
                    strokeWidth: 6,
                    color: Colors.red.shade500,
                    backgroundColor: Colors.red.shade100,
                  ),
                ),
                Text(
                  _progress > 0 ? '$pct%' : '...',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'جارٍ التحميل...',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _totalMB != '?' ? '$_downloadedMB MB / $_totalMB MB' : '$_downloadedMB MB',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            if (_progress > 0)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8,
                  color: Colors.red.shade500,
                  backgroundColor: Colors.red.shade100,
                ),
              ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: _cancelDownload,
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('إلغاء'),
              style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
