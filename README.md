# URLOrganizerUIKit
A modern iOS application built with **UIKit** to elegantly organize, persist, and browse a list of web URLs. 
This project was specifically designed to demonstrate proficiency in modern iOS development patterns, clean architecture, and Apple's latest Swift concurrency features. It serves as a showcase of writing scalable, crash-safe, and highly maintainable code without relying on legacy paradigms or third-party dependencies.
## Technical Highlights
### Modern UIKit & Programmatic UI
- **100% Programmatic UI:** Built entirely without Storyboards or XIBs. Views and layouts are constructed in code using Auto Layout (`NSLayoutConstraint`), demonstrating a deep understanding of the UIKit view lifecycle and rendering pipeline.
- **Diffable Data Sources:** Uses `UITableViewDiffableDataSource` alongside `NSDiffableDataSourceSnapshot` for robust, O(N) list updates. This entirely eliminates the risk of `NSInternalInconsistencyException` crashes related to index-based updates while providing fluid, automatic animations.
- **Modern Interactions:** Leverages `UIContextMenuConfiguration` to provide native, elegant context menus for actions like Editing, Deleting, and Removing Duplicates.
### Swift 6 Strict Concurrency
- **Async/Await:** Replaces legacy closure-based callbacks with modern `async`/`await` for asynchronous disk I/O, ensuring thread safety and readable asynchronous flows.
- **Actor Isolation:** Strategically uses `@MainActor` to guarantee UI updates occur on the main thread, satisfying Swift 6's strict concurrency checker.
- **Sendable Compliance:** Models and cross-actor data types (`URLListSection`, `URLItem`) explicitly conform to `Sendable` and `nonisolated`, demonstrating an advanced understanding of Swift's approach to data race safety and `SWIFT_DEFAULT_ACTOR_ISOLATION`.
### Clean Architecture (MVVM & POP)
- **Model-View-ViewModel (MVVM):** Enforces a strict separation of concerns. The View acts purely as a dumb renderer, while the ViewModel handles presentation logic and coordinates with the data layer. 
- **Protocol-Oriented Programming (POP):** Dependencies such as `URLRepositoryProtocol`, `StorageServiceProtocol`, and `URLValidating` are abstracted behind protocols. This allows for seamless dependency injection, making the codebase highly modular and completely testable (e.g., swapping `FileManagerStorageService` for a mock in unit tests).
- **Lightweight View Controllers:** By offloading diffing to `UITableViewDiffableDataSource` and business logic to the ViewModel, the `URLListViewController` avoids the "Massive View Controller" anti-pattern.
### Robust Data Management
- **Persistence:** Implements a robust `StorageService` using `FileManager` and `Codable` to persist user data to disk as JSON. Disk operations are safely offloaded to background threads using `Task.detached(priority: .utility)`.
- **Validation:** Employs a dedicated `URLValidator` to normalize input (e.g., automatically appending `https://`) and validate URL components before persisting data.
## Project Structure
- **Models:** Immutable, `Sendable` data structures (`URLItem`, `URLListSection`).
- **Views/Controllers:** Programmatic UI components (`URLListViewController`, `WebViewController`, `EmptyStateView`).
- **ViewModels:** Presentation and coordination logic (`URLListViewModel`).
- **Services:** Protocol-based utilities for validation and background I/O (`URLValidator`, `StorageService`).
- **Repository:** Centralized data access layer (`URLRepository`).
## Requirements
- **iOS:** 15.0+ (Utilizes modern UI and Concurrency APIs)
- **Xcode:** 15.0+ (Swift 5.9+ with Strict Concurrency Checking)
- **Dependencies:** None. This project is built entirely using native Apple frameworks (UIKit, Foundation) to demonstrate core competency.
## Getting Started
1. Clone the repository.
2. Open `URLOrganizerUIKit.xcodeproj` in Xcode.
3. Build and run on any iOS Simulator or physical device. No package resolution or setup scripts required.
## Screenshots
<img width="300" alt="Simulator Screenshot - iPhone 11 - 2026-07-25 at 00 43 17" src="https://github.com/user-attachments/assets/221594bd-d2e2-4b0d-a5c8-d1a714dc19c7" />
<img width="300" alt="Simulator Screenshot - iPhone 11 - 2026-07-25 at 00 46 09" src="https://github.com/user-attachments/assets/28f768a7-6fe0-4ebb-bc1a-2ffc0dcb880a" />
<img width="300" alt="Simulator Screenshot - iPhone 11 - 2026-07-25 at 00 44 08" src="https://github.com/user-attachments/assets/448a4f31-2775-42bc-a12d-e0411cf36412" />



