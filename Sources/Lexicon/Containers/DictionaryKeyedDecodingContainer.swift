import Foundation


// Order for synthesized optional types:
// * contains() - if not, nil.
// * decodeNil - if true, nil.
// * decode<T>() - assumed to be non-nil.
public struct DictionaryKeyedDecodingContainer<Key>: KeyedDecodingContainerProtocol
where Key: CodingKey {
    private let dictionary: [String: Any?]
    private let isStrict: Bool
    
    
    public let codingPath: [any CodingKey] = []
    public var allKeys: [Key] {
        dictionary.keys.compactMap(Key.init(stringValue:))
    }
    
    
    public init(dictionary: [String: Any?], isStrict: Bool) {
        self.dictionary = dictionary
        self.isStrict = isStrict
    }
}



public extension DictionaryKeyedDecodingContainer {    
    func contains(_ key: Key) -> Bool {
        let containsKey = dictionary.keys.contains(key.stringValue)
        guard !isStrict else {
            // In strict mode, we want omitted values to continue processing regardless of whether they actually exist or not. That way we can get someplace to throw.
            return true
        }
        switch (isStrict, containsKey) {
        case (true, true),
            (false, true):
            return true
        case (false, false):
            return false
        case (true, false):
            return true
        }
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
            throw ContainerError.couldNotDecodeKey(key: key, type: type)
        }
    }
    
    
    func decodeNil(forKey key: Key) throws -> Bool {
        guard let keyExists = dictionary[key.stringValue] else {
            if isStrict {
                throw ContainerError.omittedInStrict
            }
            return true
        }
        return keyExists == nil
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

