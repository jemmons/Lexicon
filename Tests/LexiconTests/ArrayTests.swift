import XCTest
import Lexicon



class ArrayTests: XCTestCase {
    struct Person: Decodable {
        let name: String
        let age: Int
    }
    struct FamilyMember: Decodable {
        let name: String
        let age: Int
        let children: [FamilyMember]
    }
    struct Employee: Decodable {
        let name: String
        let id: UUID
        let jobs: [Job]
    }
    struct Job: Decodable {
        let title: String
    }
    
    
    func testArrayOfDictionaries() throws {
        let source = [
            [
                "name": "Josh",
                "age": 47,
            ],
            [
                "name": "Walker",
                "age": 13,
            ],
        ]
        
        let people = try [Person](from: DictionaryDecoder(array: source))
        XCTAssertEqual(people[0].name, "Josh")
        XCTAssertEqual(people[0].age, 47)
        XCTAssertEqual(people[1].name, "Walker")
        XCTAssertEqual(people[1].age, 13)
    }
    
    
    func testEmptyArray() throws {
        let people = try [Person](from: DictionaryDecoder(array: []))
        XCTAssert(people.isEmpty)
    }
    
    
    func testDictionaryToArrayThrows() throws {
        let source: [String: Any] = [
            "name": "Josh",
            "age": 47,
        ]
        XCTAssertThrowsError(try [Person](from: DictionaryDecoder(dictionary: source))) { e in
            guard case DecoderError.expectedDictionary = e else {
                return XCTFail("Expected expectedDictionary error")
            }
        }
    }
    
    
    func testNestedDictionary() throws {
        let id = UUID()
        let source: [String: Any] = [
            "name": "Josh",
            "id": id,
            "jobs": [
                [
                    "title": "developer",
                ],
                [
                    "title": "safety",
                ],
            ]
        ]

        let emp = try Employee(from: DictionaryDecoder(dictionary: source))
        
        XCTAssertEqual(emp.name, "Josh")
        XCTAssertEqual(emp.id, id)
        XCTAssertEqual(emp.jobs.count, 2)
        XCTAssertEqual(emp.jobs[0].title, "developer")
        XCTAssertEqual(emp.jobs[1].title, "safety")
    }
    
    
    func testRecursiveDictionary() throws {
        let source: [String: Any] = [
            "name": "Josh",
            "age": 47,
            "children": [
                [
                    "name": "Walker",
                    "age": 13,
                    "children": [],
                ]
            ]
        ]
        
        let familyMember = try FamilyMember(from: DictionaryDecoder(dictionary: source))
        XCTAssertEqual(familyMember.name, "Josh")
        XCTAssertEqual(familyMember.age, 47)
        XCTAssertEqual(familyMember.children.count, 1)
        XCTAssertEqual(familyMember.children[0].name, "Walker")
        XCTAssertEqual(familyMember.children[0].age, 13)
        XCTAssert(familyMember.children[0].children.isEmpty)
        
    }
}
