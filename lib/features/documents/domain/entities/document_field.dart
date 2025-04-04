/// Enum représentant les types de champs de document
enum DocumentFieldType {
  text,
  textArea,
  number,
  date,
  email,
  phone,
  select,
  boolean,
  currency,
}

/// Entité représentant un champ de document
class DocumentField {
  final String id;
  final String label;
  final String description;
  final DocumentFieldType type;
  final bool required;
  final String? placeholder;
  final String? defaultValue;
  final List<String> options;
  
  DocumentField({
    required this.id,
    required this.label,
    this.description = '',
    required this.type,
    this.required = false,
    this.placeholder,
    this.defaultValue,
    this.options = const [],
  });
  
  /// Copie le champ avec de nouvelles valeurs
  DocumentField copyWith({
    String? id,
    String? label,
    String? description,
    DocumentFieldType? type,
    bool? required,
    String? placeholder,
    String? defaultValue,
    List<String>? options,
  }) {
    return DocumentField(
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? this.description,
      type: type ?? this.type,
      required: required ?? this.required,
      placeholder: placeholder ?? this.placeholder,
      defaultValue: defaultValue ?? this.defaultValue,
      options: options ?? this.options,
    );
  }
}
