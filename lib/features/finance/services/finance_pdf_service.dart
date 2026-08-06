import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/finance_item_model.dart';

/// 👑 PRO kullanıcılar için PDF Finans & Nakit Akış Raporu Oluşturucu Servis.
class FinancePdfService {
  static Future<void> generateAndPrintReport({
    required List<FinanceItemModel> items,
    required double totalIncome,
    required double totalExpenses,
    required double netCashFlow,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Üst Başlık & Tarih
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Ev Asistani - Finans ve Nakit Akis Raporu',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    DateTime.now().toString().split(' ').first,
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Özet Paneli
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Column(
                    children: [
                      pw.Text('Toplam Gelir', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text('+TL ${totalIncome.toStringAsFixed(0)}', style: const pw.TextStyle(color: PdfColors.green700)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text('Toplam Gider', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text('-TL ${totalExpenses.toStringAsFixed(0)}', style: const pw.TextStyle(color: PdfColors.red700)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text('Net Serbest Bütce', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'TL ${netCashFlow.toStringAsFixed(0)}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: netCashFlow >= 0 ? PdfColors.green800 : PdfColors.red800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // Detay Tablosu
            pw.Text(
              'Islem Detaylari (${items.length} Kalem)',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),

            pw.TableHelper.fromTextArray(
              headers: ['Islem Basligi', 'Tur', 'Kategori', 'Tutar', 'Durum', 'Tarih'],
              data: items.map((item) {
                return [
                  item.title,
                  item.type == FinanceType.income ? 'Gelir' : 'Gider',
                  item.category.label,
                  'TL ${item.amount.toStringAsFixed(0)}',
                  item.isPaid ? 'Odendi' : 'Bekliyor',
                  item.formattedDueDate,
                ];
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
              cellHeight: 24,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.center,
                5: pw.Alignment.center,
              },
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Ev_Asistani_Finans_Raporu.pdf',
    );
  }
}
