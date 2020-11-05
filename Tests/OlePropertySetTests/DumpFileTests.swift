import XCTest
import CompoundFileReader
@testable import OlePropertySet

final class DumpFileTests: XCTestCase {
    static func dump(propertyStream: PropertySetStream) -> String {
        var s = ""
        
        func escape(string: String) -> String {
            var s = ""
            for c in string.unicodeScalars {
                s += c.escaped(asASCII: true)
            }
            
            return "\"\(s)\""
        }

        func dump(value: Any?) -> String {
            guard let value = value else {
                return "nil"
            }
            
            if type(of: value) == UInt64.self {
               return (value as! UInt64).hexString
            } else if type(of: value) == UInt32.self {
                return (value as! UInt32).hexString
            } else if type(of: value) == UInt16.self {
                return (value as! UInt16).hexString
            } else if type(of: value) == UInt8.self {
                return (value as! UInt8).hexString
            } else if type(of: value) == Int64.self {
                return (value as! Int64).hexString
             } else if type(of: value) == Int32.self {
                 return (value as! Int32).hexString
             } else if type(of: value) == Int16.self {
                 return (value as! Int16).hexString
             } else if type(of: value) == Int8.self {
                 return (value as! Int8).hexString
             } else if type(of: value) == String.self {
                return escape(string: (value as! String))
             } else if type(of: value) == Date.self {
                return (value as! Date).description
             } else if type(of: value) == Bool.self {
                return (value as! Bool) ? "true" : "false"
             } else if type(of: value) == [String].self {
                return "[\((value as! [String]).map(escape).joined(separator: ", "))]"
             } else if type(of: value) == [Any?].self {
                return "[\((value as! [Any?]).map(dump(value:)).joined(separator: ", "))]"
             } else if type(of: value) == [UInt64].self {
                return (value as! [UInt64]).hexString
             } else if type(of: value) == [UInt32].self {
                return (value as! [UInt32]).hexString
             } else if type(of: value) == [UInt16].self {
                return (value as! [UInt16]).hexString
             } else if type(of: value) == [UInt8].self {
                return (value as! [UInt8]).hexString
             } else if type(of: value) == [Int64].self {
                return (value as! [Int64]).hexString
             } else if type(of: value) == [Int32].self {
                return (value as! [Int32]).hexString
             } else if type(of: value) == [Int16].self {
                return (value as! [Int16]).hexString
             } else if type(of: value) == [Int8].self {
                return (value as! [Int8]).hexString
             } else if type(of: value) == Double.self {
                return (value as! Double).description
             } else if type(of: value) == Float.self {
                return (value as! Float).description
             } else if type(of: value) == ClipboardData.self {
                let clipboardData = (value as! ClipboardData)
                return "ClipboardData(format: \(clipboardData.format.hexString), data: \(clipboardData.data.hexString))"
             } else if type(of: value) == IndirectPropertyName.self {
                let indirectPropertyName = (value as! IndirectPropertyName)
                return "IndirectPropertyName(type: \(indirectPropertyName.type), name: \(escape(string: indirectPropertyName.name))"
             } else if type(of: value) == VersionedStream.self {
                let versionedStream = (value as! VersionedStream)
                return "VersionedStream(guid: \"\(versionedStream.versionGuid)\", streamName: \(escape(string: versionedStream.streamName.name))"
             } else {
                fatalError("NYI: \(type(of: value))")
             }
        }
        
        func dump(propertySet: PropertySet) -> String {
            var s = ""
            
            func keyString(propertyIdentifier: PropertyIdentifier) -> String {
                if let name = propertySet.dictionary?.identifierMapping[propertyIdentifier] {
                    return name
                }
                
                if propertyIdentifier == CODEPAGE_PROPERTY_IDENTIFIER {
                    return "PID_CODEPAGE"
                } else if propertyIdentifier == LOCALE_PROPERTY_IDENTIFIER {
                    return "PID_LOCALE"
                } else if propertyIdentifier == MODIFY_TIME_PROPERTY_IDENTIFIER {
                    return "PID_MODIFY_TIME"
                } else if propertyIdentifier == SECURITY_PROPERTY_IDENTIFIER {
                    return "PID_SECURITY"
                } else if propertyIdentifier == BEHAVIOR_PROPERTY_IDENTIFIER {
                    return "PID_LOCALE"
                }
                
                return propertyIdentifier.hexString
            }
            
            let sorted = propertySet.properties.sorted { $0.key < $1.key }
            for (key, value) in sorted {
                s += "\(keyString(propertyIdentifier: key)): \(dump(value: value))\n"
            }
            
            return s
        }
        
        s += "Property Set 0: \(propertyStream.fmtid0)\n"
        s += dump(propertySet: propertyStream.propertySet0)
        
        if let propertySet1 = propertyStream.propertySet1 {
            s += "\n"
            s += "Property Set 1: \(propertyStream.fmtid1!)\n"
            s += dump(propertySet: propertySet1)
        }

        return s
    }
    
    func testDump() throws {
        for (name, fileExtension, storage) in [
            ("hughbe/sample", "doc", "\u{0005}SummaryInformation"),
            ("hughbe/sample", "doc", "\u{0005}DocumentSummaryInformation"),
            ("ironfede/openmcdf/_Test", "ppt", "\u{0005}SummaryInformation"),
            ("ironfede/openmcdf/_Test", "ppt", "\u{0005}DocumentSummaryInformation"),
            ("ironfede/openmcdf/2_MB-W", "ppt", "\u{0005}SummaryInformation"),
            ("ironfede/openmcdf/2_MB-W", "ppt", "\u{0005}DocumentSummaryInformation"),
            ("ironfede/openmcdf/english.presets", "doc", "\u{0005}SummaryInformation"),
            ("ironfede/openmcdf/english.presets", "doc", "\u{0005}DocumentSummaryInformation"),
            ("ironfede/openmcdf/mediationform", "doc", "\u{0005}SummaryInformation"),
            ("ironfede/openmcdf/mediationform", "doc", "\u{0005}DocumentSummaryInformation"),
            ("ironfede/openmcdf/poWEr.prelim", "doc", "\u{0005}SummaryInformation"),
            ("ironfede/openmcdf/poWEr.prelim", "doc", "\u{0005}DocumentSummaryInformation"),
            ("ironfede/openmcdf/report_name_fix", "xls", "\u{0005}SummaryInformation"),
            ("ironfede/openmcdf/report_name_fix", "xls", "\u{0005}DocumentSummaryInformation"),
            ("ironfede/openmcdf/report", "xls", "\u{0005}SummaryInformation"),
            ("ironfede/openmcdf/report", "xls", "\u{0005}DocumentSummaryInformation"),
            ("ironfede/openmcdf/reportREAD", "xls", "\u{0005}SummaryInformation"),
            ("ironfede/openmcdf/reportREAD", "xls", "\u{0005}DocumentSummaryInformation"),
            ("ironfede/openmcdf/wstr_presets", "doc", "\u{0005}SummaryInformation"),
            ("ironfede/openmcdf/wstr_presets", "doc", "\u{0005}DocumentSummaryInformation"),
            ("decalage2/olefile/test-ole-file", "doc", "\u{0005}SummaryInformation"),
            ("decalage2/olefile/test-ole-file", "doc", "\u{0005}DocumentSummaryInformation"),
        ] {
            let data = try getData(name: name, fileExtension: fileExtension)
            let file = try CompoundFile(data: data)
            var rootStorage = file.rootStorage
            var dataStream = rootStorage.children[storage]!.dataStream
            let summaryInformation = try PropertySetStream(dataStream: &dataStream)
            print(DumpFileTests.dump(propertyStream: summaryInformation))
        }
    }

    static var allTests = [
        ("testDump", testDump),
    ]
}
