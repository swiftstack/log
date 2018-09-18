import Test
@testable import Log

class LogTests: TestCase {
    var isEnabled: Bool! = nil
    var level: Log.Message.Level! = nil
    var delegate: LogProtocol! = nil

    override func setUp() {
        isEnabled = Log.isEnabled
        level = Log.level
        delegate = Log.delegate
    }

    override func tearDown() {
        Log.isEnabled = isEnabled
        Log.level = level
        Log.delegate = delegate
    }

    class TestLog: LogProtocol {
        var output: String

        init() {
            output = ""
        }

        func format(_ message: Log.Message) -> String {
            return "[\(message.level)] \(message.payload)"
        }

        func handle(_ message: Log.Message) {
            output = format(message)
        }
    }

    func testLog() {
        let log = TestLog()
        Log.use(log)

        Log.debug("log")
        assertEqual(log.output, "[debug] log")

        Log.info("log")
        assertEqual(log.output, "[info] log")

        Log.warning("log")
        assertEqual(log.output, "[warning] log")

        Log.error("log")
        assertEqual(log.output, "[error] log")

        Log.critical("log")
        assertEqual(log.output, "[critical] log")
    }

    func testEnabled() {
        assertTrue(Log.isEnabled)
        Log.isEnabled = false
        assertFalse(Log.isEnabled)

        let log = TestLog()
        Log.use(log)

        Log.debug("log")
        assertEqual(log.output, "")
    }

    func testLevel() {
        let log = TestLog()
        Log.use(log)

        Log.debug("log")
        assertEqual(log.output, "[debug] log")
        log.output = ""

        Log.level = .info
        Log.debug("log")
        assertEqual(log.output, "")

        Log.info("log")
        assertEqual(log.output, "[info] log")
        log.output = ""

        Log.level = .warning
        Log.debug("log")
        assertEqual(log.output, "")

        Log.warning("log")
        assertEqual(log.output, "[warning] log")
        log.output = ""

        Log.level = .error
        Log.debug("log")
        assertEqual(log.output, "")

        Log.error("log")
        assertEqual(log.output, "[error] log")
        log.output = ""

        Log.level = .critical
        Log.debug("log")
        assertEqual(log.output, "")

        Log.critical("log")
        assertEqual(log.output, "[critical] log")
    }
}
