# Notes app 
## MVI architecture with unidirectional data flow & integration tests

**Architecture**

MVI (Store → Controller → Reducer) + Clean Architecture.
Simplified layer structure — no separate DataSource layer, as the app scope doesn't justify the abstraction cost

**Testing**

Separated integration tests

**Tech stack**

Swift, SwiftUI, CoreData, XCTest,
