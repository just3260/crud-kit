@testable import CRUDKit
import XCTVapor
import Vapor
import Fluent
import FluentSQLiteDriver

class ApplicationXCTestCase: XCTestCase {
    var app: Application!
    
    override func setUp() {
        app = Application(.testing)
        
        // Setup database
        app.databases.use(.sqlite(.memory), as: .sqlite)
        app.migrations.add(Todo.migration())
        app.migrations.add(Tag.migration())
        app.migrations.add(Planet.migration())
        app.migrations.add(PlanetTag.migration())
        try! app.autoMigrate().wait()
    }

    override func tearDown() {
        app.shutdown()
    }
    
    func seed() throws {
        try Todo.seed(on: app.db)
        try Tag.seed(on: app.db)
        try Planet.seed(on: app.db)
        try PlanetTag.seed(on: app.db)
    }
    
    func routes() throws {
        app.crud("todos", model: Todo.self) { routes, parentController in
            routes.get("hello") { _ in "Hello World" }
            routes.crud("tags", children: Tag.self, on: parentController, via: \.$tags)
        }
        app.crud("planets", model: Planet.self) { routes, siblingsController in
            routes.crud("tags", siblings: Tag.self, on: siblingsController, through: PlanetTag.self, via: \.$tags)
        }
        app.crud("simpletodos", model: SimpleTodo.self)
    }
}
