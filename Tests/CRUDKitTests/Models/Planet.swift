import Vapor
import Fluent
import CRUDKit

final class Planet: Model {
    static var schema = "planets"
    
    init() { }
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(through: PlanetTag.self, from: \.$planet, to: \.$tag)
    var tags: [Tag]
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension Planet: CRUDModel { }

extension Planet {
    struct migration: Migration {
        var name = "PlanetMigration"
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("planets")
                .field("id", .int, .identifier(auto: true))
                .field("name", .string, .required)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("planets").delete()
        }
    }
}

extension Planet {
    static func seed(on database: Database) throws {
        try Planet(name: "Earth").save(on: database).wait()
        try Planet(name: "Mars").save(on: database).wait()
        try Planet(name: "Jupiter").save(on: database).wait()
    }
}
