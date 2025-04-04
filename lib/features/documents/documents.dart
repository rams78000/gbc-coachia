/// Exporte tous les composants nécessaires pour la fonctionnalité de documents
library documents;

// Domain
export 'domain/entities/document.dart';
export 'domain/entities/document_template.dart';
export 'domain/entities/document_extensions.dart';
export 'domain/repositories/document_repository.dart';

// Data
export 'data/repositories/mock_document_repository.dart';

// Presentation - Bloc
export 'presentation/bloc/document_bloc.dart';

// Presentation - Pages
export 'presentation/pages/documents_page.dart';
export 'presentation/pages/documents_list_page.dart';
export 'presentation/pages/document_templates_page.dart';
export 'presentation/pages/document_create_page.dart';
export 'presentation/pages/document_detail_page.dart';

// Presentation - Widgets
export 'presentation/widgets/document_card.dart';
export 'presentation/widgets/template_card.dart';
export 'presentation/widgets/document_field_input.dart';
export 'presentation/widgets/document_filter.dart';
export 'presentation/widgets/document_preview.dart';
