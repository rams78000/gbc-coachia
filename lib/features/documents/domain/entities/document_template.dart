import 'package:gbc_coachia/features/documents/domain/entities/document.dart';

/// Enum pour le type de champ de formulaire
enum FieldType {
  text,
  number,
  date,
  dropdown,
  checkbox,
  textarea,
  email,
  phone,
  address,
  currency,
  image;
  
  /// Nom d'affichage du type
  String get displayName {
    switch (this) {
      case FieldType.text:
        return 'Texte';
      case FieldType.number:
        return 'Nombre';
      case FieldType.date:
        return 'Date';
      case FieldType.dropdown:
        return 'Liste déroulante';
      case FieldType.checkbox:
        return 'Case à cocher';
      case FieldType.textarea:
        return 'Zone de texte';
      case FieldType.email:
        return 'Email';
      case FieldType.phone:
        return 'Téléphone';
      case FieldType.address:
        return 'Adresse';
      case FieldType.currency:
        return 'Montant';
      case FieldType.image:
        return 'Image';
    }
  }
}

/// Classe représentant un champ de formulaire pour un modèle de document
class TemplateField {
  final String id;
  final String label;
  final FieldType type;
  final String? placeholder;
  final bool required;
  final Map<String, dynamic>? validation;
  final List<String>? options;
  final dynamic defaultValue;
  
  TemplateField({
    required this.id,
    required this.label,
    required this.type,
    this.placeholder,
    this.required = false,
    this.validation,
    this.options,
    this.defaultValue,
  });
  
  /// Copie le champ avec de nouvelles valeurs
  TemplateField copyWith({
    String? id,
    String? label,
    FieldType? type,
    String? placeholder,
    bool? required,
    Map<String, dynamic>? validation,
    List<String>? options,
    dynamic defaultValue,
  }) {
    return TemplateField(
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
      placeholder: placeholder ?? this.placeholder,
      required: required ?? this.required,
      validation: validation ?? this.validation,
      options: options ?? this.options,
      defaultValue: defaultValue ?? this.defaultValue,
    );
  }
}

/// Classe représentant une section de champs dans un modèle de document
class TemplateSection {
  final String id;
  final String title;
  final String? description;
  final List<TemplateField> fields;
  
  TemplateSection({
    required this.id,
    required this.title,
    this.description,
    required this.fields,
  });
  
  /// Copie la section avec de nouvelles valeurs
  TemplateSection copyWith({
    String? id,
    String? title,
    String? description,
    List<TemplateField>? fields,
  }) {
    return TemplateSection(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      fields: fields ?? this.fields,
    );
  }
}

/// Entité représentant un modèle de document
class DocumentTemplate {
  final String id;
  final String name;
  final String description;
  final DocumentType type;
  final List<TemplateSection> sections;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDefault;
  final String? thumbnailUrl;
  
  DocumentTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.sections,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.isDefault = false,
    this.thumbnailUrl,
  });
  
  /// Copie le modèle avec de nouvelles valeurs
  DocumentTemplate copyWith({
    String? id,
    String? name,
    String? description,
    DocumentType? type,
    List<TemplateSection>? sections,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDefault,
    String? thumbnailUrl,
  }) {
    return DocumentTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      sections: sections ?? this.sections,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDefault: isDefault ?? this.isDefault,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
