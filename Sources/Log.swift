public enum Level: String {
    case debug, info, warning, error, critical
}

public struct Log {
    public static var disabled: Bool = false
    public static var delegate: ((Level, String) -> Void) = {
        print("[\($0)] \($1)")
    }

    static func handle(event level: Level, message: String) {
        if !disabled {
            delegate(level, message)
        }
    }

    // suppress warning
    static var isDebugBuild: Bool {
        @inline(__always) get {
            return _isDebugAssertConfiguration()
        }
    }

    public static func debug(_ message: String) {
        if isDebugBuild {
            handle(event: .debug, message: message)
        }
    }

    public static func info(_ message: String) {
        handle(event: .info, message: message)
    }

    public static func warning(_ message: String) {
        handle(event: .warning, message: message)
    }

    public static func error(_ message: String) {
        handle(event: .error, message: message)
    }

    public static func critical(_ message: String) {
        handle(event: .critical, message: message)
    }
}
