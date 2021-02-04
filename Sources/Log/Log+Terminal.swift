extension Log {
    public struct Terminal: LogProtocol {
        public static var shared: Terminal = {
            return Terminal()
        }()

        public func handle(_ message: Message) async {
            print("[\(message.level)] \(message.payload)")
        }
    }
}
