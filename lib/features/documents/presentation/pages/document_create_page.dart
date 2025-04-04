import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_template.dart';
import 'package:gbc_coachia/features/documents/presentation/bloc/document_bloc.dart';
import 'package:intl/intl.dart';

/// Page de création d'un document à partir d'un modèle
class DocumentCreatePage extends StatefulWidget {
  final String templateId;
  
  const DocumentCreatePage({
    Key? key,
    required this.templateId,
  }) : super(key: key);

  @override
  State<DocumentCreatePage> createState() => _DocumentCreatePageState();
}

class _DocumentCreatePageState extends State<DocumentCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  final TextEditingController _titleController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Charger le modèle
    context.read<DocumentBloc>().add(LoadTemplateById(widget.templateId));
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un document'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog();
            },
          ),
        ],
      ),
      body: BlocConsumer<DocumentBloc, DocumentState>(
        listener: (context, state) {
          if (state is DocumentGenerated) {
            // Rediriger vers la page de détail du document généré
            Navigator.pushReplacementNamed(
              context,
              '/documents/detail',
              arguments: state.document.id,
            );
            
            // Afficher un message de succès
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Document "${state.document.title}" créé avec succès'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is DocumentGenerationError) {
            // Afficher un message d'erreur
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TemplateLoaded) {
            final template = state.template;
            return _buildForm(context, template);
          }
          
          if (state is TemplatesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64.0,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Erreur: ${state.message}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DocumentBloc>().add(LoadTemplateById(widget.templateId));
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          
          if (state is DocumentGenerationLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text('Génération du document en cours...'),
                ],
              ),
            );
          }
          
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
  
  // Construit le formulaire de création du document
  Widget _buildForm(BuildContext context, DocumentTemplate template) {
    // Initialiser le titre par défaut si nécessaire
    if (_titleController.text.isEmpty) {
      _titleController.text = 'Nouveau ${template.type.displayName}';
    }
    
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: template.type.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(
                    template.type.icon,
                    color: template.type.color,
                    size: 32.0,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          template.description,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24.0),
            
            // Titre du document
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre du document *',
                hintText: 'Exemple: Facture #123 - Client XYZ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un titre';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24.0),
            
            // Sections avec champs du modèle
            ...template.sections.map((section) => _buildSection(context, section)),
            
            const SizedBox(height: 24.0),
            
            // Boutons d'action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Retourner à la page précédente
                    Navigator.pop(context);
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _generateDocument(template);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: template.type.color,
                  ),
                  child: const Text('Générer le document'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // Construit une section du formulaire
  Widget _buildSection(BuildContext context, TemplateSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la section
          Text(
            section.title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Description de la section
          if (section.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
              child: Text(
                section.description!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.0,
                ),
              ),
            ),
          
          const SizedBox(height: 16.0),
          
          // Champs de la section
          ...section.fields.map((field) => _buildField(context, field)),
        ],
      ),
    );
  }
  
  // Construit un champ du formulaire
  Widget _buildField(BuildContext context, TemplateField field) {
    // Initialiser la valeur par défaut si nécessaire
    if (field.defaultValue != null && !_formData.containsKey(field.id)) {
      _formData[field.id] = field.defaultValue;
    }
    
    switch (field.type) {
      case FieldType.text:
        return _buildTextField(field);
      
      case FieldType.number:
        return _buildNumberField(field);
      
      case FieldType.date:
        return _buildDateField(field);
      
      case FieldType.dropdown:
        return _buildDropdownField(field);
      
      case FieldType.checkbox:
        return _buildCheckboxField(field);
      
      case FieldType.textarea:
        return _buildTextAreaField(field);
      
      case FieldType.email:
        return _buildEmailField(field);
      
      case FieldType.phone:
        return _buildPhoneField(field);
      
      case FieldType.address:
        return _buildAddressField(field);
      
      case FieldType.currency:
        return _buildCurrencyField(field);
      
      case FieldType.image:
        return _buildImageField(field);
      
      default:
        return _buildTextField(field);
    }
  }
  
  // Champ de texte simple
  Widget _buildTextField(TemplateField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: _formData[field.id] as String?,
        decoration: InputDecoration(
          labelText: '${field.label}${field.required ? ' *' : ''}',
          hintText: field.placeholder,
          border: const OutlineInputBorder(),
        ),
        validator: field.required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est requis';
                }
                return null;
              }
            : null,
        onChanged: (value) {
          _formData[field.id] = value;
        },
      ),
    );
  }
  
  // Champ numérique
  Widget _buildNumberField(TemplateField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: _formData[field.id]?.toString(),
        decoration: InputDecoration(
          labelText: '${field.label}${field.required ? ' *' : ''}',
          hintText: field.placeholder,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: field.required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est requis';
                }
                if (double.tryParse(value) == null) {
                  return 'Veuillez entrer un nombre valide';
                }
                return null;
              }
            : (value) {
                if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
                  return 'Veuillez entrer un nombre valide';
                }
                return null;
              },
        onChanged: (value) {
          if (value.isEmpty) {
            _formData[field.id] = null;
          } else {
            _formData[field.id] = double.tryParse(value);
          }
        },
      ),
    );
  }
  
  // Champ date
  Widget _buildDateField(TemplateField field) {
    // Convertir la valeur en DateTime si nécessaire
    DateTime? selectedDate;
    if (_formData[field.id] != null) {
      if (_formData[field.id] is String) {
        selectedDate = DateTime.tryParse(_formData[field.id] as String);
      } else if (_formData[field.id] is DateTime) {
        selectedDate = _formData[field.id] as DateTime;
      }
    }
    
    final controller = TextEditingController(
      text: selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate) : '',
    );
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: '${field.label}${field.required ? ' *' : ''}',
          hintText: 'JJ/MM/AAAA',
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        readOnly: true,
        validator: field.required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est requis';
                }
                return null;
              }
            : null,
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          
          if (pickedDate != null) {
            setState(() {
              selectedDate = pickedDate;
              controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
              _formData[field.id] = pickedDate.toIso8601String();
            });
          }
        },
      ),
    );
  }
  
  // Champ liste déroulante
  Widget _buildDropdownField(TemplateField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: _formData[field.id] as String?,
        decoration: InputDecoration(
          labelText: '${field.label}${field.required ? ' *' : ''}',
          border: const OutlineInputBorder(),
        ),
        items: field.options?.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList() ?? [],
        validator: field.required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est requis';
                }
                return null;
              }
            : null,
        onChanged: (value) {
          setState(() {
            _formData[field.id] = value;
          });
        },
      ),
    );
  }
  
  // Champ case à cocher
  Widget _buildCheckboxField(TemplateField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FormField<bool>(
        initialValue: _formData[field.id] as bool? ?? false,
        validator: field.required
            ? (value) {
                if (value == null || !value) {
                  return 'Ce champ est requis';
                }
                return null;
              }
            : null,
        builder: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: state.value ?? false,
                    onChanged: (value) {
                      state.didChange(value);
                      setState(() {
                        _formData[field.id] = value;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      '${field.label}${field.required ? ' *' : ''}',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                  child: Text(
                    state.errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12.0,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
  
  // Zone de texte multiligne
  Widget _buildTextAreaField(TemplateField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: _formData[field.id] as String?,
        decoration: InputDecoration(
          labelText: '${field.label}${field.required ? ' *' : ''}',
          hintText: field.placeholder,
          border: const OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
        maxLines: 5,
        validator: field.required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est requis';
                }
                return null;
              }
            : null,
        onChanged: (value) {
          _formData[field.id] = value;
        },
      ),
    );
  }
  
  // Champ email
  Widget _buildEmailField(TemplateField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: _formData[field.id] as String?,
        decoration: InputDecoration(
          labelText: '${field.label}${field.required ? ' *' : ''}',
          hintText: field.placeholder ?? 'exemple@domaine.com',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.email),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (field.required && (value == null || value.isEmpty)) {
            return 'Ce champ est requis';
          }
          if (value != null && value.isNotEmpty) {
            // Validation simple d'email
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Veuillez entrer une adresse email valide';
            }
          }
          return null;
        },
        onChanged: (value) {
          _formData[field.id] = value;
        },
      ),
    );
  }
  
  // Champ téléphone
  Widget _buildPhoneField(TemplateField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: _formData[field.id] as String?,
        decoration: InputDecoration(
          labelText: '${field.label}${field.required ? ' *' : ''}',
          hintText: field.placeholder ?? '+33 6 12 34 56 78',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.phone),
        ),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (field.required && (value == null || value.isEmpty)) {
            return 'Ce champ est requis';
          }
          // On pourrait ajouter une validation de numéro de téléphone plus complexe ici
          return null;
        },
        onChanged: (value) {
          _formData[field.id] = value;
        },
      ),
    );
  }
  
  // Champ adresse
  Widget _buildAddressField(TemplateField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: _formData[field.id] as String?,
        decoration: InputDecoration(
          labelText: '${field.label}${field.required ? ' *' : ''}',
          hintText: field.placeholder,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.location_on),
        ),
        maxLines: 3,
        validator: field.required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est requis';
                }
                return null;
              }
            : null,
        onChanged: (value) {
          _formData[field.id] = value;
        },
      ),
    );
  }
  
  // Champ montant
  Widget _buildCurrencyField(TemplateField field) {
    // Groupe de champs pour le montant et la devise
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Montant
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: _formData[field.id]?.toString(),
              decoration: InputDecoration(
                labelText: '${field.label}${field.required ? ' *' : ''}',
                hintText: '0.00',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.monetization_on),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: field.required
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est requis';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Montant invalide';
                      }
                      return null;
                    }
                  : (value) {
                      if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
                        return 'Montant invalide';
                      }
                      return null;
                    },
              onChanged: (value) {
                if (value.isEmpty) {
                  _formData[field.id] = null;
                } else {
                  _formData[field.id] = double.tryParse(value);
                }
              },
            ),
          ),
          
          const SizedBox(width: 8.0),
          
          // Devise
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<String>(
              value: _formData['currency'] as String? ?? 'EUR',
              decoration: const InputDecoration(
                labelText: 'Devise',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem<String>(
                  value: 'EUR',
                  child: Text('EUR (€)'),
                ),
                DropdownMenuItem<String>(
                  value: 'USD',
                  child: Text('USD (\$)'),
                ),
                DropdownMenuItem<String>(
                  value: 'GBP',
                  child: Text('GBP (£)'),
                ),
                DropdownMenuItem<String>(
                  value: 'CAD',
                  child: Text('CAD (CA\$)'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _formData['currency'] = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // Champ image
  Widget _buildImageField(TemplateField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${field.label}${field.required ? ' *' : ''}',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 8.0),
          
          // Zone d'upload d'image
          GestureDetector(
            onTap: () {
              // TODO: Implémenter la sélection d'image
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sélection d\'image non implémentée'),
                ),
              );
            },
            child: Container(
              height: 120.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 48.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Cliquez pour sélectionner une image',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          if (field.required)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'Ce champ est requis',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  // Génère le document
  void _generateDocument(DocumentTemplate template) {
    // Valider le formulaire
    if (!_formKey.currentState!.validate()) {
      // Le formulaire n'est pas valide
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs requis'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Afficher un dialog de confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Générer le document'),
        content: const Text('Êtes-vous sûr de vouloir générer ce document ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              
              // Envoyer les données au bloc
              context.read<DocumentBloc>().add(
                GenerateDocumentFromTemplate(
                  templateId: template.id,
                  data: _formData,
                  title: _titleController.text,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: template.type.color,
            ),
            child: const Text('Générer'),
          ),
        ],
      ),
    );
  }
  
  // Affiche la boîte de dialogue d'aide
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aide pour la création de document'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comment remplir le formulaire :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '1. Entrez un titre pour votre document.',
              ),
              SizedBox(height: 4.0),
              Text(
                '2. Remplissez tous les champs marqués d\'un astérisque (*).',
              ),
              SizedBox(height: 4.0),
              Text(
                '3. Les autres champs sont optionnels.',
              ),
              SizedBox(height: 4.0),
              Text(
                '4. Vérifiez votre saisie avant de générer le document.',
              ),
              SizedBox(height: 16.0),
              Text(
                'Que se passe-t-il ensuite ?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Une fois le document généré, vous pourrez le consulter, le modifier, le télécharger ou le partager.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
