@testable import CRUDKit
import XCTVapor

final class IndexAllSiblingsTests: ApplicationXCTestCase {
    func testEmptyIndexAll() throws {
        try routes()
        try Tag.seed(on: app.db)
        try Planet.seed(on: app.db)
        
        try app.test(.GET, "/planets/1/tags", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            XCTAssertContent([Tag.Public].self, res) {
                XCTAssertEqual($0.count, 0)
            }
        })
    }
    
    func testIndexAllContainingAllElements() throws {
        try seed()
        try routes()
        
        try app.test(.GET, "/planets/1/tags", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            XCTAssertContent([Tag.Public].self, res) {
                print($0)
                XCTAssertGreaterThan($0.count, 0)
                XCTAssertEqual($0.count, 3)
                XCTAssertNotEqual($0.count, 2)
                XCTAssertContains($0[0].title, "Todo")
            }
        })
    }
}
