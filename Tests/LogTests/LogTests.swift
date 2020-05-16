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
        expect(log.output == "[debug] log")

        Log.info("log")
        expect(log.output == "[info] log")

        Log.warning("log")
        expect(log.output == "[warning] log")

        Log.error("log")
        expect(log.output == "[error] log")

        Log.critical("log")
        expect(log.output == "[critical] log")
    }

    func testEnabled() {
        expect(Log.isEnabled)
        Log.isEnabled = false
        expect(!Log.isEnabled)

        let log = TestLog()
        Log.use(log)

        Log.debug("log")
        expect(log.output == "")
    }

    func testLevel() {
        let log = TestLog()
        Log.use(log)

        Log.debug("log")
        expect(log.output == "[debug] log")
        log.output = ""

        Log.level = .info
        Log.debug("log")
        expect(log.output == "")

        Log.info("log")
        expect(log.output == "[info] log")
        log.output = ""

        Log.level = .warning
        Log.debug("log")
        expect(log.output == "")

        Log.warning("log")
        expect(log.output == "[warning] log")
        log.output = ""

        Log.level = .error
        Log.debug("log")
        expect(log.output == "")

        Log.error("log")
        expect(log.output == "[error] log")
        log.output = ""

        Log.level = .critical
        Log.debug("log")
        expect(log.output == "")

        Log.critical("log")
        expect(log.output == "[critical] log")
    }
}
