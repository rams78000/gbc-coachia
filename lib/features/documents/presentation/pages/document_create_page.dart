import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document.dart';
import 'package:gbc_coachia/features/documents/domain/entities/document_template.dart';
import 'package:gbc_coachia/features/documents/presentation/bloc/document_bloc.dart';
import 'package:gbc_coachia/features/documents/presentation/widgets/document_field_input.dart';
import 'package:gbc_coachia/features/shared/presentation/widgets/main_scaffold.dart';

/// Page pour créer un document à partir d'un modèle
class DocumentCreatePage extends StatefulWidget {
  final String? templateId;

  const DocumentCreatePage({
    Key? key,
    this.templateId,
  }) : super(key: key);

  @override
  State<DocumentCreatePage> createState() => _DocumentCreatePageState();
}

class _DocumentCreatePageState extends State<DocumentCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  late String _selectedTemplateId;
  List<DocumentTemplate> _templates = [];
  DocumentTemplate? _selectedTemplate;
  
  final Map<String, String> _fieldValues = {};
  final TextEditingController _titleController = TextEditingController();
  bool _isGenerating = false;
  
  @override
  void initState() {
    super.initState();
    
    // Charger les modèles disponibles
    context.read<DocumentBloc>().add(LoadTemplates());
    
    // Si un ID de modèle est fourni, le sélectionner
    if (widget.templateId != null) {
      _selectedTemplateId = widget.templateId!;
      context.read<DocumentBloc>().add(LoadTemplateById(_selectedTemplateId));
    }
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Créer un document',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: BlocConsumer<DocumentBloc, DocumentState>(
        listener: (context, state) {
          if (state is TemplatesLoaded) {
            setState(() {
              _templates = state.templates;
              
              // Si un ID était présélectionné, sélectionner le modèle correspondant
              if (widget.templateId != null) {
                _selectedTemplate = _templates.firstWhere(
                  (template) => template.id == widget.templateId,
                  orElse: () => _templates.isNotEmpty ? _templates.first : null,
                );
                
                if (_selectedTemplate != null) {
                  _selectedTemplateId = _selectedTemplate!.id;
                }
              }
            });
          } else if (state is TemplateLoaded) {
            setState(() {
              _selectedTemplate = state.template;
              
              // Initialiser les valeurs par défaut
              for (final field in _selectedTemplate!.fields) {
                if (field.defaultValue != null) {
                  _fieldValues[field.id] = field.defaultValue!;
                }
              }
            });
          } else if (state is DocumentGenerated) {
            // Réinitialiser l'indicateur de génération
            setState(() {
              _isGenerating = false;
            });
            
            // Naviguer vers la page de détail du document généré
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              '/documents/detail',
              arguments: state.document.id,
            );
          } else if (state is DocumentGenerationError) {
            // Réinitialiser l'indicateur de génération
            setState(() {
              _isGenerating = false;
            });
            
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
          if (state is TemplatesLoading || (state is DocumentGenerationLoading && _isGenerating)) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (_templates.isEmpty) {
            return const Center(
              child: Text('Aucun modèle disponible'),
            );
          }
          
          return Form(
            key: _formKey,
            child: Column(
              children: [
                // Sélecteur de modèle
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedTemplate?.id,
                    decoration: InputDecoration(
                      labelText: 'Modèle de document',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    items: _templates.map((template) {
                      return DropdownMenuItem<String>(
                        value: template.id,
                        child: Text(template.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedTemplateId = value;
                          _fieldValues.clear();
                        });
                        context.read<DocumentBloc>().add(LoadTemplateById(value));
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner un modèle';
                      }
                      return null;
                    },
                  ),
                ),
                
                // Titre du document
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Titre du document',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir un titre';
                      }
                      return null;
                    },
                  ),
                ),
                
                const SizedBox(height: 16.0),
                
                // Champs du modèle sélectionné
                if (_selectedTemplate != null) ...[
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _selectedTemplate!.fields.length,
                      itemBuilder: (context, index) {
                        final field = _selectedTemplate!.fields[index];
                        return DocumentFieldInput(
                          field: field,
                          initialValue: _fieldValues[field.id],
                          onChanged: (value) {
                            _fieldValues[field.id] = value;
                          },
                        );
                      },
                    ),
                  ),
                  
                  // Bouton de génération
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isGenerating ? null : _generateDocument,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            _isGenerating ? 'Génération en cours...' : 'Générer le document',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // Génère un document à partir du modèle et des valeurs saisies
  void _generateDocument() {
    // Valider le formulaire
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // Vérifier que tous les champs requis sont remplis
    bool allRequiredFieldsFilled = true;
    String? missingField;
    
    for (final field in _selectedTemplate!.fields) {
      if (field.required) {
        final value = _fieldValues[field.id];
        if (value == null || value.isEmpty) {
          allRequiredFieldsFilled = false;
          missingField = field.label;
          break;
        }
      }
    }
    
    if (!allRequiredFieldsFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir le champ requis: $missingField'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Définir l'état de génération
    setState(() {
      _isGenerating = true;
    });
    
    // Générer le document
    context.read<DocumentBloc>().add(
      GenerateDocumentFromTemplate(
        templateId: _selectedTemplateId,
        data: Map<String, dynamic>.from(_fieldValues),
        title: _titleController.text,
      ),
    );
  }
}
