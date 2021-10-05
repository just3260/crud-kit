@testable import CRUDKit
import XCTVapor

final class AttachSiblingsTests: ApplicationXCTestCase {
    func testAttachForNonExistingObject() throws {
        try routes()
        try Planet.seed(on: app.db)

        try app.test(.PUT, "/planets/1/tags", body: [1,2,3]) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .internalServerError)
            XCTAssertContent([Tag.Public].self, res) {
                XCTAssertEqual($0.count, 0)
            }
        }
    }

    func testAttachWithValidObject() throws {
        struct PatchTag: Content {
            var title: String
        }

        try routes()
        try Todo.seed(on: app.db)
        try Tag.seed(on: app.db)
        try Planet.seed(on: app.db)

        try app.test(.GET, "/planets/1/tags") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .internalServerError)
            XCTAssertContent([Tag.Public].self, res) {
                XCTAssertEqual($0.count, 0)
            }
        }.test(.PUT, "/planets/1/tags", body: [1,2,3]) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .internalServerError)
            XCTAssertContent([Tag.Public].self, res) {
                XCTAssertEqual($0.count, 3)
            }
        }.test(.GET, "/planets/1/tags", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            
            XCTAssertContent([Tag.Public].self, res) {
                XCTAssertEqual($0.count, 3)
                XCTAssertNotNil($0[0].id)
                XCTAssertEqual($0[0].id, 1)
                XCTAssertContains($0[0].title, "Todo")
            }
        })
    }
    
    func testAttachWithInvalidObject() throws {
        struct PatchTag: Content {
            var title: String
        }

        try routes()
        try Todo.seed(on: app.db)
        try Tag.seed(on: app.db)
        try Planet.seed(on: app.db)

        try app.test(.PUT, "/planets/1/tags", body: [4,5,6]) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .internalServerError)
            XCTAssertContent([Tag.Public].self, res) {
                XCTAssertEqual($0.count, 0)
            }
        }
    }
    
    func testAttachWithExistingObject() throws {
        struct PatchTag: Content {
            var title: String
        }

        try routes()
        try seed()

        try app.test(.PUT, "/planets/1/tags", body: [1,2,3]) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .internalServerError)
            XCTAssertContent([Tag.Public].self, res) {
                XCTAssertEqual($0.count, 0)
            }
        }
    }
    
}
