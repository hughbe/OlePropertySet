import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ControlStreamTests.allTests),
        testCase(DictionaryEntryTests.allTests),
        testCase(DictionaryTests.allTests),
        testCase(DumpFileTests.allTests),
        testCase(PropertySetStreamTests.allTests),
        testCase(PropertySetStreamTests.allTests),
        testCase(TypedPropertyValueTests.allTests),
    ]
}
#endif
