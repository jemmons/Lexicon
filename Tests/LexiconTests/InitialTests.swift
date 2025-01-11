import XCTest
import Lexicon


class InitialTests: XCTestCase {
    func testExists() {
        enum Keys: CodingKey {
            case foo
        }
        let subject = DictionaryKeyedDecodingContainer<Keys>(dictionary: [:])
        XCTAssertNotNil(subject)
    }
}
