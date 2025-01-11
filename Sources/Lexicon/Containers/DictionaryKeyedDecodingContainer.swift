import Foundation



public struct DictionaryKeyedDecodingContainer<Key>: KeyedDecodingContainerProtocol
where Key: CodingKey {
    private let dictionary: [String: Any]
    
    
    public let codingPath: [any CodingKey] = []
    public var allKeys: [Key] {
        dictionary.keys.compactMap(Key.init(stringValue:))
    }
    
    
    public init(dictionary: [String: Any]) {
        self.dictionary = dictionary
    }
}



public extension DictionaryKeyedDecodingContainer {
    enum Error: LocalizedError {
        case keyNotFound(key: CodingKey)
        case couldNotDecode(key: CodingKey, type: String)
        case expectedNesting(key: CodingKey)
        
        public var errorDescription: String? {
            switch self {
            case .keyNotFound(let k):
                return "The key “\(k.stringValue)” was not found in the dictionary."
            case let .couldNotDecode(k, t):
                return "Could not decode value at key “\(k.stringValue)” to type “\(t)”."
            case .expectedNesting(let k):
                return "Expected a nested value at “\(k.stringValue)”, but dictionary must be flat."
            }
        }
    }

    
    func contains(_ key: Key) -> Bool {
        dictionary[key.stringValue] != nil
    }
    
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        guard dictionary.keys.contains(key.stringValue) else {
            throw Error.keyNotFound(key: key)
        }
        
        switch dictionary[key.stringValue] {
        case let t as T:
            return t
        case let d as [String: Any]:
            return try T(from: DictionaryDecoder(dict: d))
        case let a as [Any]:
            return try T(from: ArrayInDictionaryDecoder(array: a))
        default:
            throw Error.couldNotDecode(key: key, type: String(describing: type))
        }
    }
    
    
    func decodeNil(forKey key: Key) throws -> Bool {
        false
    }
    
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw Error.expectedNesting(key: key)
    }
    
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
        throw Error.expectedNesting(key: key)
    }
    
    
    func superDecoder() throws -> any Decoder {
        fatalError("expected super decoder")
    }
    
    
    func superDecoder(forKey key: Key) throws -> any Decoder {
        fatalError("expected super decoder for key: \(key)")
    }
}

