//
//  SipHashable.swift
//  SipHash
//
//  Created by Károly Lőrentey on 2016-11-14.
//  Copyright © 2016. Károly Lőrentey.
//

/// A variant of `Hashable` that makes it simpler to generate good hash values.
///
/// Example implementation:
///
/// ```
/// struct Book: SipHashable {
///     var title: String
///     var pageCount: Int
///
///     func addHashes(to hash: inout SipHash) {
///         hash.add(title)
///         hash.add(pageCount)
///     }
///
///     static func ==(left: Book, right: Book) -> Bool {
///         return left.title == right.title && left.pageCount == right.pageCount
///     }
/// }
/// ```
public protocol SipHashable: Hashable {
    /// Add components of `self` that should contribute to hashing to `hash`.
    func addHashes(to hash: inout SipHash)
}

extension SipHashable {
    /// The hash value, calculated using `addHashes`.
    ///
    /// Hash values are not guaranteed to be equal across different executions of your program.
    /// Do not save hash values to use during a future execution.
    public var hashValue: Int {
        var hash = SipHash()
        addHashes(to: &hash)
        return hash.finalize()
    }
}

