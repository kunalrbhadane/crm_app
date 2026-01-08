import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/enquiry_model.dart';

class PdfExportService {
  
  /// Main function to generate and open the PDF
  static Future<void> generateAndPrintPdf({
    required List<EnquiryModel> data,
    required String timeFilter,
    required String typeFilter,
  }) async {
    final pdf = pw.Document();
    
    // Define the font (Standard Helvetica is built-in)
    final font = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();

    // Max rows per page is handled automatically by pw.MultiPage, 
    // but the table headers need to repeat.
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
        ),
        build: (pw.Context context) {
          return [
            _buildHeader(),
            pw.SizedBox(height: 20),
            _buildFilterSection(timeFilter, typeFilter),
            pw.SizedBox(height: 20),
            _buildTable(data, font, fontBold),
            pw.SizedBox(height: 20),
            _buildTotal(data.length),
          ];
        },
      ),
    );

    // Open the Print/Share Preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Enquiry_Report_${DateFormat('yyyyMMdd').format(DateTime.now())}',
    );
  }

  // 1. Header Section
  static pw.Widget _buildHeader() {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(now);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            'Enquiry Report',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Generated on: $formattedDate',
          style: const pw.TextStyle(fontSize: 12),
        ),
        pw.Divider(thickness: 1),
      ],
    );
  }

  // 2. Applied Filters Section
  static pw.Widget _buildFilterSection(String timeFilter, String typeFilter) {
    return pw.Container(
      alignment: pw.Alignment.centerLeft,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Applied Filters:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
          ),
          pw.SizedBox(height: 5),
          pw.Text('• Time Period: $timeFilter'),
          pw.Text('• Type: $typeFilter'),
          pw.Text('• Course: All Courses'), // Static based on current UI not having course filter
          pw.Text('• Service: All Services'),
        ],
      ),
    );
  }

  // 3. Data Table
  static pw.Widget _buildTable(List<EnquiryModel> data, pw.Font font, pw.Font fontBold) {
    // Define Headers
    final headers = [
      'Name',
      'Contact',
      'Type',
      'Course/Service',
      'Added By',
      'Date'
    ];

    // Map Data
    final rows = data.map((e) {
      final date = DateTime.tryParse(e.createdAt) ?? DateTime.now();
      final dateStr = DateFormat('dd/MM/yyyy').format(date);

      return [
        e.name,
        e.phone,
        e.enquiryType,
        e.courseOrService,
        e.addedByName ?? '-', // Fallback if API missing field
        dateStr,
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows,
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 25,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerLeft,
        5: pw.Alignment.center,
      },
      headerPadding: const pw.EdgeInsets.all(5),
      cellPadding: const pw.EdgeInsets.all(5),
    );
  }

  // 4. Footer Total
  static pw.Widget _buildTotal(int count) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Text(
        'Total Enquiries: $count',
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }
}