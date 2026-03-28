//
//  String Extensions.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import func Foundation.NSMakeRange
import class Foundation.NSRegularExpression
import class Foundation.NSString
import class Foundation.NSTextCheckingResult
#else
import func FoundationEssentials.NSMakeRange
import class FoundationEssentials.NSRegularExpression
import class FoundationEssentials.NSString
import class FoundationEssentials.NSTextCheckingResult
#endif

extension String {
    /// Wrap a string with double-quotes.
    @inlinable var quoted: Self {
        "\"\(self)\""
    }
    
    /// Fix non-standard line-breaks in a text block.
    var fixedLineBreaks: Self {
        // TODO: hacky line-ending conversion
        replacingOccurrences(of: "\r\n", with: "\n")
    }
}

extension StringProtocol {
    /// Returns an array of RegEx matches.
    @_disfavoredOverload
    func regexMatches(
        pattern: String,
        options: NSRegularExpression.Options = [],
        matchesOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds]
    ) -> [SubSequence] {
        do {
            let regex = try NSRegularExpression(
                pattern: pattern,
                options: options
            )
            
            func runRegEx(in source: String) -> [NSTextCheckingResult] {
                let range = NSMakeRange(0, (nsString as String).utf16.count)
                return regex.matches(
                    in: source,
                    options: matchesOptions,
                    range: range
                )
            }
            
            let nsString: NSString
            let results: [NSTextCheckingResult]
            
            switch self {
            case let _self as String:
                nsString = _self as NSString
                results = runRegEx(in: _self)
                
            default:
                let stringSelf = String(self)
                nsString = stringSelf as NSString
                results = runRegEx(in: stringSelf)
            }
            
            return results.map {
                let lb = self.utf16.index(self.startIndex, offsetBy: $0.range.lowerBound)
                let ub = self.utf16.index(self.startIndex, offsetBy: $0.range.upperBound)
                
                let subString = self[lb ..< ub]
                return subString
            }
            
        } catch {
            return []
        }
    }
}
