public struct Log {
    public enum Level: Int {
        case debug, info, warning, error, critical
    }

    public static var enabled: Bool = true
    public static var level: Level = .debug

    public static var delegate: ((String) -> Void) = { message in
        print(message)
    }

    public static var format: ((Level, String) -> String) = { level, message in
        return "[\(level)] \(message)"
    }

    @usableFromInline
    static func handle(event level: Level, message: @autoclosure () -> String) {
        if enabled && level.isEnabled {
            delegate(format(level, message()))
        }
    }

    // suppress warning
    @usableFromInline
    static var isDebugBuild: Bool {
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

extension Log.Level {
    var isEnabled: Bool {
        return Log.level.rawValue <= self.rawValue
    }
}

extension Log.Level: CustomStringConvertible {
    public var description: String {
        switch self {
        case .debug: return "debug"
        case .info: return "info"
        case .warning: return "warning"
        case .error: return "error"
        case .critical: return "critical"
        }
    }
}
