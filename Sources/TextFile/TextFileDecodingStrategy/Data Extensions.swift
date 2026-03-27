//
//  Data Extensions.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
import protocol Foundation.DataProtocol
import class Foundation.FileManager
import class Foundation.NSNumber
import class Foundation.NSString
import struct Foundation.ObjCBool
import struct Foundation.URL
import struct Foundation.UUID
#else
import class Foundation.NSString
import struct Foundation.ObjCBool
import struct FoundationEssentials.Data
import protocol FoundationEssentials.DataProtocol
import class FoundationEssentials.FileManager
import struct FoundationEssentials.URL
import struct FoundationEssentials.UUID
#endif

extension Data {
    /// Basic naïve heuristic to attempt to detect byte order (endianness) in multi-byte UTF (UTF-16, UTF-32) encoded data.
    /// This method assumes there is no BOM present at the start of the data.
    func guessMultiByteUTFEncoding() -> String.Encoding? {
        let sampleBytes = self.prefix(100)
        guard sampleBytes.count >= 2 else { return nil }
        
        func splitBytes(byteWidth: Int) -> (left: [Data.Element], right: [Data.Element])? {
            let leftBytes = sampleBytes.enumerated()
                .compactMap { $0.offset.isMultiple(of: byteWidth) ? $0.element : nil }
            let rightBytes = sampleBytes.enumerated()
                .compactMap { ($0.offset - (byteWidth - 1)).isMultiple(of: byteWidth) ? $0.element : nil }
            
            guard !leftBytes.isEmpty, !rightBytes.isEmpty else { return nil }
            
            return (left: leftBytes, right: rightBytes)
        }
        
        enum Endianness {
            case bigEndian
            case littleEndian
        }
        
        func probableEndianness(highBytes: some DataProtocol, lowBytes: some DataProtocol) -> Bool {
            // UTF-16/32 typically have a 0x00 byte as the high byte of each 2 or 4-byte cluster
            
            let zeroHighByteCount = highBytes.filter { $0 == 0x00 }.count
            let percentageOfHighBytesThatAreZero = Double(zeroHighByteCount) / Double(highBytes.count)
            
            let nonZeroLowByteCount = lowBytes.filter { $0 != 0x00 }.count
            let percentageOfLowBytesThatAreNonZero = Double(nonZeroLowByteCount) / Double(lowBytes.count)
            
            let thresholdPercentage: Double = 0.8 // arbitrary: 80% or more
            
            return (percentageOfHighBytesThatAreZero > thresholdPercentage)
                && (percentageOfLowBytesThatAreNonZero > thresholdPercentage)
        }
        
        func isProbablyUTF(byteWidth: Int) -> Endianness? {
            guard let (leftBytes, rightBytes) = splitBytes(byteWidth: byteWidth)
            else { return nil }
            
            if probableEndianness(highBytes: leftBytes, lowBytes: rightBytes) {
                return .bigEndian
            } else if probableEndianness(highBytes: rightBytes, lowBytes: leftBytes) {
                return .littleEndian
            } else {
                return nil
            }
        }
        
        func isProbablyUTF16() -> Endianness? {
            isProbablyUTF(byteWidth: 2)
        }
        
        func isProbablyUTF32() -> Endianness? {
            isProbablyUTF(byteWidth: 4)
        }
        
        if let endianness = isProbablyUTF16() {
            switch endianness {
            case .bigEndian: return .utf16BigEndian
            case .littleEndian: return .utf16LittleEndian
            }
        } else if let endianness = isProbablyUTF32() {
            switch endianness {
            case .bigEndian: return .utf32BigEndian
            case .littleEndian: return .utf32LittleEndian
            }
        } else {
            return nil
        }
    }
}
