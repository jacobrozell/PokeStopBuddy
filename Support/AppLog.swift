import Foundation
import OSLog

/// Structured logging facade. Swappable sinks later (OSLog → analytics). Telemetry is
/// off by default in v1.0; this only writes to the unified log.
public enum AppLog {
    private static let subsystem = "com.jacobrozell.waypointwriter"

    public static let app = Logger(subsystem: subsystem, category: "app")
    public static let data = Logger(subsystem: subsystem, category: "data")
    public static let generation = Logger(subsystem: subsystem, category: "generation")
}
