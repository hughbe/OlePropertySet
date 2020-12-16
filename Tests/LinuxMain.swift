import XCTest

import WindowsDataTypesTests

var tests = [XCTestCaseEntry]()
tests += ControlStreamTests.allTests()
tests += DictionaryEntryTests.allTests()
tests += DictionaryTests.allTests()
tests += DumpFileTests.allTests()
tests += PropertySetStreamTests.allTests()
tests += TypedPropertyValueTests.allTests()
XCTMain(tests)
