import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/documents_bloc.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        actions: [
          PopupMenuButton<DocumentType>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter documents',
            onSelected: (type) {
              context.read<DocumentsBloc>().add(FilterDocuments(typeFilter: type));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: DocumentType.invoice,
                child: Text('Invoices'),
              ),
              const PopupMenuItem(
                value: DocumentType.contract,
                child: Text('Contracts'),
              ),
              const PopupMenuItem(
                value: DocumentType.quote,
                child: Text('Quotes'),
              ),
              const PopupMenuItem(
                value: DocumentType.report,
                child: Text('Reports'),
              ),
              const PopupMenuItem(
                value: null,
                child: Text('Show All'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<DocumentsBloc, DocumentsState>(
        listener: (context, state) {
          if (state is DocumentsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is PdfGenerationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('PDF generated successfully'),
                action: SnackBarAction(
                  label: 'View',
                  onPressed: () {
                    // In a real app, this would open the PDF file
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening ${state.filePath}')),
                    );
                  },
                ),
              ),
            );
          } else if (state is PdfGenerationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is DocumentsInitial || state is DocumentsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DocumentsLoaded) {
            final documents = state.filteredDocuments;
            
            if (documents.isEmpty) {
              return _buildEmptyState(context, state.activeFilter);
            }
            
            return _buildDocumentsList(context, documents, state.activeFilter);
          } else if (state is PdfGenerationInProgress) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating PDF...'),
                ],
              ),
            );
          }
          
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDocumentTypeSelectionDialog(context),
        child: const Icon(Icons.add),
        tooltip: 'Create Document',
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, DocumentType? activeFilter) {
    String message = 'You don\'t have any documents yet';
    
    if (activeFilter != null) {
      message = 'No ${activeFilter.displayName.toLowerCase()}s found';
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (activeFilter != null)
            Icon(
              IconData(
                int.parse('0xe${activeFilter.icon.codeUnitAt(0).toRadixString(16)}', radix: 16),
                fontFamily: 'MaterialIcons',
              ),
              size: 64,
              color: AppColors.textSecondary,
            )
          else
            const Icon(
              Icons.description_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
          SizedBox(height: AppTheme.spacing(2)),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: AppTheme.spacing(2)),
          AppButton(
            text: 'Create Document',
            onPressed: () => _showDocumentTypeSelectionDialog(context),
            fullWidth: false,
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList(BuildContext context, List<Document> documents, DocumentType? activeFilter) {
    // Group documents by type
    final Map<DocumentType, List<Document>> documentsByType = {};
    
    if (activeFilter != null) {
      // If filtering, just add the filtered type
      documentsByType[activeFilter] = documents;
    } else {
      // Group by type
      for (final document in documents) {
        if (!documentsByType.containsKey(document.type)) {
          documentsByType[document.type] = [];
        }
        documentsByType[document.type]!.add(document);
      }
    }
    
    return ListView(
      padding: EdgeInsets.all(AppTheme.spacing(2)),
      children: [
        // Display active filter chip if filtering
        if (activeFilter != null)
          Padding(
            padding: EdgeInsets.only(bottom: AppTheme.spacing(2)),
            child: Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: Text('${activeFilter.displayName}s'),
                  selected: true,
                  onSelected: (_) {
                    context.read<DocumentsBloc>().add(const FilterDocuments(typeFilter: null));
                  },
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    context.read<DocumentsBloc>().add(const FilterDocuments(typeFilter: null));
                  },
                ),
              ],
            ),
          ),
        
        // Display documents by type
        for (final type in documentsByType.keys)
          _buildDocumentTypeSection(context, type, documentsByType[type]!),
      ],
    );
  }

  Widget _buildDocumentTypeSection(BuildContext context, DocumentType type, List<Document> documents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppTheme.spacing(1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${type.displayName}s',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  context.read<DocumentsBloc>().add(FilterDocuments(typeFilter: type));
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final document = documents[index];
            return _buildDocumentItem(context, document);
          },
        ),
        SizedBox(height: AppTheme.spacing(3)),
      ],
    );
  }

  Widget _buildDocumentItem(BuildContext context, Document document) {
    // Get document specific icon
    IconData getDocumentIcon() {
      switch (document.type) {
        case DocumentType.invoice:
          return Icons.receipt_outlined;
        case DocumentType.contract:
          return Icons.description_outlined;
        case DocumentType.quote:
          return Icons.request_quote_outlined;
        case DocumentType.report:
          return Icons.summarize_outlined;
      }
    }
    
    return AppCard(
      margin: EdgeInsets.only(bottom: AppTheme.spacing(2)),
      onTap: () => _showDocumentDetailsDialog(context, document),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacing(2)),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                getDocumentIcon(),
                color: AppColors.primary,
                size: 24,
              ),
            ),
            SizedBox(width: AppTheme.spacing(2)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Updated ${DateFormat('MMM d, yyyy').format(document.updatedAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (document.pdfPath != null)
              Tooltip(
                message: 'PDF Available',
                child: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                  size: 20,
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showDocumentOptionsMenu(context, document),
                iconSize: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showDocumentTypeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Document Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDocumentTypeButton(
              context,
              'Create Invoice',
              Icons.receipt_outlined,
              () {
                Navigator.pop(context);
                _showCreateInvoiceDialog(context);
              },
            ),
            SizedBox(height: AppTheme.spacing(2)),
            _buildDocumentTypeButton(
              context,
              'Create Contract',
              Icons.description_outlined,
              () {
                Navigator.pop(context);
                _showCreateContractDialog(context);
              },
            ),
            SizedBox(height: AppTheme.spacing(2)),
            _buildDocumentTypeButton(
              context,
              'Create Quote',
              Icons.request_quote_outlined,
              () {
                Navigator.pop(context);
                _showCreateQuoteDialog(context);
              },
            ),
            SizedBox(height: AppTheme.spacing(2)),
            _buildDocumentTypeButton(
              context,
              'Create Report',
              Icons.summarize_outlined,
              () {
                Navigator.pop(context);
                _showCreateReportDialog(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTypeButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: AppTheme.spacing(2)),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  void _showCreateInvoiceDialog(BuildContext context) {
    final titleController = TextEditingController();
    final clientNameController = TextEditingController();
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Invoice'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: titleController,
                  label: 'Invoice Title',
                  hint: 'e.g. Website Development Project',
                  autofocus: true,
                ),
                SizedBox(height: AppTheme.spacing(2)),
                AppTextField(
                  controller: clientNameController,
                  label: 'Client Name',
                  hint: 'e.g. ABC Corporation',
                ),
                SizedBox(height: AppTheme.spacing(2)),
                AppTextField(
                  controller: amountController,
                  label: 'Amount',
                  hint: 'e.g. 1500.00',
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.attach_money),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            AppButton(
              text: 'Create',
              type: AppButtonType.primary,
              fullWidth: false,
              onPressed: () {
                if (titleController.text.trim().isEmpty ||
                    clientNameController.text.trim().isEmpty ||
                    amountController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final now = DateTime.now();
                final double? amount = double.tryParse(amountController.text.trim());
                
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount')),
                  );
                  return;
                }

                // Create invoice document
                context.read<DocumentsBloc>().add(CreateDocument(
                  title: titleController.text.trim(),
                  type: DocumentType.invoice,
                  data: {
                    'invoiceNumber': 'INV-${now.year}-${now.millisecondsSinceEpoch.toString().substring(10)}',
                    'clientName': clientNameController.text.trim(),
                    'issueDate': now.toIso8601String(),
                    'dueDate': now.add(const Duration(days: 30)).toIso8601String(),
                    'items': [
                      {'description': titleController.text.trim(), 'quantity': 1, 'unitPrice': amount},
                    ],
                    'subtotal': amount,
                    'taxRate': 0.0,
                    'taxAmount': 0.0,
                    'total': amount,
                    'notes': 'Payment due within 30 days.',
                  },
                ));

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showCreateContractDialog(BuildContext context) {
    final titleController = TextEditingController();
    final clientNameController = TextEditingController();
    final servicesController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Contract'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: titleController,
                  label: 'Contract Title',
                  hint: 'e.g. Consulting Services Agreement',
                  autofocus: true,
                ),
                SizedBox(height: AppTheme.spacing(2)),
                AppTextField(
                  controller: clientNameController,
                  label: 'Client Name',
                  hint: 'e.g. XYZ Enterprises',
                ),
                SizedBox(height: AppTheme.spacing(2)),
                AppTextField(
                  controller: servicesController,
                  label: 'Services Description',
                  hint: 'Describe the services to be provided',
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            AppButton(
              text: 'Create',
              type: AppButtonType.primary,
              fullWidth: false,
              onPressed: () {
                if (titleController.text.trim().isEmpty ||
                    clientNameController.text.trim().isEmpty ||
                    servicesController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final now = DateTime.now();

                // Create contract document
                context.read<DocumentsBloc>().add(CreateDocument(
                  title: titleController.text.trim(),
                  type: DocumentType.contract,
                  data: {
                    'contractNumber': 'CON-${now.year}-${now.millisecondsSinceEpoch.toString().substring(10)}',
                    'clientName': clientNameController.text.trim(),
                    'startDate': now.toIso8601String(),
                    'endDate': now.add(const Duration(days: 90)).toIso8601String(),
                    'services': servicesController.text.trim(),
                    'paymentTerms': 'Payment terms to be negotiated.',
                    'terminationClause': 'Either party may terminate with 30 days written notice.',
                  },
                ));

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showCreateQuoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final clientNameController = TextEditingController();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Quote'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: titleController,
                  label: 'Quote Title',
                  hint: 'e.g. Website Redesign Project',
                  autofocus: true,
                ),
                SizedBox(height: AppTheme.spacing(2)),
                AppTextField(
                  controller: clientNameController,
                  label: 'Client Name',
                  hint: 'e.g. 123 Startups Inc.',
                ),
                SizedBox(height: AppTheme.spacing(2)),
                AppTextField(
                  controller: descriptionController,
                  label: 'Project Description',
                  hint: 'Describe the project briefly',
                  maxLines: 3,
                ),
                SizedBox(height: AppTheme.spacing(2)),
                AppTextField(
                  controller: amountController,
                  label: 'Total Amount',
                  hint: 'e.g. 3500.00',
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.attach_money),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            AppButton(
              text: 'Create',
              type: AppButtonType.primary,
              fullWidth: false,
              onPressed: () {
                if (titleController.text.trim().isEmpty ||
                    clientNameController.text.trim().isEmpty ||
                    descriptionController.text.trim().isEmpty ||
                    amountController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final now = DateTime.now();
                final double? amount = double.tryParse(amountController.text.trim());
                
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount')),
                  );
                  return;
                }

                // Create quote document
                context.read<DocumentsBloc>().add(CreateDocument(
                  title: titleController.text.trim(),
                  type: DocumentType.quote,
                  data: {
                    'quoteNumber': 'QT-${now.year}-${now.millisecondsSinceEpoch.toString().substring(10)}',
                    'clientName': clientNameController.text.trim(),
                    'validUntil': now.add(const Duration(days: 30)).toIso8601String(),
                    'items': [
                      {'description': descriptionController.text.trim(), 'total': amount},
                    ],
                    'subtotal': amount,
                    'discount': 0.0,
                    'total': amount,
                    'notes': 'This quote is valid for 30 days.',
                  },
                ));

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showCreateReportDialog(BuildContext context) {
    final titleController = TextEditingController();
    final periodController = TextEditingController();
    final summaryController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Report'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: titleController,
                  label: 'Report Title',
                  hint: 'e.g. Monthly Business Performance',
                  autofocus: true,
                ),
                SizedBox(height: AppTheme.spacing(2)),
                AppTextField(
                  controller: periodController,
                  label: 'Report Period',
                  hint: 'e.g. January 2023',
                ),
                SizedBox(height: AppTheme.spacing(2)),
                AppTextField(
                  controller: summaryController,
                  label: 'Executive Summary',
                  hint: 'Provide a brief summary of the report',
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            AppButton(
              text: 'Create',
              type: AppButtonType.primary,
              fullWidth: false,
              onPressed: () {
                if (titleController.text.trim().isEmpty ||
                    periodController.text.trim().isEmpty ||
                    summaryController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final now = DateTime.now();

                // Create report document
                context.read<DocumentsBloc>().add(CreateDocument(
                  title: titleController.text.trim(),
                  type: DocumentType.report,
                  data: {
                    'reportNumber': 'RPT-${now.year}-${now.millisecondsSinceEpoch.toString().substring(10)}',
                    'period': periodController.text.trim(),
                    'executiveSummary': summaryController.text.trim(),
                    'keyMetrics': [],
                    'recommendations': '',
                  },
                ));

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDocumentDetailsDialog(BuildContext context, Document document) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(document.title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Document type and date
                Row(
                  children: [
                    Chip(
                      label: Text(document.type.displayName),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      labelStyle: TextStyle(color: AppColors.primary),
                    ),
                    SizedBox(width: AppTheme.spacing(1)),
                    Expanded(
                      child: Text(
                        'Created: ${DateFormat('MMM d, yyyy').format(document.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing(2)),
                
                // Document details based on type
                _buildDocumentDetails(context, document),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (document.pdfPath != null)
              TextButton(
                onPressed: () {
                  // In a real app, this would open the PDF file
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening ${document.pdfPath}')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('View PDF'),
              )
            else
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<DocumentsBloc>().add(GenerateDocumentPdf(document.id));
                },
                child: const Text('Generate PDF'),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showDeleteDocumentConfirmation(context, document);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDocumentDetails(BuildContext context, Document document) {
    switch (document.type) {
      case DocumentType.invoice:
        return _buildInvoiceDetails(context, document);
      case DocumentType.contract:
        return _buildContractDetails(context, document);
      case DocumentType.quote:
        return _buildQuoteDetails(context, document);
      case DocumentType.report:
        return _buildReportDetails(context, document);
    }
  }

  Widget _buildInvoiceDetails(BuildContext context, Document document) {
    final data = document.data;
    final invoiceNumber = data['invoiceNumber'] as String?;
    final clientName = data['clientName'] as String?;
    final issueDate = data['issueDate'] != null
        ? DateTime.parse(data['issueDate'] as String)
        : null;
    final dueDate = data['dueDate'] != null
        ? DateTime.parse(data['dueDate'] as String)
        : null;
    final total = data['total'] as double?;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(context, 'Invoice Number', invoiceNumber),
        _buildDetailItem(context, 'Client', clientName),
        if (issueDate != null)
          _buildDetailItem(
            context,
            'Issue Date',
            DateFormat('MMM d, yyyy').format(issueDate),
          ),
        if (dueDate != null)
          _buildDetailItem(
            context,
            'Due Date',
            DateFormat('MMM d, yyyy').format(dueDate),
          ),
        if (total != null)
          _buildDetailItem(
            context,
            'Total Amount',
            '\$${total.toStringAsFixed(2)}',
            isHighlighted: true,
          ),
        if (data['notes'] != null)
          _buildDetailItem(context, 'Notes', data['notes'] as String),
      ],
    );
  }

  Widget _buildContractDetails(BuildContext context, Document document) {
    final data = document.data;
    final contractNumber = data['contractNumber'] as String?;
    final clientName = data['clientName'] as String?;
    final startDate = data['startDate'] != null
        ? DateTime.parse(data['startDate'] as String)
        : null;
    final endDate = data['endDate'] != null
        ? DateTime.parse(data['endDate'] as String)
        : null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(context, 'Contract Number', contractNumber),
        _buildDetailItem(context, 'Client', clientName),
        if (startDate != null)
          _buildDetailItem(
            context,
            'Start Date',
            DateFormat('MMM d, yyyy').format(startDate),
          ),
        if (endDate != null)
          _buildDetailItem(
            context,
            'End Date',
            DateFormat('MMM d, yyyy').format(endDate),
          ),
        if (data['services'] != null)
          _buildDetailItem(
            context,
            'Services',
            data['services'] as String,
            multiline: true,
          ),
        if (data['paymentTerms'] != null)
          _buildDetailItem(
            context,
            'Payment Terms',
            data['paymentTerms'] as String,
            multiline: true,
          ),
      ],
    );
  }

  Widget _buildQuoteDetails(BuildContext context, Document document) {
    final data = document.data;
    final quoteNumber = data['quoteNumber'] as String?;
    final clientName = data['clientName'] as String?;
    final validUntil = data['validUntil'] != null
        ? DateTime.parse(data['validUntil'] as String)
        : null;
    final total = data['total'] as double?;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(context, 'Quote Number', quoteNumber),
        _buildDetailItem(context, 'Client', clientName),
        if (validUntil != null)
          _buildDetailItem(
            context,
            'Valid Until',
            DateFormat('MMM d, yyyy').format(validUntil),
          ),
        if (total != null)
          _buildDetailItem(
            context,
            'Total Amount',
            '\$${total.toStringAsFixed(2)}',
            isHighlighted: true,
          ),
        if (data['notes'] != null)
          _buildDetailItem(context, 'Notes', data['notes'] as String),
      ],
    );
  }

  Widget _buildReportDetails(BuildContext context, Document document) {
    final data = document.data;
    final reportNumber = data['reportNumber'] as String?;
    final period = data['period'] as String?;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(context, 'Report Number', reportNumber),
        _buildDetailItem(context, 'Period', period),
        if (data['executiveSummary'] != null)
          _buildDetailItem(
            context,
            'Executive Summary',
            data['executiveSummary'] as String,
            multiline: true,
          ),
        if (data['recommendations'] != null && data['recommendations'].toString().isNotEmpty)
          _buildDetailItem(
            context,
            'Recommendations',
            data['recommendations'] as String,
            multiline: true,
          ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String? value, {
    bool multiline = false,
    bool isHighlighted = false,
  }) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.spacing(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: isHighlighted
                ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  )
                : Theme.of(context).textTheme.bodyMedium,
            maxLines: multiline ? null : 1,
            overflow: multiline ? null : TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showDocumentOptionsMenu(BuildContext context, Document document) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.remove_red_eye),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  _showDocumentDetailsDialog(context, document);
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Generate PDF'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<DocumentsBloc>().add(GenerateDocumentPdf(document.id));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteDocumentConfirmation(context, document);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDocumentConfirmation(BuildContext context, Document document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete "${document.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<DocumentsBloc>().add(DeleteDocument(document.id));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
