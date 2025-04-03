# GBC CoachIA

GBC CoachIA est une application mobile complète conçue pour les entrepreneurs et freelances, offrant un assistant IA, des outils de planification et des fonctionnalités de gestion financière.

## Fonctionnalités

- **Assistant IA**: Conversez avec un assistant IA spécialisé pour les entrepreneurs et freelances
- **Planification**: Gérez vos tâches, projets et deadlines efficacement
- **Finance**: Suivez vos revenus, dépenses et la santé financière de votre activité
- **Dashboard**: Visualisez vos données et votre progression
- **Profil**: Personnalisez votre expérience utilisateur

## Architecture

L'application est construite avec Flutter en utilisant une architecture orientée fonctionnalités (feature-first), ce qui permet une meilleure séparation des préoccupations et une maintenance plus facile.

Chaque fonctionnalité est divisée en trois couches :
- **Presentation**: Widgets et BLoCs pour l'interface utilisateur
- **Domain**: Entités, cas d'utilisation et interfaces de repository
- **Data**: Implémentations de repository et sources de données

## Structure du projet

```
lib/
├── app.dart               # Point d'entrée de l'application
├── config/                # Configuration de l'application
│   ├── di/                # Injection de dépendances
│   ├── router/            # Configuration des routes
│   └── theme/             # Thème de l'application
├── core/                  # Composants partagés
│   ├── constants/         # Constantes de l'application
│   └── utils/             # Utilitaires partagés
└── features/              # Fonctionnalités
    ├── auth/              # Authentification
    ├── chatbot/           # Assistant IA
    ├── planner/           # Planification
    ├── finance/           # Gestion financière
    ├── dashboard/         # Tableau de bord
    └── profile/           # Profil utilisateur
```

## Exécution du projet

1. Assurez-vous d'avoir Flutter installé sur votre machine
2. Clonez le repository
3. Installez les dépendances : `flutter pub get`
4. Lancez l'application : `flutter run`

## Technologies utilisées

- **Flutter**: Framework UI pour le développement multiplateforme
- **Bloc**: Gestion d'état
- **Get_It**: Injection de dépendances
- **Dio**: Client HTTP pour les requêtes d'API
- **Hive**: Base de données locale