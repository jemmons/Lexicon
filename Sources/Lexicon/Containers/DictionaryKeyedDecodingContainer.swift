import Foundation



public struct DictionaryKeyedDecodingContainer<Key>: KeyedDecodingContainerProtocol
where Key: CodingKey {
    private let dictionary: [String: Any?]
    
    
    public let codingPath: [any CodingKey] = []
    public var allKeys: [Key] {
        dictionary.keys.compactMap(Key.init(stringValue:))
    }
    
    
    public init(dictionary: [String: Any?]) {
        self.dictionary = dictionary
    }
}



public extension DictionaryKeyedDecodingContainer {    
    func contains(_ key: Key) -> Bool {
        dictionary.keys.contains(key.stringValue)
    }
    

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        guard dictionary.keys.contains(key.stringValue) else {
            throw ContainerError.keyNotFound(key: key)
        }
        switch dictionary[key.stringValue] {
        case let t as T:
            return t
        case let d as [String: Any?]:
            return try T(from: DictionaryDecoder(dictionary: d))
        case let a as [Any]:
            return try T(from: DictionaryDecoder(array: a))
        default:
            throw ContainerError.couldNotDecodeKey(key: key, type: String(describing: type))
        }
    }
    
    
    func decodeNil(forKey key: Key) throws -> Bool {
        guard let _exists = dictionary[key.stringValue],
              let _ = _exists else {
            return true
        }
        return false
    }
    
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw ContainerError.expectedNesting(key: key)
    }
    
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
        throw ContainerError.expectedNesting(key: key)
    }
    
    
    func superDecoder() throws -> any Decoder {
        fatalError("expected super decoder")
    }
    
    
    func superDecoder(forKey key: Key) throws -> any Decoder {
        fatalError("expected super decoder for key: \(key)")
    }
}

