# OlePropertySet

Swift reader of OLE Property Sets defined in [MS-OLEPS](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-oleps/)


## Example Usage

Add the following line to your project's SwiftPM dependencies:
```swift
.package(url: "https://github.com/hughbe/OlePropertySet", from: "1.0.0"),
```

```swift
import CompoundFileReader
import MsgReader

let data = Data(contentsOfFile: "<path-to-file>.doc")!
let file = try CompoundFile(data: data)
var rootStorage = file.rootStorage
var dataStream = rootStorage.children["\u{0005}SummaryInformation"]!.dataStream
let summaryInformation = try PropertySetStream(dataStream: &dataStream)
print(summaryInformation)
```
