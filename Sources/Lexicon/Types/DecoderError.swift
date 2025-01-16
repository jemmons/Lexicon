import Foundation



public enum DecoderError: LocalizedError, Equatable {
    case expectedSingleValue(String)
    case expectedArray
    case expectedDictionary
}



public extension DecoderError {
    var errorDescription: String? {
        switch self {
        case let .expectedSingleValue(description):
            return "Expected single value, but found \(description)."
        case .expectedArray:
            return "Expected array, but found dictionary."
        case .expectedDictionary:
            return "Expected dictionary, but found array."
        }
    }
}
