import Foundation

/// Localization accessor. All user-facing strings route through here so no raw strings
/// live in views. Base locale `en` is the source of truth (specs/localization.md).
public enum L10n {
    public static func string(_ key: String, _ args: CVarArg...) -> String {
        let format = String(localized: String.LocalizationValue(key))
        return args.isEmpty ? format : String(format: format, arguments: args)
    }
}
