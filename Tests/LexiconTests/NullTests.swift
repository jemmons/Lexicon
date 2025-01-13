import Lexicon
import XCTest



class NullTests: XCTestCase {
    struct Anon: Decodable {
        let name: String?
        let age: Int
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
    
    
    func testOmittedNullThrowsInStrict() {
        let source: [String: Any?] = [
            "age": 47
        ]
        XCTAssertThrowsError(try Anon(from: DictionaryDecoder(dictionary: source))) { error in
            guard case ContainerError.omittedInStrict = error else {
                return XCTFail("unexpected error")
            }
        }
    }

    
    func testOmittedNullAllowedInUnstrict() throws {
        let source: [String: Any?] = [
            "age": 47
        ]
        let anon = try Anon(from: DictionaryDecoder(dictionary: source, isStrict: false))
        XCTAssertNil(anon.name)
        XCTAssertEqual(anon.age, 47)
    }

    
    func testNullThrows() {
        let source: [String: Any?] = [
            "name": "Josh",
            "age": nil,
        ]
        
        XCTAssertThrowsError(try Anon(from: DictionaryDecoder(dictionary: source))) { error in
            print(error.localizedDescription)
            guard case let ContainerError.couldNotDecodeKey(key, type) = error else {
                return XCTFail("unexpected error")
            }
            XCTAssertEqual(key.stringValue, "age")
            XCTAssert(type is Int.Type)
        }
    }
}
