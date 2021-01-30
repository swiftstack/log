extension Log {
    public struct Terminal: LogProtocol {
        public static var shared: Terminal = {
            return Terminal()
        }()

        public var format: ((Message) -> String) = { message in
            return "[\(message.level)] \(message.payload)"
        }

        public func handle(_ message: Message) async {
            print(format(message))
        }
    }
}
