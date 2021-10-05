import Vapor
import Fluent

extension Model where IDValue: LosslessStringConvertible {
    internal static func getID(from key: String, on request: Request) -> IDValue? {
        request.parameters.get(key)
    }
    
    internal static func fetch(from key: String, on request: Request) -> EventLoopFuture<Self> {
        let id = Self.getID(from: key, on: request)
        return Self.find(id, on: request.db).unwrap(or: Abort(.notFound))
    }
    
    internal static func getAll(from ids: [Self.IDValue], on request: Request) -> EventLoopFuture<[Self]> {
        return Self.query(on: request.db).filter(\._$id ~~ ids).all()
    }
}
