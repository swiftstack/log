import Test
@testable import Log

class LogTests: TestCase {
    class TestLog: LogProtocol {
        var output: String = ""

        func format(_ message: Log.Message) -> String {
            return "[\(message.level)] \(message.payload)"
        }

        func handle(_ message: Log.Message) {
            output = format(message)
        }
    }

    // As it is a global object
    // use single function to avoid
    // data races or complex synchronization

    func testLog() {
        testBasicFunctions()
        testLogLevels()
        testEnabled()
    }

    private func testBasicFunctions() {
        let testLog = TestLog()
        Log.use(testLog)

        Log.debug("message")
        expect(testLog.output == "[debug] message")

        Log.info("message")
        expect(testLog.output == "[info] message")

        Log.warning("message")
        expect(testLog.output == "[warning] message")

        Log.error("message")
        expect(testLog.output == "[error] message")

        Log.critical("message")
        expect(testLog.output == "[critical] message")
    }

    private func testLogLevels() {
        let testLog = TestLog()
        Log.use(testLog)

        let currentLevel = Log.level

        Log.level = .debug
        Log.debug("message")
        expect(testLog.output == "[debug] message")
        testLog.output = ""

        Log.level = .info
        Log.debug("message")
        expect(testLog.output.isEmpty)

        Log.info("message")
        expect(testLog.output == "[info] message")
        testLog.output = ""

        Log.level = .warning
        Log.debug("message")
        expect(testLog.output.isEmpty)

        Log.warning("message")
        expect(testLog.output == "[warning] message")
        testLog.output = ""

        Log.level = .error
        Log.debug("message")
        expect(testLog.output.isEmpty)

        Log.error("message")
        expect(testLog.output == "[error] message")
        testLog.output = ""

        Log.level = .critical
        Log.debug("message")
        expect(testLog.output.isEmpty)

        Log.critical("message")
        expect(testLog.output == "[critical] message")

        Log.level = currentLevel
    }

    private func testEnabled() {
        let testLog = TestLog()
        Log.use(testLog)

        Log.isEnabled = false
        Log.debug("message")
        expect(testLog.output.isEmpty)

        Log.isEnabled = true
        Log.debug("message")
    }
}
