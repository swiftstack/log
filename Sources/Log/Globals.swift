public func log(
    level: Log.Message.Level,
    source: Log.Message.Source = .init(),
    message: String)
{
    Log.handle(level: level, source: source, message: message)
}
