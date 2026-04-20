//
//  Collection Extensions.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// MARK: - contains(anyElementsIn:)

extension Sequence where Element: Comparable {
    /// Returns a Boolean value indicating whether the sequence contains any of the elements within
    /// the specified collection.
    @inlinable @_disfavoredOverload
    func contains(anyElementsIn collection: some Sequence<Element>) -> Bool {
        contains { element in
            collection.contains(element)
        }
    }

    /// Returns a Boolean value indicating whether the sequence contains any of the elements within
    /// the specified collection.
    @inlinable @_disfavoredOverload
    func contains(anyElementsIn collections: some Sequence<some Sequence<Element>>) -> Bool {
        contains { element in
            collections.contains { collection in
                collection.contains(element)
            }
        }
    }
}

// MARK: - count(ofElementsIn:)

extension Sequence where Element: Comparable {
    /// Returns the number of elements that match any of the elements within the specified collection.
    @inlinable @_disfavoredOverload
    func count(ofElementsIn collection: some Sequence<Element>) -> Int {
        count { element in
            collection.contains(element)
        }
    }

    /// Returns the number of elements that match any of the elements within the specified collection.
    @inlinable @_disfavoredOverload
    func count(ofElementsIn collections: some Sequence<some Sequence<Element>>) -> Int {
        count { element in
            collections.contains { collection in
                collection.contains(element)
            }
        }
    }
}
