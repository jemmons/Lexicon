import Foundation



struct ArrayInDictionaryDecoder: Decoder {
    enum Error: LocalizedError {
        case expectedSingleValue
        case expectedDictionary
        
        var errorDescription: String? {
            switch self {
            case .expectedDictionary:
                return "Expected a dictionary but found an array."
            case .expectedSingleValue:
                return "Expected a value but found an array."
            }
        }
    }
    let codingPath: [any CodingKey] = []
    let userInfo: [CodingUserInfoKey : Any] = [:]
    let array: [Any]
    
    func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
        return DictionaryUnkeyedDecodingContainer(array: array)
    }
    
    func singleValueContainer() throws -> any SingleValueDecodingContainer {
        throw Error.expectedSingleValue
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        throw Error.expectedDictionary
    }

}
