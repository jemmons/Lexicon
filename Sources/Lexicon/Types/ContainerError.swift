import Foundation



public enum ContainerError: LocalizedError {
    case couldNotDecodeIndex(index: Int, type: Any.Type)
    case keyNotFound(key: CodingKey)
    case couldNotDecodeKey(key: CodingKey, type: Any.Type)
    case expectedNesting(key: CodingKey)
    case omittedInStrict
}



public extension ContainerError {
    var errorDescription: String? {
        switch self {
        case let .couldNotDecodeIndex(i, t):
            return "Could not decode value at index \(i) to type “\(t)”."
        case .keyNotFound(let k):
            return "The key “\(k.stringValue)” was not found in the dictionary."
        case let .couldNotDecodeKey(k, t):
            return "Could not decode value at key “\(k.stringValue)” to type “\(t)”."
        case .expectedNesting(let k):
            return "Expected a nested value at “\(k.stringValue)”, but dictionary must be flat."
        case .omittedInStrict:
            return "Strict mode does not allow for omitted optional values. Explicitly set to `nil` instead."
        }
    }
}



extension ContainerError: Equatable {
    public static func == (lhs: ContainerError, rhs: ContainerError) -> Bool {
        switch (lhs, rhs) {
        case (.couldNotDecodeIndex, .couldNotDecodeIndex),
            (.keyNotFound, .keyNotFound),
            (.couldNotDecodeKey, .couldNotDecodeKey),
            (.expectedNesting, .expectedNesting),
            (.omittedInStrict, .omittedInStrict):
            return true
            
        case (.couldNotDecodeIndex, _),
            (.keyNotFound, _),
            (.couldNotDecodeKey, _),
            (.expectedNesting, _),
            (.omittedInStrict, _):
            return false
        }
    }
}
