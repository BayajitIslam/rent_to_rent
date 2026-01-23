import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

class PdfViewerWidget extends StatefulWidget {
  final String pdfUrl;
  final double? height;

  const PdfViewerWidget({required this.pdfUrl, this.height, super.key});

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  PdfControllerPinch? pdfController;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  Future<void> _initializePdf() async {
    // Check if URL is empty
    if (widget.pdfUrl.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'PDF URL is empty';
      });
      return;
    }

    // Validate URL
    final uri = Uri.tryParse(widget.pdfUrl);
    if (uri == null || !uri.hasScheme) {
      setState(() {
        isLoading = false;
        errorMessage = 'Invalid PDF URL';
      });
      return;
    }

    try {
      final pdfData = await _fetchPdfContent(widget.pdfUrl);

      if (!mounted) return;

      pdfController = PdfControllerPinch(
        document: PdfDocument.openData(Future.value(pdfData)),
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<Uint8List> _fetchPdfContent(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load PDF. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('PDF Load Error: $e');
      rethrow;
    }
  }

  @override
  void didUpdateWidget(covariant PdfViewerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload if URL changes
    if (oldWidget.pdfUrl != widget.pdfUrl) {
      pdfController?.dispose();
      pdfController = null;
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      _initializePdf();
    }
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height ?? 585.h,
      decoration: BoxDecoration(
        // color: Colors.grey[100],
        // borderRadius: BorderRadius.circular(12.r),
        // border: Border.all(color: Colors.grey[300]!),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    // Loading state
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading PDF...'),
          ],
        ),
      );
    }

    // Error state
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48.sp, color: Colors.red[400]),
              SizedBox(height: 16.h),
              Text(
                'Failed to load PDF',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[600],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  _initializePdf();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // PDF controller not ready
    if (pdfController == null) {
      return const Center(child: Text('No PDF to display'));
    }

    // PDF View
    return PdfViewPinch(
      backgroundDecoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: 0,
      maxScale: 1,
      minScale: 1,
      controller: pdfController!,
      builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
        options: const DefaultBuilderOptions(),
        documentLoaderBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
        pageLoaderBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
        errorBuilder: (_, error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 40.sp),
              SizedBox(height: 8.h),
              Text(
                'Error loading page',
                style: TextStyle(color: Colors.red[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
