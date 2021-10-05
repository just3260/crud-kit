import Vapor
import Fluent
import CRUDKit

final class PlanetTag: Model {
    static let schema = "planet+tag"

    init() { }
    
    @ID(custom: "id")
    var id: Int?
    
    @Parent(key: "planet_id")
    var planet: Planet

    @Parent(key: "tag_id")
    var tag: Tag
}

extension PlanetTag {
    struct migration: Migration {
        var name = "PlanetTagMigration"
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("planet+tag")
                .field("id", .int, .identifier(auto: true))
                .field("planet_id", .int, .required, .references("planets", "id", onDelete: .cascade, onUpdate: .cascade))
                .field("tag_id", .int, .required, .references("tags", "id", onDelete: .cascade, onUpdate: .cascade))
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("tags").delete()
        }
    }
}

extension PlanetTag {
    static func seed(on database: Database) throws {
        let tags = try Tag.query(on: database).all().wait()
        let planets = try Planet.query(on: database).all().wait()
        try planets.forEach { planet in
            try planet.$tags.attach(tags, on: database).wait()
        }
    }
}
