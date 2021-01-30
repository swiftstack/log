import Test
@testable import Log

class TestLog: LogProtocol {
    var output: String = ""

    func format(_ message: Log.Message) -> String {
        return "[\(message.level)] \(message.payload)"
    }

    func handle(_ message: Log.Message) {
        output = format(message)
    }
}

test.case("basic functions") {
    let testLog = TestLog()
    Log.use(testLog)

    await Log.debug("message")
    expect(testLog.output == "[debug] message")

    await Log.info("message")
    expect(testLog.output == "[info] message")

    await Log.warning("message")
    expect(testLog.output == "[warning] message")

    await Log.error("message")
    expect(testLog.output == "[error] message")

    await Log.critical("message")
    expect(testLog.output == "[critical] message")
}

test.case("log levels") {
    let testLog = TestLog()
    Log.use(testLog)

    let currentLevel = Log.level

    Log.level = .debug
    await Log.debug("message")
    expect(testLog.output == "[debug] message")
    testLog.output = ""

    Log.level = .info
    await Log.debug("message")
    expect(testLog.output.isEmpty)

    await Log.info("message")
    expect(testLog.output == "[info] message")
    testLog.output = ""

    Log.level = .warning
    await Log.debug("message")
    expect(testLog.output.isEmpty)

    await Log.warning("message")
    expect(testLog.output == "[warning] message")
    testLog.output = ""

    Log.level = .error
    await Log.debug("message")
    expect(testLog.output.isEmpty)

    await Log.error("message")
    expect(testLog.output == "[error] message")
    testLog.output = ""

    Log.level = .critical
    await Log.debug("message")
    expect(testLog.output.isEmpty)

    await Log.critical("message")
    expect(testLog.output == "[critical] message")

    Log.level = currentLevel
}

test.case(".isEnabled") {
    let testLog = TestLog()
    Log.use(testLog)

    Log.isEnabled = false
    await Log.debug("message")
    expect(testLog.output.isEmpty)

    Log.isEnabled = true
    await Log.debug("message")
}

test.run()
