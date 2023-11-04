import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfResultsScreen extends StatefulWidget {
  @override
  _PdfResultsScreenState createState() => _PdfResultsScreenState();
}

class _PdfResultsScreenState extends State<PdfResultsScreen> {
  String rollNumber = '';
  int? currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Results'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                rollNumber = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Enter Roll Number',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _searchRollNumber();
            },
            child: Text('Search'),
          ),
          Expanded(
            child: PDFView(
              filePath: 'https://drive.google.com/file/d/1hJDHK_eb2ibdvqe48eAzLg6YtWc_l4ZT/view?usp=drive_link',
              onPageChanged: (int? page, int? total) {
                setState(() {
                  currentPageIndex = page;
                });
              },
            ),
          ),
          Text(
            'Current Page: ${currentPageIndex ?? 0 + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _searchRollNumber() {
    // Implement your logic to search the roll number in the PDF
    // You can use a PDF parsing library like 'pdf' to extract text and perform the search
    // Once you find the roll number, you can update the currentPageIndex or display the result as needed
  }
}

