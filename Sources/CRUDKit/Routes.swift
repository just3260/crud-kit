import Vapor
import Fluent

extension RoutesBuilder {
    public func crud<T: Model & CRUDModel>(_ endpoint: String, model: T.Type, custom: ((RoutesBuilder, CRUDController<T>) -> ())? = nil) where T.IDValue: LosslessStringConvertible {
        let modelComponent = PathComponent(stringLiteral: endpoint)
        let idComponent = PathComponent(stringLiteral: ":\(endpoint)")
        let routes = self.grouped(modelComponent)
        let idRoutes = routes.grouped(idComponent)
        
        let controller = CRUDController<T>(idComponentKey: endpoint)
        controller.setup(self, on: endpoint)
                
        custom?(idRoutes, controller)
    }
    
    public func crud<T: Model & CRUDModel & Patchable>(_ endpoint: String, model: T.Type, custom: ((RoutesBuilder, CRUDController<T>) -> ())? = nil) where T.IDValue: LosslessStringConvertible {
        let modelComponent = PathComponent(stringLiteral: endpoint)
        let idComponent = PathComponent(stringLiteral: ":\(endpoint)")
        let routes = self.grouped(modelComponent)
        let idRoutes = routes.grouped(idComponent)
        
        let controller = CRUDController<T>(idComponentKey: endpoint)
        controller.setup(self, on: endpoint)
                
        custom?(idRoutes, controller)
    }
    
    // MARK: Children
    
    public func crud<T: Model & CRUDModel, ParentT: Model>(_ endpoint: String, children: T.Type, on parentController: CRUDController<ParentT>, via keypath: KeyPath<ParentT, ChildrenProperty<ParentT, T>>, custom: ((RoutesBuilder, CRUDChildrenController<T, ParentT>) -> ())? = nil) where T.IDValue: LosslessStringConvertible {
        let modelComponent = PathComponent(stringLiteral: endpoint)
        let idComponent = PathComponent(stringLiteral: ":\(endpoint)")
        let routes = self.grouped(modelComponent)
        let idRoutes = routes.grouped(idComponent)
        
        let controller = CRUDChildrenController<T, ParentT>(idComponentKey: endpoint, parentIdComponentKey: parentController.idComponentKey, children: keypath)
        controller.setup(self, on: endpoint)
                
        custom?(idRoutes, controller)
    }
    
    public func crud<T: Model & CRUDModel & Patchable, ParentT: Model>(_ endpoint: String, children: T.Type, on parentController: CRUDController<ParentT>, via keypath: KeyPath<ParentT, ChildrenProperty<ParentT, T>>, custom: ((RoutesBuilder, CRUDChildrenController<T, ParentT>) -> ())? = nil) where T.IDValue: LosslessStringConvertible {
        let modelComponent = PathComponent(stringLiteral: endpoint)
        let idComponent = PathComponent(stringLiteral: ":\(endpoint)")
        let routes = self.grouped(modelComponent)
        let idRoutes = routes.grouped(idComponent)
        
        let controller = CRUDChildrenController<T, ParentT>(idComponentKey: endpoint, parentIdComponentKey: parentController.idComponentKey, children: keypath)
        controller.setup(self, on: endpoint)
                
        custom?(idRoutes, controller)
    }
    
    // MARK: Siblings

    public func crud<T: Model & CRUDModel, SiblingT: Model, ThroughT: Model>(_ endpoint: String, siblings: T.Type, on siblingController: CRUDController<SiblingT>, through: ThroughT.Type, via keypath: KeyPath<SiblingT, SiblingsProperty<SiblingT, T, ThroughT>>, custom: ((RoutesBuilder, CRUDSiblingsController<T, SiblingT, ThroughT>) -> ())? = nil) where T.IDValue: LosslessStringConvertible {
        let modelComponent = PathComponent(stringLiteral: endpoint)
        let idComponent = PathComponent(stringLiteral: ":\(endpoint)")
        let routes = self.grouped(modelComponent)
        let idRoutes = routes.grouped(idComponent)
        
        let controller = CRUDSiblingsController<T, SiblingT, ThroughT>(idComponentKey: endpoint, siblingIdComponentKey: siblingController.idComponentKey, siblings: keypath)
        controller.setup(self, on: endpoint)
                
        custom?(idRoutes, controller)
    }

    public func crud<T: Model & CRUDModel & Patchable, SiblingT: Model, ThroughT: Model>(_ endpoint: String, siblings: T.Type, on siblingController: CRUDController<SiblingT>, via keypath: KeyPath<SiblingT, SiblingsProperty<SiblingT, T, ThroughT>>, custom: ((RoutesBuilder, CRUDSiblingsController<T, SiblingT, ThroughT>) -> ())? = nil) where T.IDValue: LosslessStringConvertible {
        let modelComponent = PathComponent(stringLiteral: endpoint)
        let idComponent = PathComponent(stringLiteral: ":\(endpoint)")
        let routes = self.grouped(modelComponent)
        let idRoutes = routes.grouped(idComponent)
        
        let controller = CRUDSiblingsController<T, SiblingT, ThroughT>(idComponentKey: endpoint, siblingIdComponentKey: siblingController.idComponentKey, siblings: keypath)
        controller.setup(self, on: endpoint)
                
        custom?(idRoutes, controller)
    }

}
