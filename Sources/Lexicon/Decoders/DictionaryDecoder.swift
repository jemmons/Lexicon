import Foundation



public struct DictionaryDecoder: Decoder {
    private let source: DictionaryOrArray
    public let codingPath: [any CodingKey] = []
    public let userInfo: [CodingUserInfoKey : Any] = [:]
    
    public init(dictionary: [String: Any]) {
        self.source = .dictionary(dictionary)
    }
    
    
    public init(array: [Any]) {
        self.source = .array(array)
    }
}



public extension DictionaryDecoder {    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        switch source {
        case let .dictionary(d):
            return KeyedDecodingContainer(DictionaryKeyedDecodingContainer(dictionary: d))
        case .array:
            throw DecoderError.expectedArray
        }
    }

    
    func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
        switch source {
        case let .array(a):
            return DictionaryUnkeyedDecodingContainer(array: a)
        case .dictionary:
            throw DecoderError.expectedDictionary
        }
    }
    
    
    func singleValueContainer() throws -> any SingleValueDecodingContainer {
        throw DecoderError.expectedSingleValue(source.description)
    }
}


private extension DictionaryDecoder {
    enum DictionaryOrArray: CustomStringConvertible {
        case dictionary([String: Any])
        case array([Any])
        
        var description: String {
            switch self {
            case .dictionary:
                return "dictionary"
            case .array:
                return "array"
            }
        }
    }
}
