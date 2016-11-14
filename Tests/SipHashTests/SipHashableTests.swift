//
//  SipHashableTests.swift
//  SipHash
//
//  Created by Károly Lőrentey on 2016-11-14.
//  Copyright © 2016. Károly Lőrentey.
//

import XCTest
@testable import SipHash

private struct Book: SipHashable {
    let title: String
    let pageCount: Int

    func addHashes(to hash: inout SipHash) {
        hash.add(title)
        hash.add(pageCount)
    }

    static func ==(left: Book, right: Book) -> Bool {
        return left.title == right.title && left.pageCount == right.pageCount
    }
}

class SipHashableTests: XCTestCase {
    func testBookHashValue() {
        let book = Book(title: "The Colour of Magic", pageCount: 206)
        let actual = book.hashValue

        var hash = SipHash()
        hash.add(book.title.hashValue)
        hash.add(book.pageCount)
        let expected = hash.finalize()

        XCTAssertEqual(actual, expected)
    }

    func testBookEquality() {
        let book1 = Book(title: "The Colour of Magic", pageCount: 206)
        let hash1 = book1.hashValue

        let book2 = Book(title: "The Colour of Magic", pageCount: 206)
        let hash2 = book2.hashValue

        XCTAssertEqual(hash1, hash2)
    }

    func testAddSipHashable() {
        let book = Book(title: "The Colour of Magic", pageCount: 206)
        let hash1 = book.hashValue

        var sip = SipHash()
        sip.add(book)
        let hash2 = sip.finalize()

        XCTAssertEqual(hash1, hash2)
    }
}
