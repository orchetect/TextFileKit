//
//  TextFileDecodingStrategy Tests.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Testing
import TextFile

struct TextFileDecodingStrategy_Tests {
    @Test
    func equatable() {
        #expect(
            ExplicitTextFileDecodingStrategy(encoding: .utf8)
                == ExplicitTextFileDecodingStrategy(encoding: .utf8)
        )

        #expect(
            ExplicitTextFileDecodingStrategy(encoding: .utf8)
                != ExplicitTextFileDecodingStrategy(encoding: .utf16)
        )

        #expect(
            HybridTextFileDecodingStrategy(allowLossy: true, convertLineEndings: true)
                == HybridTextFileDecodingStrategy(allowLossy: true, convertLineEndings: true)
        )

        #expect(
            HybridTextFileDecodingStrategy(allowLossy: true, convertLineEndings: true)
                != HybridTextFileDecodingStrategy(allowLossy: false, convertLineEndings: true)
        )

        #expect(
            ExplicitTextFileDecodingStrategy(encoding: .utf8)
                != HybridTextFileDecodingStrategy(allowLossy: true, convertLineEndings: true)
        )

        #expect(
            AnyTextFileDecodingStrategy(.hybrid(allowLossy: true))
                == AnyTextFileDecodingStrategy(.hybrid(allowLossy: true))
        )

        #expect(
            AnyTextFileDecodingStrategy(.hybrid(allowLossy: true))
                != AnyTextFileDecodingStrategy(.hybrid(allowLossy: false))
        )

        #expect(
            AnyTextFileDecodingStrategy(.hybrid(allowLossy: true))
                != AnyTextFileDecodingStrategy(.string())
        )
    }

    @Test
    func equatable_any() {
        let lhs: any TextFileDecodingStrategy = .hybrid(allowLossy: true)
        let rhs: any TextFileDecodingStrategy = .hybrid(allowLossy: true)

        #expect(lhs == rhs)
        #expect(lhs == .hybrid(allowLossy: true))
        #expect(lhs != .hybrid(allowLossy: false))
        #expect(HybridTextFileDecodingStrategy(allowLossy: true) == rhs)
        #expect(HybridTextFileDecodingStrategy(allowLossy: false) != rhs)
    }

    @Test
    func isEqualTo() {
        #expect(
            ExplicitTextFileDecodingStrategy(encoding: .utf8)
                .isEqual(to: ExplicitTextFileDecodingStrategy(encoding: .utf8))
        )

        #expect(
            !ExplicitTextFileDecodingStrategy(encoding: .utf8)
                .isEqual(to: ExplicitTextFileDecodingStrategy(encoding: .utf16))
        )

        #expect(
            HybridTextFileDecodingStrategy(allowLossy: true, convertLineEndings: true)
                .isEqual(to: HybridTextFileDecodingStrategy(allowLossy: true, convertLineEndings: true))
        )

        #expect(
            !HybridTextFileDecodingStrategy(allowLossy: true, convertLineEndings: true)
                .isEqual(to: HybridTextFileDecodingStrategy(allowLossy: false, convertLineEndings: true))
        )

        #expect(
            !ExplicitTextFileDecodingStrategy(encoding: .utf8)
                .isEqual(to: HybridTextFileDecodingStrategy(allowLossy: true, convertLineEndings: true))
        )

        #expect(
            AnyTextFileDecodingStrategy(.hybrid(allowLossy: true))
                .isEqual(to: AnyTextFileDecodingStrategy(.hybrid(allowLossy: true)))
        )

        #expect(
            !AnyTextFileDecodingStrategy(.hybrid(allowLossy: true))
                .isEqual(to: AnyTextFileDecodingStrategy(.hybrid(allowLossy: false)))
        )

        #expect(
            !AnyTextFileDecodingStrategy(.hybrid(allowLossy: true))
                .isEqual(to: AnyTextFileDecodingStrategy(.string()))
        )
    }

    @Test
    func isEqualTo_any() {
        let lhs: any TextFileDecodingStrategy = .hybrid(allowLossy: true)
        let rhs: any TextFileDecodingStrategy = .hybrid(allowLossy: true)

        #expect(lhs.isEqual(to: rhs))
        #expect(lhs.isEqual(to: .hybrid(allowLossy: true)))
        #expect(!lhs.isEqual(to: .hybrid(allowLossy: false)))
        #expect(HybridTextFileDecodingStrategy(allowLossy: true).isEqual(to: rhs))
        #expect(!HybridTextFileDecodingStrategy(allowLossy: false).isEqual(to: rhs))
    }
}
