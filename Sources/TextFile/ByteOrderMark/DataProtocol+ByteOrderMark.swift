//
//  DataProtocol+ByteOrderMark.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import protocol Foundation.DataProtocol
#else
import protocol FoundationEssentials.DataProtocol
#endif

extension DataProtocol {
    /// Returns the text encoding Byte Order Mark (BOM) found at the start of the data, if present.
    public var byteOrderMarkPrefix: ByteOrderMark? {
        for bom in ByteOrderMark.parseOrder {
            if starts(with: bom.bytes) { return bom }
        }
        return nil
    }
}
