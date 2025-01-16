import Testing
import Lexicon


private struct Anon {}

private struct Person: Decodable {
    let name: String
    let age: Int
    
    enum CodingKeys: CodingKey {
        case name
        case age
    }
}


@Test func decodes() throws {
    let source: [String: Any] = [
        "name": "Josh",
        "age": 47,
    ]
    let person = try Person(from: DictionaryDecoder(dictionary: source))
    #expect(person.name == "Josh")
    #expect(person.age == 47)
}


@Test func ignoresExtraInfo() throws {
    let source: [String: Any] = [
        "name": "Josh",
        "age": 47,
        "favoriteRamnaCharacter": "Ryoga",
    ]
    let person = try Person(from: DictionaryDecoder(dictionary: source))
    #expect(person.name == "Josh")
    #expect(person.age == 47)
}


@Test func throwsOnMissingInfo() {
    let source: [String: Any] = [
        "name": "Josh",
    ]
    #expect(throws: ContainerError.keyNotFound(key: Person.CodingKeys.age)) {
        try Person(from: DictionaryDecoder(dictionary: source))
    }
}
