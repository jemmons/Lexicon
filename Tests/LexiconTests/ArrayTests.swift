import Testing
import Foundation
import Lexicon


private struct Person: Decodable {
    let name: String
    let age: Int
}


private struct FamilyMember: Decodable {
    let name: String
    let age: Int
    let children: [FamilyMember]
}


private struct Employee: Decodable {
    let name: String
    let id: UUID
    let jobs: [Job]
}


private struct Job: Decodable {
    let title: String
}

    
@Test func arrayOfDictionaries() throws {
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
    #expect(people[0].name == "Josh")
    #expect(people[0].age == 47)
    #expect(people[1].name == "Walker")
    #expect(people[1].age == 13)
}


@Test func emptyArray() throws {
    let people = try [Person](from: DictionaryDecoder(array: []))
    #expect(people.isEmpty)
}


@Test func dictionaryToArrayThrows() {
    let source: [String: Any] = [
        "name": "Josh",
        "age": 47,
    ]
    #expect(throws: DecoderError.expectedDictionary) {
        try [Person](from: DictionaryDecoder(dictionary: source))
    }
}


@Test func nestedDictionary() throws {
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
    
    #expect(emp.name == "Josh")
    #expect(emp.id == id)
    #expect(emp.jobs.count == 2)
    #expect(emp.jobs[0].title == "developer")
    #expect(emp.jobs[1].title == "safety")
}


@Test func recursiveDictionary() throws {
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
    #expect(familyMember.name == "Josh")
    #expect(familyMember.age == 47)
    #expect(familyMember.children.count == 1)
    #expect(familyMember.children[0].name == "Walker")
    #expect(familyMember.children[0].age == 13)
    #expect(familyMember.children[0].children.isEmpty)
}
