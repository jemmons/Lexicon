import Foundation



public struct DictionaryUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    private let array: [Any]
    public let codingPath: [CodingKey] = []
    public var currentIndex: Int = 0
    public var isAtEnd: Bool { currentIndex == array.endIndex }
    public var count: Int? { array.count }

    
    public init(array: [Any]) {
        self.array = array
    }
}



public extension DictionaryUnkeyedDecodingContainer {
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        defer { currentIndex += 1 }
        switch array[currentIndex] {
        case let t as T:
            return t
        case let d as [String: Any]:
            return try T(from: DictionaryDecoder(dictionary: d))
        case let a as [Any]:
            return try T(from: DictionaryDecoder(array: a))
        default:
            throw ContainerError.couldNotDecodeIndex(index: currentIndex, type: type)
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
