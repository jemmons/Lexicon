import Foundation



public enum ContainerError: LocalizedError {
    case couldNotDecodeIndex(index: Int, type: String)
    case keyNotFound(key: CodingKey)
    case couldNotDecodeKey(key: CodingKey, type: String)
    case expectedNesting(key: CodingKey)

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
        }
    }
}
