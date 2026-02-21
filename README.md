# Joiefull

Application iOS de catalogue de vetements, developpee en **SwiftUI** dans le cadre du parcours iOS d'OpenClassrooms (Projet 12).

## Fonctionnalites

- Parcours d'un catalogue de vetements par categories
- Recherche d'articles par nom, description ou categorie
- Ajout/retrait de favoris
- Notation par etoiles (1-5) et commentaires
- Cache d'images pour une navigation fluide

## Architecture

**MVVM + Service Layer** avec separation stricte des responsabilites :

```
Views (SwiftUI)  →  ViewModels (@Observable)  →  Services (Protocols)  →  Data Sources
```

| Couche | Role | Exemples |
|--------|------|----------|
| **View** | Interface declarative, aucune logique metier | `HomeView`, `DetailView`, 7 composants reutilisables |
| **ViewModel** | Logique metier, etats, actions async | `HomeViewModel`, `DetailViewModel` |
| **Service** | Acces aux donnees via protocoles | `ClothesService`, `UserItemDataService`, `NetworkClient` |
| **Model** | Structures de donnees | `Item` (API), `UserItemData` (SwiftData) |

## Stack technique

| Domaine | Technologie |
|---------|-------------|
| UI | SwiftUI |
| Persistence | SwiftData |
| Reseau | URLSession / async-await |
| Injection de dependances | Factory |
| Concurrence | Swift Concurrency (@MainActor, async/await) |
| Tests | Swift Testing (63 tests) |
| Observabilite | @Observable (pas ObservableObject) |
| Logs | OSLog (AppLogger) |

## Responsivite

L'interface s'adapte automatiquement au format d'ecran via `horizontalSizeClass` :

- **iPhone** : `NavigationStack` avec navigation empilee
- **iPad** : `NavigationSplitView` avec panneau lateral + detail
- Hauteurs d'images et layouts ajustes dynamiquement

## Accessibilite

- **VoiceOver** : labels et hints en francais sur tous les elements interactifs
- **Traits semantiques** : `.isHeader`, `.isImage`, `.isSelected`, regroupement via `.combine`
- **Dynamic Type** : polices systeme exclusivement (`.title2`, `.headline`, `.body`...)
- **Navigation clavier** : support complet sur iPad
- **Contraste** : couleurs semantiques adaptees aux modes clair/sombre

## Tests

63 tests unitaires et d'integration couvrant toutes les couches :

| Fichier | Tests | Perimetre |
|---------|-------|-----------|
| `HomeViewModelTests` | 27 | Chargement, filtrage, recherche, favoris, etats vides |
| `DetailViewModelTests` | 14 | Notation, commentaires, favoris, gestion d'erreurs |
| `UserItemDataServiceTests` | 22 | CRUD SwiftData, operations combinees, isolation memoire |

**Strategie** : mocks par protocole, stockage in-memory, cas succes + erreur + limites testes systematiquement.

## Lancer le projet

1. Cloner le repo
2. Ouvrir `Joiefull/Joiefull.xcodeproj` dans Xcode
3. Build & Run (iOS 17+)
