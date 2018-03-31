import Test
import File
@testable import Log

class LogFileTests: TestCase {
    var temp = Path(string: "/tmp/LogFileTests")

    var enabled: Bool! = nil
    var level: Log.Level! = nil
    var format: ((Log.Level, String) -> String)! = nil
    var delegate: ((String) -> Void)! = nil

    override func setUp() {
        try? Directory.create(at: temp)

        enabled = Log.enabled
        level = Log.level
        format = Log.format
        delegate = Log.delegate
    }

    override func tearDown() {
        try? Directory.remove(at: temp)

        Log.enabled = enabled
        Log.level = level
        Log.format = format
        Log.delegate = delegate
    }

    func testLogFile() {
        scope {
            let file = File(name: #function, at: temp)
            assertFalse(file.isExists)

            try Log.write(to: file)
            Log.info("message")

            assertTrue(file.isExists)
        }

        scope {
            let file = File(name: #function, at: temp)
            let stream = try file.open(flags: .read).inputStream
            let content = try stream.readUntilEnd(as: String.self)
            assertEqual(content, "[info] message\n")
        }
    }


    static var allTests = [
        ("testLogFile", testLogFile),
    ]
}
