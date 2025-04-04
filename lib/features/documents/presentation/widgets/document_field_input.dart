import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_field.dart';

/// Widget pour saisir un champ de document
class DocumentFieldInput extends StatefulWidget {
  final DocumentField field;
  final String? initialValue;
  final ValueChanged<String> onChanged;

  const DocumentFieldInput({
    Key? key,
    required this.field,
    this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DocumentFieldInput> createState() => _DocumentFieldInputState();
}

class _DocumentFieldInputState extends State<DocumentFieldInput> {
  late TextEditingController _controller;
  late DateTime? _selectedDate;
  
  @override
  void initState() {
    super.initState();
    
    // Initialiser le contrôleur avec la valeur initiale
    _controller = TextEditingController(text: widget.initialValue);
    
    // Pour les champs de date, initialiser la date sélectionnée
    if (widget.field.type == DocumentFieldType.date) {
      _selectedDate = widget.initialValue != null && widget.initialValue!.isNotEmpty
          ? DateTime.tryParse(widget.initialValue!)
          : null;
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Libellé du champ
          Text(
            '${widget.field.label}${widget.field.required ? ' *' : ''}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Description du champ si disponible
          if (widget.field.description.isNotEmpty) ...[
            const SizedBox(height: 4.0),
            Text(
              widget.field.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
          
          const SizedBox(height: 8.0),
          
          // Widget de saisie selon le type
          _buildInputWidget(context),
        ],
      ),
    );
  }

  // Construit le widget de saisie adapté au type de champ
  Widget _buildInputWidget(BuildContext context) {
    switch (widget.field.type) {
      case DocumentFieldType.text:
        return _buildTextInput(maxLines: 1);
      
      case DocumentFieldType.textArea:
        return _buildTextInput(maxLines: 5);
      
      case DocumentFieldType.number:
        return _buildNumberInput();
      
      case DocumentFieldType.date:
        return _buildDateInput(context);
      
      case DocumentFieldType.email:
        return _buildEmailInput();
      
      case DocumentFieldType.phone:
        return _buildPhoneInput();
      
      case DocumentFieldType.select:
        return _buildSelectInput();
      
      case DocumentFieldType.boolean:
        return _buildBooleanInput();
      
      case DocumentFieldType.currency:
        return _buildCurrencyInput();
      
      default:
        return _buildTextInput(maxLines: 1);
    }
  }

  // Champ texte simple ou multi-lignes
  Widget _buildTextInput({required int maxLines}) {
    return TextFormField(
      controller: _controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: widget.field.placeholder,
      ),
      onChanged: widget.onChanged,
      validator: (value) {
        if (widget.field.required && (value == null || value.isEmpty)) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }

  // Champ nombre
  Widget _buildNumberInput() {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: widget.field.placeholder,
      ),
      onChanged: widget.onChanged,
      validator: (value) {
        if (widget.field.required && (value == null || value.isEmpty)) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }

  // Champ date avec sélecteur
  Widget _buildDateInput(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintText: widget.field.placeholder,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            child: Text(
              _selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : widget.field.placeholder ?? 'Sélectionner une date',
              style: _selectedDate != null
                  ? null
                  : TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
        
        // Bouton pour effacer la date
        if (_selectedDate != null) ...[
          const SizedBox(height: 4.0),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _selectedDate = null;
                  _controller.text = '';
                });
                widget.onChanged('');
              },
              child: const Text('Effacer'),
            ),
          ),
        ],
      ],
    );
  }

  // Sélectionne une date avec un datepicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = picked.toIso8601String().split('T')[0];
      });
      widget.onChanged(_controller.text);
    }
  }

  // Champ email
  Widget _buildEmailInput() {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: widget.field.placeholder,
        prefixIcon: const Icon(Icons.email),
      ),
      onChanged: widget.onChanged,
      validator: (value) {
        if (widget.field.required && (value == null || value.isEmpty)) {
          return 'Ce champ est requis';
        }
        
        if (value != null && value.isNotEmpty) {
          final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
          if (!emailRegExp.hasMatch(value)) {
            return 'Veuillez saisir un email valide';
          }
        }
        
        return null;
      },
    );
  }

  // Champ téléphone
  Widget _buildPhoneInput() {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: widget.field.placeholder,
        prefixIcon: const Icon(Icons.phone),
      ),
      onChanged: widget.onChanged,
      validator: (value) {
        if (widget.field.required && (value == null || value.isEmpty)) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }

  // Liste déroulante
  Widget _buildSelectInput() {
    if (widget.field.options.isEmpty) {
      return const Text('Aucune option disponible');
    }
    
    return DropdownButtonFormField<String>(
      value: _controller.text.isNotEmpty ? _controller.text : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: widget.field.placeholder,
      ),
      items: widget.field.options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          _controller.text = value;
          widget.onChanged(value);
        }
      },
      validator: (value) {
        if (widget.field.required && (value == null || value.isEmpty)) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }

  // Case à cocher
  Widget _buildBooleanInput() {
    bool isChecked = _controller.text == 'true';
    
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            _controller.text = value.toString();
            widget.onChanged(_controller.text);
          },
        ),
        Expanded(
          child: Text(widget.field.placeholder ?? widget.field.label),
        ),
      ],
    );
  }

  // Champ monétaire
  Widget _buildCurrencyInput() {
    return TextFormField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: widget.field.placeholder,
        prefixIcon: const Icon(Icons.euro),
      ),
      onChanged: widget.onChanged,
      validator: (value) {
        if (widget.field.required && (value == null || value.isEmpty)) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }
}
