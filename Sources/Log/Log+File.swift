import File

extension Log {
    public static func writeToFile(atPath path: String) throws {
        try writeToFile(at: Path(string: path))
    }

    public static func writeToFile(at path: Path) throws {
        let file = try File(path: path)
        try write(to: file)
    }

    public static func write(to file: File) throws {
        if !file.isExists {
            try file.create(withIntermediateDirectories: true)
        }
        let stream = try file.open(flags: .write)
        try stream.seek(to: .end)
        delegate = { message in
            do {
                try stream.write(message)
                try stream.write("\n")
                try stream.flush()
            } catch {
                print("can't write log message:", message)
            }
        }
    }
}
