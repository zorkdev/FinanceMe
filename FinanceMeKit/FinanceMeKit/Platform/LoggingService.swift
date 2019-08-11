import os.log

public protocol LoggingServiceProvider {
    var loggingService: LoggingService { get }
}

public enum LogType: String {
    case info = "🔵"
    case error = "🔴"
}

public protocol LoggingService {
    func log(title: String, content: String, type: LogType)
}

public extension LoggingService {
    func log(title: String, content: String) {
        log(title: title, content: content, type: .info)
    }
}

class DefaultLoggingService: LoggingService {
    private let log: OSLog

    init(configService: ConfigService) {
        log = OSLog(subsystem: configService.productName, category: "Debug")
    }

    func log(title: String, content: String, type: LogType) {
        let logString = Self.createLogString(title: title, content: content, type: type)
        os_log("%@", log: log, type: .debug, logString)
    }

    static func createLogString(title: String, content: String, type: LogType) -> String {
        """

        \(type.rawValue) ********** \(title) *********
        \(content)
        *********************************

        """
    }
}
