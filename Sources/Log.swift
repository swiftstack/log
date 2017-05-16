public enum Level: String {
    case debug, info, warning, error, critical
}

public struct Log {
    public static var disabled: Bool = false
    public static var delegate: ((Level, String) -> Void) = {
        print("[\($0)] \($1)")
    }

    @_versioned
    static func handle(event level: Level, message: @autoclosure () -> String) {
        if !disabled {
            delegate(level, message())
        }
    }

    // suppress warning
    @_versioned static var isDebugBuild: Bool {
        @inline(__always) get {
            return _isDebugAssertConfiguration()
        }
    }

    @inline(__always)
    public static func debug(_ message: @autoclosure () -> String) {
        if isDebugBuild {
            handle(event: .debug, message: message())
        }
    }

    public static func info(_ message: @autoclosure () -> String) {
        handle(event: .info, message: message)
    }

    public static func warning(_ message: @autoclosure () -> String) {
        handle(event: .warning, message: message)
    }

    public static func error(_ message: @autoclosure () -> String) {
        handle(event: .error, message: message)
    }

    public static func critical(_ message: @autoclosure () -> String) {
        handle(event: .critical, message: message)
    }
}
