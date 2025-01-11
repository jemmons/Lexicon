import Foundation



struct DictionaryUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    enum Error: LocalizedError {
        case couldNotDecode(index: Int, type: String)
        
        var errorDescription: String? {
            switch self {
            case let .couldNotDecode(i, t):
                return "Could not decode value at index \(i) to type “\(t)”."
            }
        }
    }
    
    
    let array: [Any]
    let codingPath: [CodingKey] = []
    var currentIndex: Int = 0
    var isAtEnd: Bool { currentIndex == array.endIndex }
    var count: Int? {
        return array.count
    }

    
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        defer {currentIndex += 1}
        switch array[currentIndex] {
        case let t as T:
            return t
        case let d as [String: Any]:
            return try T(from: DictionaryDecoder(dict: d))
        case let a as [Any]:
            return try T(from: ArrayInDictionaryDecoder(array: a))
        default:
            throw Error.couldNotDecode(index: currentIndex, type: String(describing: type))
        }
    }

    func decodeNil() -> Bool {
        return false
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("Expected nested keyed container from array.")
    }

    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError("Expected nested unkeyed container from array.")
    }

    func superDecoder() throws -> Decoder {
        fatalError("Expected super decoder from array.")
    }
}
