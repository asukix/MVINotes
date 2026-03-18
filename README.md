# Notes app 

**Architecture**

MVI (Store → Controller → Reducer) + Clean Architecture.
Simplified layer structure — no separate DataSource layer, as the app scope doesn't justify the abstraction cost

**Testing**

Integration tests with in-memory CoreData stack, covering repository

XCT Test: covering reducer and UI test

Swift Testing: covering controller

**Tech stack**

Swift, SwiftUI, CoreData, XCTest, Swift Test
