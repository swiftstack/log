extension Log {
    public struct Message {
        public let level: Level
        public let source: Source
        public let payload: Payload

        public init(level: Level, source: Source, payload: Payload) {
            self.level = level
            self.source = source
            self.payload = payload
        }

        public enum Level: Int, Equatable {
            case debug, info, warning, error, critical
        }

        public struct Source {
            public let file: String
            public let line: Int
            public let function: String

            public init(
                file: String = #file,
                line: Int = #line,
                function: String = #function)
            {
                self.file = file
                self.line = line
                self.function = function
            }
        }

        public enum Payload {
            case object(Swift.Encodable)
            case error(Swift.Error)
            case string(String)
        }
    }
}

extension Log.Message.Level: CustomStringConvertible {
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

extension Log.Message.Payload: CustomStringConvertible {
    public var description: String {
        switch self {
        case .object(let encodable): return "\(encodable)"
        case .error(let error): return "\(error)"
        case .string(let string): return string
        }
    }
}
