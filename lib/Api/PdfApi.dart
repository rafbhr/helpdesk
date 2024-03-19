import 'dart:io';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import '/OdooApiCall_DataMapping/ToCheckIn_ToCheckOut_SupportTicket.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../OdooApiCall_DataMapping/SupportTicket.dart';

class PdfApi {
  static Future<File> generatePDF(
    { required ByteData imageSignature, supportTicket, required ToCheckInOutSupportTicket supportticket}
  
  
  ) async {
    final document = PdfDocument();
    final page = document.pages.add();

    drawGrid(page, supportTicket );
    drawSignature(page, imageSignature);
    return saveFile (document);
  }

  static Future<File> saveFile(PdfDocument document) async {
  final path = await getApplicationDocumentsDirectory();
  final fileName =
      path.path + '/CM Form${DateTime.now().toIso8601String()}.pdf';
  final file = File(fileName); 
  //file.writeAsBytes(document.save());
  document.dispose();
  return file;
  }

  static void drawSignature (PdfPage page, ByteData imageSignature){
    final pageSize = page.getClientSize();
    final PdfBitmap image = PdfBitmap(imageSignature.buffer.asUint8List());

    page.graphics.drawImage(
      image, 
      Rect.fromLTWH(pageSize.width - 120, pageSize.height - 200, 100, 40),
      
    );
  }

  static Future<void> drawGrid(PdfPage page, SupportTicket supportTicket) async {
    
    
    //Create a string format to set text alignment
    final PdfStringFormat format = PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle);
    final PdfStringFormat middleFormat =
        PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle);

    //Create padding, borders for PDF grid
    final PdfPaddings padding = PdfPaddings(left: 2);
    final PdfPen linePen = PdfPen(PdfColor(0, 0, 0), width: 2);
    final PdfPen lastRowBorderPen = PdfPen(PdfColor(0, 0, 0), width: 1);
    final PdfBorders borders = PdfBorders(
        left: linePen, top: linePen, bottom: linePen, right: linePen);
    final PdfBorders lastRowBorder = PdfBorders(
        left: linePen,
        top: linePen,
        bottom: lastRowBorderPen,
        right: linePen);

    //Create a new font
    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 11);

    //Drawing the grid as two seperate grids

    //Create a grid
    final PdfGrid headerGrid = PdfGrid();
    //Set font for all cells
    headerGrid.style.font = font;
    //Add columns
    headerGrid.columns.add(count: 3);
    //Set column width
    headerGrid.columns[0].width = 80;
    headerGrid.columns[2].width = 80;
    //Add a row
    final PdfGridRow headerRow1 = headerGrid.rows.add();
    //Set row height

    //Draw the image
    //page.graphics.drawImage(
    //    PdfBitmap(File('image.jpg').readAsBytesSync()),
    //    Rect.fromLTWH(
    //        0, 0, page.getClientSize().width, page.getClientSize().height));

    headerRow1.height = 70;
    //Add cell value and style properties
    //headerRow1.cells[0].value = 'COMPANY LOGO (ROUND)';

    //TODO change path to relative path later lib/api/round_sigma.jpeg
    //headerRow1.cells[0].value = PdfBitmap(File('/home/hafiz/Documents/flutter_login_ui-main/lib/api/round_sigma.jpeg').readAsBytesSync());
    final sigmalogo = await rootBundle.load('assets/images/round_sigma.jpeg');
   

    //headerRow1.cells[0].value = PdfBitmap(File('Company Logo').readAsBytesSync());
    headerRow1.cells[0].value =  PdfBitmap(sigmalogo.buffer.asUint8List());
    headerRow1.cells[0].style.stringFormat = format;
    headerRow1.cells[1].value = 'Corrective Maintenance Form'; 
    headerRow1.cells[1].style.font = PdfStandardFont(PdfFontFamily.helvetica, 20);
    headerRow1.style.backgroundBrush = PdfSolidBrush(PdfColor(255, 153, 51));
    headerRow1.cells[1].style.stringFormat = format;
    headerRow1.cells[1].columnSpan = 2;
    final PdfGridRow headerRow2 = headerGrid.rows.add();
    headerRow2.cells[0].value = '';
    headerRow2.cells[0].columnSpan = 3;
    headerRow2.height = 15;
    final PdfGridRow headerRow3 = headerGrid.rows.add();
    headerRow3.cells[0].value = 'Customer Name:';
    headerRow3.cells[0].style.stringFormat = middleFormat;
    headerRow3.cells[0].style.cellPadding = padding;
    headerRow3.cells[2].value = 'Date: ' + DateTime.now().toIso8601String(); //TODO change date to editable from cm form page
    headerRow3.cells[2].style.stringFormat = middleFormat;
    headerRow3.cells[2].style.cellPadding = padding;
    final PdfGridRow headerRow4 = headerGrid.rows.add();
    headerRow4.cells[0].value = '';
    headerRow4.cells[0].columnSpan = 3;
    headerRow4.height = 25;
    //Set border for all rows
    for (int i = 0; i < headerGrid.rows.count; i++) {
      final PdfGridRow headerRow = headerGrid.rows[i];
      if (i == headerGrid.rows.count - 1) {
        for (int j = 0; j < headerRow.cells.count; j++) {
          headerRow.cells[j].style.borders = lastRowBorder;
        }
      } else {
        for (int j = 0; j < headerRow.cells.count; j++) {
          headerRow.cells[j].style.borders = borders;
        }
      }
    }
    //Draw grid and get drawn bounds
    final PdfLayoutResult? result =
        headerGrid.draw(page: page, bounds: const Rect.fromLTWH(1, 1, 0, 0));

    //Create a new grid
    PdfGrid contentGrid = PdfGrid();
    contentGrid.style.font = font;
    contentGrid.columns.add(count: 4);
    //Add grid header
    contentGrid.headers.add(1);
    contentGrid.columns[0].width = 40;
    contentGrid.columns[1].width = 140;
    contentGrid.columns[3].width = 80;
    //Get header and set values
    final PdfGridRow contentHeader = contentGrid.headers[0];
    contentHeader.cells[0].value = 'SR NO';
    contentHeader.cells[0].style.stringFormat = format;
    contentHeader.cells[0].style.borders = borders;
    contentHeader.cells[1].value = 'PRODUCT IMAGE';
    contentHeader.cells[1].style.stringFormat = format;
    contentHeader.cells[1].style.borders = borders;
    contentHeader.cells[2].value = 'PRODUCT DETAILS';
    contentHeader.cells[2].style.stringFormat = format;
    contentHeader.cells[2].style.borders = borders;
    contentHeader.cells[3].value = 'QUANTITY';
    contentHeader.cells[3].style.stringFormat = format;
    contentHeader.cells[3].style.borders = borders;
    //Add content rows
    contentGrid =
        await _addContentRow('1', contentGrid, format, middleFormat, padding);
    contentGrid =
        await _addContentRow('2', contentGrid, format, middleFormat, padding);

    //Add a new row
    final PdfGridRow totalRow = contentGrid.rows.add();
    totalRow.cells[0].value = 'TOTAL QUANTITY';
    //Set column span
    totalRow.cells[0].columnSpan = 3;
    totalRow.cells[0].style.stringFormat = format;
    totalRow.height = 25;
    //Set borders for all cells in grid
    for (int i = 0; i < contentGrid.rows.count; i++) {
      final PdfGridRow contentRow = contentGrid.rows[i];
      for (int j = 0; j < contentRow.cells.count; j++) {
        contentRow.cells[j].style.borders = borders;
      }
    }
    //Draw content grid based on the bounds calculated in first grid
    contentGrid.draw(
        page: result?.page,
        bounds:
            Rect.fromLTWH(1, result!.bounds.top + result.bounds.height, 0, 0));

    
    //final grid = PdfGrid();
    //grid.columns.add(count: 2);
    //final headerRow = grid.headers.add(1)[0];
    //headerRow.style.textBrush = PdfBrushes.white;
    //headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(255, 153, 51));
    //headerRow.cells[0].value = 'Fields';
    //headerRow.cells[1].value = 'Test Data';
    //final row = grid.rows.add();
    //row.cells[0].value = supportTicket.ticket_id;
    //row.cells[1].value = supportTicket.ticket_number;
    //grid.draw(page: page,
    //bounds: Rect.fromLTWH(0, 40, 0, 0)
    //)!;

  }

  //Custom method to create content row and set style properties
  static Future<PdfGrid> _addContentRow(String srNo, PdfGrid grid, PdfStringFormat format,
      PdfStringFormat middleFormat, PdfPaddings padding) async {
    //Add a row
    final PdfGridRow contentRow1 = grid.rows.add();
    //Set height
    contentRow1.height = 15;
    //Set values and style properties
    contentRow1.cells[0].value = srNo;
    contentRow1.cells[0].style.stringFormat = format;
    //Set row span
    contentRow1.cells[0].rowSpan = 6;
    contentRow1.cells[1].rowSpan = 6;
    contentRow1.cells[2].value = '';
    contentRow1.cells[3].rowSpan = 6;
    final PdfGridRow contentRow2 = grid.rows.add();
    contentRow2.cells[2].value = 'DESIGN NO-';
    contentRow2.cells[2].style.cellPadding = padding;
    contentRow2.cells[2].style.stringFormat = middleFormat;
    final PdfGridRow contentRow3 = grid.rows.add();
    contentRow3.cells[2].value = 'GROSS WEIGHT-';
    contentRow3.cells[2].style.cellPadding = padding;
    contentRow3.cells[2].style.stringFormat = middleFormat;
    final PdfGridRow contentRow4 = grid.rows.add();
    contentRow4.cells[2].value = 'DIAMOND CTS-';
    contentRow4.cells[2].style.cellPadding = padding;
    contentRow4.cells[2].style.stringFormat = middleFormat;
    final PdfGridRow contentRow5 = grid.rows.add();
    contentRow5.cells[2].value = 'GOLD COLOUR-';
    contentRow5.cells[2].style.cellPadding = padding;
    contentRow5.cells[2].style.stringFormat = middleFormat;
    final PdfGridRow contentRow6 = grid.rows.add();
    contentRow6.cells[2].value = '';
    contentRow6.height = 15;
    final PdfGridRow contentRow7 = grid.rows.add();
    contentRow7.cells[0].value = '';
    contentRow7.cells[0].columnSpan = 4;
    contentRow7.height = 5;
    return grid;
  }
}

