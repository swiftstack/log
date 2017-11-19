import Test
import Dispatch
import Foundation
@testable import Log

class LogFileTests: TestCase {
    var enabled: Bool! = nil
    var level: Log.Level! = nil
    var format: ((Log.Level, String) -> String)! = nil
    var delegate: ((String) -> Void)! = nil

    override func setUp() {
        enabled = Log.enabled
        level = Log.level
        format = Log.format
        delegate = Log.delegate
    }

    override func tearDown() {
        Log.enabled = enabled
        Log.level = level
        Log.format = format
        Log.delegate = delegate
    }

    func testLogFile() {
        let path = "/var/tmp/\(UUID().uuidString)"
        assertFalse(FileManager.default.fileExists(atPath: path))

        Log.writeToFile(atPath: path)
        Log.info("message")

        assertTrue(FileManager.default.fileExists(atPath: path))
        guard let data = FileManager.default.contents(atPath: path) else {
            fail("invalid data")
            return
        }
        guard let text = String(data: data, encoding: .utf8) else {
            fail("invalid string")
            return
        }
        assertEqual(text, "[info] message\n")
        try? FileManager.default.removeItem(atPath: path)
    }


    static var allTests = [
        ("testLogFile", testLogFile),
    ]
}
