import XCTest
import DataStream
import CompoundFileReader
import WindowsDataTypes
@testable import OlePropertySet

final class TypedPropertyValueTests: XCTestCase {
    func testExample() throws {
        do {
            /// [MS-OLEPS] 3.1.1 CodePage Property
            /// The CodePage property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x02, 0x00, 0x00, 0x00, 0xE4, 0x04, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
            XCTAssertEqual(.i2, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(0x04E4, property.value as! Int16)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.2 PIDSI_TITLE
            /// The PIDSI_TITLE property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x1E, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x4A, 0x6F, 0x65, 0x27, 0x73, 0x20, 0x64, 0x6F,
                0x63, 0x75, 0x6D, 0x65, 0x6E, 0x74, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: 0x04E4)
            XCTAssertEqual(.lpstr, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual("Joe's document", property.value as! String)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.3 PIDSI_SUBJECT
            /// The PIDSI_SUBJECT property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x1E, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x4A, 0x6F, 0x62, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: 0x04E4)
            XCTAssertEqual(.lpstr, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual("Job", property.value as! String)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.4 PIDSI_AUTHOR
            /// The PIDSI_AUTHOR property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x1E, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x4A, 0x6F, 0x65, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: 0x04E4)
            XCTAssertEqual(.lpstr, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual("Joe", property.value as! String)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.5 PIDSI_KEYWORDS
            /// The PIDSI_KEYWORDS property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x1E, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: 0x04E4)
            XCTAssertEqual(.lpstr, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual("\0\0\0", property.value as! String)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.6 PIDSI_COMMENTS
            /// The PIDSI_COMMENTS property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x1E, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: 0x04E4)
            XCTAssertEqual(.lpstr, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual("\0\0\0", property.value as! String)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.7 PIDSI_TEMPLATE
            /// The PIDSI_TEMPLATE property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x1E, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x4E, 0x6F, 0x72, 0x6D, 0x61, 0x6C, 0x2E, 0x64, 0x6F, 0x74, 0x6D, 0x00,
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: 0x04E4)
            XCTAssertEqual(.lpstr, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual("Normal.dotm", property.value as! String)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.8 PIDSI_LASTAUTHOR
            /// The PIDSI_LASTAUTHOR property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x1E, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x43, 0x6F, 0x72, 0x6E, 0x65, 0x6C, 0x69, 0x75, 0x73, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: 0x04E4)
            XCTAssertEqual(.lpstr, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual("Cornelius", property.value as! String)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.9 PIDSI_REVNUMBER
            /// The PIDSI_REVNUMBER property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x1E, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x36, 0x36, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: 0x04E4)
            XCTAssertEqual(.lpstr, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual("66\0", property.value as! String)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.10 PIDSI_APPNAME
            /// The PIDSI_APPNAME property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x1E, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x4D, 0x69, 0x63, 0x72, 0x6F, 0x73, 0x6F, 0x66,
                0x74, 0x20, 0x4F, 0x66, 0x66, 0x69, 0x63, 0x65, 0x20, 0x57, 0x6F, 0x72, 0x64, 0x00, 0x00, 0x00,
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: 0x04E4)
            XCTAssertEqual(.lpstr, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual("Microsoft Office Word\0\0", property.value as! String)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.11 PIDSI_EDITTIME
            /// The PIDSI_EDITTIME property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x40, 0x00, 0x00, 0x00, 0x00, 0x6E, 0xD9, 0xA2, 0x42, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
            XCTAssertEqual(.filetime, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(-11644444980.0, (property.value as! Date).timeIntervalSince1970)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.12 PIDSI_LASTPRINTED
            /// The PIDSI_LASTPRINTED property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x40, 0x00, 0x00, 0x00, 0x00, 0x16, 0xD0, 0xA1, 0x4E, 0x8E, 0xC6, 0x01
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
            XCTAssertEqual(.filetime, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(1150137180.0, (property.value as! Date).timeIntervalSince1970)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.13 PIDSI_CREATE_DTM
            /// The PIDSI_CREATE_DTM property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x40, 0x00, 0x00, 0x00, 0x00, 0x1C, 0xF2, 0xD5, 0x2A, 0xCE, 0xC6, 0x01
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
            XCTAssertEqual(.filetime, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(1157158680.0, (property.value as! Date).timeIntervalSince1970)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.14 PIDSI_LASTSAVE_DTM
            /// The PIDSI_LASTSAVE_DTM property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x40, 0x00, 0x00, 0x00, 0x00, 0x3C, 0xD2, 0x73, 0xDD, 0x80, 0xC8, 0x01
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
            XCTAssertEqual(.filetime, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(1204954199.0, (property.value as! Date).timeIntervalSince1970)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.15 PIDSI_PAGECOUNT
            /// The PIDSI_PAGECOUNT property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x03, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
            XCTAssertEqual(.i4, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(14, (property.value as! Int32))
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.16 PIDSI_WORDCOUNT
            /// The PIDSI_WORDCOUNT property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x03, 0x00, 0x00, 0x00, 0xE5, 0x0D, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
            XCTAssertEqual(.i4, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(3557, (property.value as! Int32))
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.17 PIDSI_CHARCOUNT
            /// The PIDSI_CHARCOUNT property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x03, 0x00, 0x00, 0x00, 0x38, 0x4F, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
            XCTAssertEqual(.i4, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(20280, (property.value as! Int32))
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.1.18 PIDSI_DOC_SECURITY
            /// The PIDSI_DOC_SECURITY property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
            XCTAssertEqual(.i4, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(0x00000000, (property.value as! Int32))
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.1 CodePage
            /// The CodePage property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x02, 0x00, 0x00, 0x00, 0xB0, 0x04, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
            XCTAssertEqual(.i2, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(0x04B0, property.value as! Int16)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.2 Locale
            /// The Locale property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x13, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09, 0x08
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
            XCTAssertEqual(.ui4, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(0x08090000, property.value as! UInt32)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.3 Behavior
            /// The Behavior property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x13, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
            XCTAssertEqual(.ui4, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(0x00000001, property.value as! UInt32)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.5 DisplayColour
            /// The DisplayColour property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x08, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x47, 0x00, 0x72, 0x00, 0x65, 0x00, 0x79, 0x00, 0x00, 0x00, 0x00, 0x00,
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(.bstr, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual("Grey", property.value as! String)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.6 MyStream
            /// The MyStream property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x49, 0x00, 0x00, 0x00, 0xCA, 0x84, 0x95, 0xF9, 0x23, 0xCA, 0x0B, 0x47, 0x83, 0x94, 0x22, 0x01, 0x77, 0x90, 0x7A, 0xAD, 0x0C, 0x00, 0x00, 0x00, 0x70, 0x00, 0x72, 0x00, 0x6F, 0x00, 0x70, 0x00, 0x36, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(.versionedStream, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(GUID(0xF99584CA, 0xCA23, 0x470B, 0xAD7A907701229483), (property.value as! VersionedStream).versionGuid)
            XCTAssertEqual(.versionedStream, (property.value as! VersionedStream).streamName.type)
            XCTAssertEqual("prop6", (property.value as! VersionedStream).streamName.name)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.7 Price(GBP)
            /// The Price(GBP) property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x06, 0x00, 0x00, 0x00, 0x00, 0x50, 0x14, 0x00, 0x00, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(.cy, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(133.12, property.value as! Double)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.8 MyStorage
            /// The MyStorage property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x45, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00, 0x70, 0x00, 0x72, 0x00, 0x6F, 0x00, 0x70, 0x00, 0x31, 0x00, 0x32, 0x00, 0x00, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(.storedObject, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(.storedObject, (property.value as! IndirectPropertyName).type)
            XCTAssertEqual("prop12", (property.value as! IndirectPropertyName).name)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.9 CaseSensitive Mixed Case
            /// The CaseSensitive property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x10, 0x20, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0xF8, 0x14, 0x17, 0x12, 0x87, 0x45, 0x29, 0x25, 0x11, 0x33, 0x56, 0x79, 0xA2, 0x9C, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(.arrayI1, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual([3, -8, 20, 23, 18, -121, 69, 41, 37, 17, 51, 86, 121, -94, -100], property.value as! [Int8])
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.10 CASESENSITIVE All Uppercase
            /// The CASESENSITIVE All Uppercase property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x0C, 0x10, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0xA9, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0xA9, 0x00, 0x76, 0x99, 0x3B, 0x22, 0x10, 0x9C
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(.vectorVariant, property.type)
            XCTAssertEqual(0, property.padding)
            let value = property.value as! [Any?]
            XCTAssertEqual(2, value.count)
            XCTAssertEqual(0xA9, value[0] as! UInt8)
            XCTAssertEqual(-7201218164792360791, value[1] as! Int64)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.10 CASESENSITIVE All Uppercase
            /// The CASESENSITIVE All Uppercase property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x11, 0x00, 0x00, 0x00, 0xA9, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(.ui1, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(0xA9, property.value as! UInt8)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
        do {
            /// [MS-OLEPS] 3.2.2.1.10 CASESENSITIVE All Uppercase
            /// The CASESENSITIVE All Uppercase property is an instance of the TypedPropertyValue structure defined in section 2.15.
            let data = Data([
                0x14, 0x00, 0x00, 0x00, 0xA9, 0x00, 0x76, 0x99, 0x3B, 0x22, 0x10, 0x9C
            ])
            var dataStream = DataStream(data)
            let property = try TypedPropertyValue(dataStream: &dataStream, codePage: CodePageString.CP_WINUNICODE)
            XCTAssertEqual(.i8, property.type)
            XCTAssertEqual(0, property.padding)
            XCTAssertEqual(-7201218164792360791, property.value as! Int64)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
