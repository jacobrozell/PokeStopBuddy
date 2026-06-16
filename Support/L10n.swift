import Foundation

/// Localization accessor. All user-facing strings route through here so no raw strings
/// live in views. Base locale `en` is the source of truth (specs/localization.md).
public enum L10n {
    /// Looks up `key` in the bundle's string table, returning the translation (or the
    /// key itself if missing). Pass `args` to fill format specifiers.
    public static func string(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return args.isEmpty ? format : String(format: format, arguments: args)
    }
}
