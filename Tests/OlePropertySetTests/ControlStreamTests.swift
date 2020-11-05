import XCTest
import DataStream
import CompoundFileReader
@testable import OlePropertySet

final class ControlStreamTests: XCTestCase {
    func testExample() throws {
        do {
            /// [MS-OLEPS] 3.2.1 Control Stream ("{4c8cc155-6c1e-11d1-8e41-00c04fb9386d}")
            /// The following table shows the binary contents of the control stream, which is required for a file containing one or more
            /// property sets stored using the alternate stream binding. This stream is identified by its name,
            /// "{4c8cc155-6c1e-11d1-8e41-00c04fb9386d}", as specified in section 2.24.3.
            let data = Data([
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
            ])
            var dataStream = DataStream(data: data)
            let stream = try ControlStream(dataStream: &dataStream, size: dataStream.count)
            XCTAssertEqual(0x0000, stream.reserved1)
            XCTAssertEqual(0x0000, stream.reserved2)
            XCTAssertEqual(0x00000000, stream.applicationState)
            XCTAssertNil(stream.clsid)
            XCTAssertEqual(0, dataStream.remainingCount)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
