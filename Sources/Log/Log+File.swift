import class Foundation.FileManager
import class Foundation.FileHandle

extension Log {
    public static func writeToFile(atPath path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            guard FileManager.default.createFile(
                atPath: path, contents: nil) else {
                    fatalError("can't create log file at \(path)")
            }
        }
        delegate = { message in
            guard let log = FileHandle(forUpdatingAtPath: path),
                let data = message.appending("\n").data(using: .utf8) else {
                    return
            }
            log.seekToEndOfFile()
            log.write(data)
            log.closeFile()
        }
    }
}
