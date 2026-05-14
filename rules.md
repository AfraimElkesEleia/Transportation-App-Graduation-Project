# Project Overview
This is a Transportation App (Graduation Project) built with Flutter. It allows users to search, book, and manage transportation tickets (buses, railways). It includes user authentication, profile management, a comprehensive search functionality, and a seat map booking system. The application leverages a robust local storage system (Hive) for recent searches and follows modular design principles for scalability.

# Architecture
The project strictly follows **Clean Architecture** combined with a **Feature-Based Folder Structure**.
- **Core (`lib/core/`)**: Contains app-wide constants, networking (`DioClient`), dependency injection setup (`GetIt`), theming (`ColorsManager`), routing, and utility helpers.
- **Features (`lib/features/`)**: Each feature (e.g., `booking`, `home`, `search`, `login`, `profile`) is isolated and divided into three layers:
  - **Data Layer (`data/`)**: Contains models, remote/local datasources (Dio, Hive), and repository implementations.
  - **Domain Layer (`domain/`)**: Contains use cases and repository interfaces.
  - **Presentation Layer (`presentation/`)**: Contains UI views/widgets and state management handled by `flutter_bloc` (specifically `Cubit`).
- **Dependency Injection**: Handled centrally via `get_it` in `lib/core/di/injection_container.dart`.
- **State Management**: Uses `flutter_bloc` (`Cubit` pattern) to manage UI state reactively.

# Do
- **Follow Clean Architecture**: Always divide new features into `data`, `domain`, and `presentation` layers.
- **Use Dependency Injection**: Register new dependencies (DataSources, Repositories, UseCases, Cubits) in `injection_container.dart` using `get_it`.
- **Use Cubit for State Management**: Manage UI state using `Cubit` and interact with the domain layer via `UseCases`.
- **Centralize Styling**: Use `ColorsManager` (from `core/theming/colors.dart`) for all color references.
- **Handle Errors Gracefully**: Map `DioException` to custom exceptions (e.g., `ServerException`, `NetworkException`) in the datasource and handle them in the repository.
- **Keep UI Modular**: Break down large screens into smaller, reusable widget files (e.g., placing them in `features/.../presentation/views/widgets/`).
- **Use Dartz**: Utilize functional programming paradigms like `Either` for repository return types to handle success and failure paths cleanly.

# Don't
- **Don't Hardcode Colors**: Never use `Color(0xFF...)` directly in UI files. Always add the color to `ColorsManager` and reference it from there.
- **Don't Mix Layers**: Never allow UI (presentation) to directly communicate with DataSources or Dio. It must go through `Cubit` -> `UseCase` -> `Repository` -> `DataSource`.
- **Don't Write Logic in UI**: Keep business logic out of widgets. Let the `Cubit` handle the logic and emit the resulting state.
- **Don't Forget DI Registration**: If you create a new layer file (like a UseCase), don't forget to register it in `get_it` before using it.
- **Don't Bloat Files**: Avoid putting all widgets of a screen into a single file. Extract complex UI components into separate files for maintainability.

# Color Theme
The app utilizes a premium, dark-themed, and vibrant aesthetic. The design relies heavily on deep blues combined with bright accent colors.
- **Primary / Backgrounds**: `darkBlue` (`#0E2255`), `searchBg` (`#0A1628`), `navBarBg` (`#1b357d`).
- **Surfaces / Cards**: `cardBg` (`#112240`), `surfaceMid` (`#1A2E4A`), `marketplaceCardBg` (`#162B75`).
- **Accents / Highlights**: `brightBlue` (`#2089ff`), `cyanBlue` (`#00b1df`), `turquoise` (`#40e0d0`), `accentCyan` (`#00E5FF`).
- **Interactive / Status**: `buttonBlue` (`#007AFF`), `seatSelected` (`#00BFFF`), `successGreen` (`#00C853`).
- **Agency Branding**: Specific colors are reserved for agency branding, such as `agencyGoBus` (`#E67E22`) and `agencyBlueBus` (`#6B2FBF`).
