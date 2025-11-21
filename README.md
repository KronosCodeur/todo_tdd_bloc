# Todo TDD BLoC

![Flutter CI](https://github.com/KronosCodeur/todo_tdd_bloc/workflows/Flutter%20CI/badge.svg)

Une application Todo développée avec TDD, BLoC et Clean Architecture.

## 🚀 Features

- ✅ Test-Driven Development
- ✅ Clean Architecture
- ✅ BLoC State Management
- ✅ 100% Test Coverage (objectif)
- ✅ CI/CD avec GitHub Actions

## 🧪 Tests
```bash
# Lancer tous les tests
flutter test

# Lancer avec couverture
flutter test --coverage

```

## 🏗️ Architecture
```
lib/
├── core/              # Utilities, errors, constants
├── features/
│   └── todo/
│       ├── domain/    # Entities, repositories, use cases
│       ├── data/      # Models, data sources, repository impl
│       └── presentation/  # BLoC, pages, widgets
└── injection_container.dart
```

## 📦 Packages utilisés

- `flutter_bloc` - State management
- `get_it` - Dependency injection
- `dartz` - Functional programming
- `equatable` - Value equality
- `shared_preferences` - Local storage
- `mocktail` - Mocking pour tests
- `bloc_test` - Testing BLoC

## 🤝 Contributing

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou PR.

## 📄 License

MIT License