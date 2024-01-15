public protocol LogProtocol {
    func handle(_ message: Log.Message) async
}

public struct Log {
    public static var isEnabled: Bool = true
    public static var level: Message.Level = .debug

    static var delegate: LogProtocol = Log.Terminal.shared

    public static func use(_ delegate: LogProtocol) {
        self.delegate = delegate
    }

    static func isEnabled(for level: Message.Level) -> Bool {
        return self.level.rawValue <= level.rawValue
    }

    @usableFromInline
    static func handle(message: Message) async {
        if isEnabled && isEnabled(for: message.level) {
            await delegate.handle(message)
        }
    }

    @usableFromInline
    static func handle(
        level: Message.Level,
        source: Message.Source,
        message: () -> String
    ) async {
        if isEnabled && isEnabled(for: level) {
            await delegate.handle(.init(
                level: level,
                source: source,
                payload: .string(message())))
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
    public static func debug(
        _ message: @autoclosure () -> String,
        source: Message.Source = .init()
    ) async {
        if isDebugBuild {
            await handle(level: .debug, source: source, message: message)
        }
    }

    public static func info(
        _ message: @autoclosure () -> String,
        source: Message.Source = .init()
    ) async {
        await handle(level: .info, source: source, message: message)
    }

    public static func warning(
        _ message: @autoclosure () -> String,
        source: Message.Source = .init()
    ) async {
        await handle(level: .warning, source: source, message: message)
    }

    public static func error(
        _ message: @autoclosure () -> String,
        source: Message.Source = .init()
    ) async {
        await handle(level: .error, source: source, message: message)
    }

    public static func critical(
        _ message: @autoclosure () -> String,
        source: Message.Source = .init()
    ) async {
        await handle(level: .critical, source: source, message: message)
    }
}
