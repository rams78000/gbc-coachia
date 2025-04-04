# GBC CoachIA

Une application Flutter pour les entrepreneurs et freelances avec assistance IA, planification et outils financiers.

## Description

GBC CoachIA est une application mobile conçue pour aider les entrepreneurs et freelances à optimiser leur temps, productivité et gestion financière. L'application dispose d'une interface moderne, intuitive et professionnelle, réactive sur iOS et Android.

## Fonctionnalités principales

- **Système d'onboarding** : Processus en 3 étapes avec connexion sociale et vérification par email
- **Assistant IA (Chatbot)** : Entrée vocale, intégration GPT-4, historique des conversations
- **Planificateur intelligent** : Vues hebdomadaires/mensuelles, synchronisation avec Google Calendar
- **Module Finances** : Catégorisation des dépenses, connexions aux API bancaires, rapports PDF
- **Générateur de documents** : Système de modèles, pad de signature électronique, synchronisation cloud

## Maquettes visuelles

Les maquettes SVG montrent l'interface utilisateur prévue pour l'application mobile :

1. [Écran de démarrage](https://5002-gbc-coachia-replit-user.replit.app/mockups/splash.svg)
2. [Tableau de bord](https://5002-gbc-coachia-replit-user.replit.app/mockups/dashboard.svg)
3. [Assistant IA](https://5002-gbc-coachia-replit-user.replit.app/mockups/chatbot.svg)
4. [Gestion financière](https://5002-gbc-coachia-replit-user.replit.app/mockups/finance.svg)
5. [Mode sombre](https://5002-gbc-coachia-replit-user.replit.app/mockups/dark_mode.svg)

Pour voir toutes les maquettes sur une seule page, consultez [la galerie de maquettes](https://5002-gbc-coachia-replit-user.replit.app/svg_viewer.html).

## Architecture technique

- Architecture par fonctionnalités avec séparation nette des préoccupations (présentation, domaine, données)
- Gestion d'état avec le pattern BLoC
- Navigation avec Go Router
- Injection de dépendances avec GetIt

## Style et thème

- Système de thème avec support du mode sombre
- Typographie avec la police Inter
- Palette de couleurs personnalisée
- Animations fluides avec Flutter Animate

## Plateforme cible

L'application est développée pour être réactive sur :
- iOS
- Android
- Web (fonctionnalité secondaire)