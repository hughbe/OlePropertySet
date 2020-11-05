import XCTest
import DataStream
import CompoundFileReader
@testable import OlePropertySet

final class DictionaryEntryTests: XCTestCase {
    func testExample() throws {
        do {
            /// [MS-OLEPS] 3.2.2.1.4.1 Dictionary Entry 0
            /// Entry 0 of the Dictionary (section 3.2.2.1.4) property is an instance of the DictionaryEntry structure defined in section 2.16.
            let data = Data([
                0x04, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00, 0x44, 0x00, 0x69, 0x00, 0x73, 0x00, 0x70, 0x00, 0x6C, 0x00, 0x61, 0x00, 0x79, 0x00, 0x43, 0x00, 0x6F, 0x00, 0x6C, 0x00, 0x6F, 0x00, 0x75, 0x00, 0x72, 0x00, 0x00, 0x00,
            ])
            var dataStream = DataStream(data: data)
            let entry = try DictionaryEntry(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(0x00000004, entry.propertyIdentifier)
            XCTAssertEqual(0x0000000E, entry.length)
            XCTAssertEqual("DisplayColour", entry.name)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.4.2 Dictionary Entry 1
            /// Entry 1 of the Dictionary (section 3.2.2.1.4) property is an instance of the DictionaryEntry structure defined in section 2.16.
            let data = Data([
                0x06, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x4D, 0x00, 0x79, 0x00, 0x53, 0x00, 0x74, 0x00, 0x72, 0x00, 0x65, 0x00, 0x61, 0x00, 0x6D, 0x00, 0x00, 0x00, 0x00, 0x00,
            ])
            var dataStream = DataStream(data: data)
            let entry = try DictionaryEntry(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(0x00000006, entry.propertyIdentifier)
            XCTAssertEqual(0x00000009, entry.length)
            XCTAssertEqual("MyStream", entry.name)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.4.3 Dictionary Entry 2
            /// Entry 2 of the Dictionary (section 3.2.2.1.4) property is an instance of the DictionaryEntry structure defined in section 2.16.
            let data = Data([
                0x07, 0x00, 0x00, 0x00, 0x0B, 0x00, 0x00, 0x00,  0x50, 0x00, 0x72, 0x00, 0x69, 0x00, 0x63, 0x00, 0x65, 0x00, 0x28, 0x00, 0x47, 0x00, 0x42, 0x00, 0x50, 0x00, 0x29, 0x00, 0x00, 0x00, 0x00, 0x00,
            ])
            var dataStream = DataStream(data: data)
            let entry = try DictionaryEntry(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(0x00000007, entry.propertyIdentifier)
            XCTAssertEqual(0x0000000B, entry.length)
            XCTAssertEqual("Price(GBP)", entry.name)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.4.4 Dictionary Entry 3
            /// Entry 3 of the Dictionary (section 3.2.2.1.4) property is an instance of the DictionaryEntry structure defined in section 2.16.
            let data = Data([
                0x0C, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x4D, 0x00, 0x79, 0x00, 0x53, 0x00, 0x74, 0x00, 0x6F, 0x00, 0x72, 0x00, 0x61, 0x00, 0x67, 0x00, 0x65, 0x00, 0x00, 0x00,
            ])
            var dataStream = DataStream(data: data)
            let entry = try DictionaryEntry(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(0x0000000C, entry.propertyIdentifier)
            XCTAssertEqual(0x0000000A, entry.length)
            XCTAssertEqual("MyStorage", entry.name)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.4.5 Dictionary Entry 4
            /// Entry 4 of the Dictionary (section 3.2.2.1.4) property is an instance of the DictionaryEntry structure defined in section 2.16.
            let data = Data([
                0x27, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00, 0x43, 0x00, 0x61, 0x00, 0x73, 0x00, 0x65, 0x00, 0x53, 0x00, 0x65, 0x00, 0x6E, 0x00, 0x73, 0x00, 0x69, 0x00, 0x74, 0x00, 0x69, 0x00, 0x76, 0x00, 0x65, 0x00, 0x00, 0x00,
            ])
            var dataStream = DataStream(data: data)
            let entry = try DictionaryEntry(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(0x00000027, entry.propertyIdentifier)
            XCTAssertEqual(0x0000000E, entry.length)
            XCTAssertEqual("CaseSensitive", entry.name)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.4.6 Dictionary Entry 5
            /// Entry 5 of the Dictionary (section 3.2.2.1.4) property is an instance of the DictionaryEntry structure defined in section 2.16.
            let data = Data([
                0x92, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00, 0x43, 0x00, 0x41, 0x00, 0x53, 0x00, 0x45, 0x00, 0x53, 0x00, 0x45, 0x00, 0x4E, 0x00, 0x53, 0x00, 0x49, 0x00, 0x54, 0x00, 0x49, 0x00, 0x56, 0x00, 0x45, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data: data)
            let entry = try DictionaryEntry(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(0x00000092, entry.propertyIdentifier)
            XCTAssertEqual(0x0000000E, entry.length)
            XCTAssertEqual("CASESENSITIVE", entry.name)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
