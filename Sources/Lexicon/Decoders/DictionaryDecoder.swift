import Foundation



struct DictionaryDecoder: Decoder {
    enum Error: LocalizedError {
        case expectedSingleValue
        case expectedArray
        
        var errorDescription: String? {
            switch self {
            case .expectedSingleValue:
                return "Expected single value, but found dictionary."
            case .expectedArray:
                return "Expected array, but found dictionary."
            }
        }
    }
    
    let codingPath: [any CodingKey] = []
    let userInfo: [CodingUserInfoKey : Any] = [:]
    let dict: [String: Any]
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        KeyedDecodingContainer(DictionaryKeyedDecodingContainer(dictionary: dict))
    }
    
    func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
        throw Error.expectedArray
    }
    
    func singleValueContainer() throws -> any SingleValueDecodingContainer {
        throw Error.expectedSingleValue
    }
}
