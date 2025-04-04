import 'package:equatable/equatable.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';

/// Représente un champ de formulaire pour un modèle de document
class DocumentField extends Equatable {
  final String id;
  final String label;
  final String placeholder;
  final String? description;
  final bool required;
  final DocumentFieldType type;
  final List<String>? options;
  final String? defaultValue;
  final String? validationRegex;

  const DocumentField({
    required this.id,
    required this.label,
    required this.placeholder,
    this.description,
    this.required = false,
    required this.type,
    this.options,
    this.defaultValue,
    this.validationRegex,
  });

  /// Copie l'objet avec des valeurs modifiées
  DocumentField copyWith({
    String? id,
    String? label,
    String? placeholder,
    String? description,
    bool? required,
    DocumentFieldType? type,
    List<String>? options,
    String? defaultValue,
    String? validationRegex,
  }) {
    return DocumentField(
      id: id ?? this.id,
      label: label ?? this.label,
      placeholder: placeholder ?? this.placeholder,
      description: description ?? this.description,
      required: required ?? this.required,
      type: type ?? this.type,
      options: options ?? this.options,
      defaultValue: defaultValue ?? this.defaultValue,
      validationRegex: validationRegex ?? this.validationRegex,
    );
  }

  /// Convertit le champ en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'placeholder': placeholder,
      'description': description,
      'required': required,
      'type': type.toString().split('.').last,
      'options': options,
      'defaultValue': defaultValue,
      'validationRegex': validationRegex,
    };
  }

  /// Crée un objet DocumentField à partir d'un JSON
  factory DocumentField.fromJson(Map<String, dynamic> json) {
    return DocumentField(
      id: json['id'],
      label: json['label'],
      placeholder: json['placeholder'],
      description: json['description'],
      required: json['required'] ?? false,
      type: _parseFieldType(json['type']),
      options: json['options'] != null 
          ? List<String>.from(json['options'])
          : null,
      defaultValue: json['defaultValue'],
      validationRegex: json['validationRegex'],
    );
  }

  /// Fonction d'aide pour parser le type de champ à partir d'une chaîne
  static DocumentFieldType _parseFieldType(String typeStr) {
    return DocumentFieldType.values.firstWhere(
      (e) => e.toString().split('.').last == typeStr,
      orElse: () => DocumentFieldType.text,
    );
  }

  @override
  List<Object?> get props => [
        id,
        label,
        placeholder,
        description,
        required,
        type,
        options,
        defaultValue,
        validationRegex,
      ];
}

/// Enum pour représenter les différents types de champs
enum DocumentFieldType {
  text,
  number,
  date,
  dropdown,
  checkbox,
  email,
  phone,
  multiline,
  currency,
  image,
}

/// Extension sur DocumentFieldType pour obtenir une représentation en chaîne de caractères
extension DocumentFieldTypeExtension on DocumentFieldType {
  String get displayName {
    switch (this) {
      case DocumentFieldType.text:
        return 'Texte';
      case DocumentFieldType.number:
        return 'Nombre';
      case DocumentFieldType.date:
        return 'Date';
      case DocumentFieldType.dropdown:
        return 'Liste déroulante';
      case DocumentFieldType.checkbox:
        return 'Case à cocher';
      case DocumentFieldType.email:
        return 'Email';
      case DocumentFieldType.phone:
        return 'Téléphone';
      case DocumentFieldType.multiline:
        return 'Texte multiligne';
      case DocumentFieldType.currency:
        return 'Montant';
      case DocumentFieldType.image:
        return 'Image';
    }
  }
}

/// Représente un modèle de document dans l'application
class DocumentTemplate extends Equatable {
  final String id;
  final String name;
  final String description;
  final DocumentType type;
  final String thumbnailUrl;
  final List<DocumentField> fields;
  final String templateContent;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const DocumentTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.thumbnailUrl,
    required this.fields,
    required this.templateContent,
    this.isDefault = false,
    required this.createdAt,
    this.updatedAt,
  });

  /// Copie l'objet avec des valeurs modifiées
  DocumentTemplate copyWith({
    String? id,
    String? name,
    String? description,
    DocumentType? type,
    String? thumbnailUrl,
    List<DocumentField>? fields,
    String? templateContent,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DocumentTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fields: fields ?? this.fields,
      templateContent: templateContent ?? this.templateContent,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convertit le modèle en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'thumbnailUrl': thumbnailUrl,
      'fields': fields.map((field) => field.toJson()).toList(),
      'templateContent': templateContent,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Crée un objet DocumentTemplate à partir d'un JSON
  factory DocumentTemplate.fromJson(Map<String, dynamic> json) {
    return DocumentTemplate(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: Document._parseDocumentType(json['type']),
      thumbnailUrl: json['thumbnailUrl'],
      fields: (json['fields'] as List)
          .map((field) => DocumentField.fromJson(field))
          .toList(),
      templateContent: json['templateContent'],
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        thumbnailUrl,
        fields,
        templateContent,
        isDefault,
        createdAt,
        updatedAt,
      ];
}
