import XCTest
import Lexicon


class DictionaryTests: XCTestCase {
    struct Person: Decodable {
        let name: String
        let age: Int
    }
    struct Anon: Decodable {
        let name: String!
        let age: Int
    }
    
    
    func testDecodes() throws {
        let source: [String: Any] = [
            "name": "Josh",
            "age": 47,
        ]
        let person = try Person(from: DictionaryDecoder(dictionary: source))
        XCTAssertEqual(person.name, "Josh")
        XCTAssertEqual(person.age, 47)
    }
    
    
    func testIgnoresExtraInfo() throws {
        let source: [String: Any] = [
            "name": "Josh",
            "age": 47,
            "favoriteRamnaCharacter": "Ryoga",
        ]
        let person = try Person(from: DictionaryDecoder(dictionary: source))
        XCTAssertEqual(person.name, "Josh")
        XCTAssertEqual(person.age, 47)
    }
    
    
    func testThrowsOnMissingInfo() {
        let source: [String: Any] = [
            "name": "Josh",
        ]
        XCTAssertThrowsError(try Person(from: DictionaryDecoder(dictionary: source))) { error in
            guard case ContainerError.keyNotFound(let key) = error else {
                return XCTFail("Unexpceted error")
            }
            XCTAssertEqual(key.stringValue, "age")
        }
    }
    
    func testNull() throws {
        let source: [String: Any?] = [
            "name": nil,
            "age": 47
        ]
        let anon = try Anon(from: DictionaryDecoder(dictionary: source))
        XCTAssertNil(anon.name)
        XCTAssertEqual(anon.age, 47)
    }
    
    
    func testNotNull() throws {
        let source: [String: Any?] = [
            "name": "Josh",
            "age": 47
        ]
        let anon = try Anon(from: DictionaryDecoder(dictionary: source))
        XCTAssertEqual(anon.name, "Josh")
        XCTAssertEqual(anon.age, 47)
    }
}
