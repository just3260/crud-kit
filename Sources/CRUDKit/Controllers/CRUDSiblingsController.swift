import Vapor
import Fluent
import FluentKit

public struct CRUDSiblingsController<T: Model & CRUDModel, SiblingT: Model, ThroughT: Model>: CRUDSiblingsControllerProtocol where T.IDValue: LosslessStringConvertible, SiblingT.IDValue: LosslessStringConvertible, ThroughT.IDValue: LosslessStringConvertible {
    public var idComponentKey: String
    public var siblingIdComponentKey: String
    public var siblings: KeyPath<SiblingT, SiblingsProperty<SiblingT, T, ThroughT>>
    
}

public protocol CRUDSiblingsControllerProtocol {
    associatedtype T: Model, CRUDModel where T.IDValue: LosslessStringConvertible
    associatedtype SiblingT: Model where SiblingT.IDValue: LosslessStringConvertible
    associatedtype ThroughT: Model where ThroughT.IDValue: LosslessStringConvertible
    var idComponentKey: String { get }
    var siblingIdComponentKey: String { get }
    
    var siblings: KeyPath<SiblingT, SiblingsProperty<SiblingT, T, ThroughT>> { get }
}

extension CRUDSiblingsControllerProtocol {
    public func setup(_ routesBuilder: RoutesBuilder, on endpoint: String) {
        let modelComponent = PathComponent(stringLiteral: endpoint)
        let idComponent = PathComponent(stringLiteral: ":\(idComponentKey)")
        let routes = routesBuilder.grouped(modelComponent)
        let idRoutes = routes.grouped(idComponent)
        
        routes.get(use: self.indexAll)
        idRoutes.get(use: self.index)
        routes.put(use: self.attach)
        routes.delete(use: self.detach)
    }
    
    public func indexAll(req: Request) -> EventLoopFuture<[T.Public]> {
        SiblingT.fetch(from: siblingIdComponentKey, on: req).flatMap { sibling in
            sibling[keyPath: self.siblings].query(on: req.db).all()
                .public(db: req.db)
        }
    }
    
    public func index(req: Request) -> EventLoopFuture<T.Public> {
        guard let id = T.getID(from: idComponentKey, on: req) else {
            return req.eventLoop.future(error: Abort(.notFound))
        }
        return SiblingT.fetch(from: siblingIdComponentKey, on: req).flatMap { sibling in
            sibling[keyPath: self.siblings].query(on: req.db)
                .filter(\._$id == id).first()
                .unwrap(or: Abort(.notFound))
                .public(db: req.db)
        }
    }
    
    public func attach(req: Request) throws -> EventLoopFuture<[T.Public]> {
        let ids = try req.content.decode([T.IDValue].self)
        return SiblingT.fetch(from: siblingIdComponentKey, on: req).flatMap { sibling in
            sibling[keyPath: self.siblings].query(on: req.db).all().flatMap { existing in
                T.getAll(from: ids.filter({ id in !existing.contains(where: {$0.id == id})}), on: req).flatMap { models in
                    sibling[keyPath: self.siblings]
                        .attach(models, on: req.db)
                        .map { models }.public(db: req.db)
                }
            }
        }
    }
    
    public func detach(req: Request) throws -> EventLoopFuture<[T.Public]> {
        let ids = try req.content.decode([T.IDValue].self)
        return SiblingT.fetch(from: siblingIdComponentKey, on: req).flatMap { sibling in
            sibling[keyPath: self.siblings].query(on: req.db).all().flatMap { existing in
                T.getAll(from: ids.filter({ id in existing.contains(where: {$0.id == id})}), on: req).flatMap { models in
                    sibling[keyPath: self.siblings]
                        .detach(models, on: req.db)
                        .map { models }.public(db: req.db)
                }
            }
        }
    }
}
