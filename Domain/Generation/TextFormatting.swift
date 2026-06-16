import Foundation

/// Pure string helpers shared by the generator. Deterministic, no locale surprises.
enum TextFormatting {
    /// Collapse runs of whitespace into single spaces and trim ends.
    static func collapsedSpaces(_ string: String) -> String {
        string
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    /// Title-case each word, preserving existing all-caps acronyms (e.g. "WWII").
    static func titleCased(_ string: String) -> String {
        collapsedSpaces(string)
            .split(separator: " ")
            .map { word -> String in
                let str = String(word)
                // Keep acronyms / mixed-case proper nouns as-is.
                if str.count > 1, str == str.uppercased() { return str }
                guard let first = str.first else { return str }
                return first.uppercased() + str.dropFirst().lowercased()
            }
            .joined(separator: " ")
    }

    /// Uppercase only the first character.
    static func sentenceCased(_ string: String) -> String {
        guard let first = string.first else { return string }
        return first.uppercased() + string.dropFirst()
    }

    /// Truncate to at most `max` characters without splitting a word. Adds an ellipsis
    /// only when truncation actually happened.
    static func truncatedOnWordBoundary(_ string: String, max: Int) -> String {
        guard string.count > max, max > 1 else {
            return string.count > max ? String(string.prefix(max)) : string
        }
        let hardLimit = max - 1 // leave room for the ellipsis
        let slice = string.prefix(hardLimit)
        if let lastSpace = slice.lastIndex(of: " ") {
            let trimmed = slice[..<lastSpace].trimmingCharacters(in: .whitespaces)
            return trimmed + "…"
        }
        return slice.trimmingCharacters(in: .whitespaces) + "…"
    }

    /// Join with commas and a trailing "and": ["a","b","c"] -> "a, b, and c".
    static func naturalList(_ items: [String]) -> String {
        switch items.count {
        case 0: return ""
        case 1: return items[0]
        case 2: return "\(items[0]) and \(items[1])"
        default:
            let head = items.dropLast().joined(separator: ", ")
            return "\(head), and \(items[items.count - 1])"
        }
    }
}
