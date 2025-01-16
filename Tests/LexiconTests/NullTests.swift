import Testing
import Lexicon


private struct Anon: Decodable {
    let name: String?
    let age: Int
    
    enum CodingKeys: CodingKey {
        case name
        case age
    }
}

    
    
@Test func null() throws {
    let source: [String: Any?] = [
        "name": nil,
        "age": 47
    ]
    let anon = try Anon(from: DictionaryDecoder(dictionary: source))
    #expect(anon.name == nil)
    #expect(anon.age == 47)
}


@Test func notNull() throws {
    let source: [String: Any?] = [
        "name": "Josh",
        "age": 47
    ]
    let anon = try Anon(from: DictionaryDecoder(dictionary: source))
    #expect(anon.name == "Josh")
    #expect(anon.age == 47)
}


@Test func omittedNullThrowsInStrict() {
    let source: [String: Any?] = [
        "age": 47
    ]
    #expect(throws: ContainerError.omittedInStrict) {
        try Anon(from: DictionaryDecoder(dictionary: source))
    }
}


@Test func omittedNullAllowedInUnstrict() throws {
    let source: [String: Any?] = [
        "age": 47
    ]
    let anon = try Anon(from: DictionaryDecoder(dictionary: source, isStrict: false))
    #expect(anon.name == nil)
    #expect(anon.age == 47)
}


@Test func nullThrows() {
    let source: [String: Any?] = [
        "name": "Josh",
        "age": nil,
    ]
    
    #expect(throws: ContainerError.couldNotDecodeKey(key: Anon.CodingKeys.age, type: Int.self)) {
        try Anon(from: DictionaryDecoder(dictionary: source))
    }
}
