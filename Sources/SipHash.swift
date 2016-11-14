//
//  SipHash.swift
//  SipHash
//
//  Created by Károly Lőrentey on 2016-03-08.
//  Copyright © 2016 Károly Lőrentey.
//
//  This file contains an independent reimplementation of [SipHash](https://131002.net/siphash) for Swift, 
//  suitable for use in projects outside the Swift standard library.
//  (The Swift stdlib already includes SipHash; unfortunately the API is not public.)
//
//  SipHash was invented by Jean-Philippe Aumasson and Daniel J. Bernstein.

@inline(__always)
private func rotateLeft(_ value: UInt64, by amount: UInt64) -> UInt64 {
    return (value << amount) | (value >> (64 - amount))
}

public struct SipHash {
    /// The number of compression rounds.
    private static let c = 2
    /// The number of finalization rounds.
    private static let d = 4

    /// The default key, used by the default initializer.
    /// Each process has a unique key, chosen randomly when the first instance of `SipHash` is initialized.
    private static let key: (UInt64, UInt64) = (randomUInt64(), randomUInt64())

    /// Word 0 of the internal state, initialized to ASCII encoding of "somepseu".
    var v0: UInt64 = 0x736f6d6570736575
    /// Word 1 of the internal state, initialized to ASCII encoding of "dorandom".
    var v1: UInt64 = 0x646f72616e646f6d
    /// Word 2 of the internal state, initialized to ASCII encoding of "lygenera".
    var v2: UInt64 = 0x6c7967656e657261
    /// Word 3 of the internal state, initialized to ASCII encoding of "tedbytes".
    var v3: UInt64 = 0x7465646279746573

    /// The current partial word, not yet mixed in with the internal state.
    var tailBytes: UInt64 = 0
    /// The number of bytes that are currently pending in `tailBytes`. Guaranteed to be between 0 and 7.
    var tailByteCount = 0
    /// The number of bytes collected so far, or -1 if the hash value has already been finalized.
    var byteCount = 0

    /// Initialize a new instance with the default key, generated randomly.
    public init() {
        self.init(k0: SipHash.key.0, k1: SipHash.key.1)
    }

    /// Initialize a new instance with the specified key.
    ///
    /// - Parameter k0: The low 64 bits of the secret key.
    /// - Parameter k1: The high 64 bits of the secret key.
    public init(k0: UInt64, k1: UInt64) {
        v0 ^= k0
        v1 ^= k1
        v2 ^= k0
        v3 ^= k1
    }

    @inline(__always)
    mutating func sipRound() {
        v0 = v0 &+ v1
        v1 = rotateLeft(v1, by: 13)
        v1 ^= v0
        v0 = rotateLeft(v0, by: 32)
        v2 = v2 &+ v3
        v3 = rotateLeft(v3, by: 16)
        v3 ^= v2
        v0 = v0 &+ v3
        v3 = rotateLeft(v3, by: 21)
        v3 ^= v0
        v2 = v2 &+ v1
        v1 = rotateLeft(v1, by: 17)
        v1 ^= v2
        v2 = rotateLeft(v2, by: 32)
    }

    mutating func compressWord(_ m: UInt64) {
        v3 ^= m
        for _ in 0 ..< SipHash.c {
            sipRound()
        }
        v0 ^= m
    }

    mutating func _finalize() -> UInt64 {
        precondition(byteCount >= 0)
        tailBytes |= UInt64(byteCount) << 56
        byteCount = -1

        compressWord(tailBytes)

        v2 ^= 0xff
        for _ in 0 ..< SipHash.d {
            sipRound()
        }

        return v0 ^ v1 ^ v2 ^ v3
    }

    /// Add all bytes in `buffer` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ buffer: UnsafeRawBufferPointer) {
        precondition(byteCount >= 0)
        var i = 0
        if tailByteCount > 0 {
            let readCount = min(buffer.count, 8 - tailByteCount)
            tailBytes <<= UInt64(readCount << 3)
            switch readCount {
            case 7:
                tailBytes |= UInt64(buffer[6]) << 48
                fallthrough
            case 6:
                tailBytes |= UInt64(buffer[5]) << 40
                fallthrough
            case 5:
                tailBytes |= UInt64(buffer[4]) << 32
                fallthrough
            case 4:
                tailBytes |= UInt64(buffer[3]) << 24
                fallthrough
            case 3:
                tailBytes |= UInt64(buffer[2]) << 16
                fallthrough
            case 2:
                tailBytes |= UInt64(buffer[1]) << 8
                fallthrough
            case 1:
                tailBytes |= UInt64(buffer[0])
            default:
                precondition(readCount == 0)
            }
            tailByteCount += readCount
            i += readCount

            if tailByteCount == 8 {
                compressWord(tailBytes)
                tailBytes = 0
                tailByteCount = 0
            }
        }

        let left = (buffer.count - i) & 7
        let end = (buffer.count - i) - left
        while i < end {
            let m = UInt64(buffer[i])
                | (UInt64(buffer[i + 1]) << 8)
                | (UInt64(buffer[i + 2]) << 16)
                | (UInt64(buffer[i + 3]) << 24)
                | (UInt64(buffer[i + 4]) << 32)
                | (UInt64(buffer[i + 5]) << 40)
                | (UInt64(buffer[i + 6]) << 48)
                | (UInt64(buffer[i + 7]) << 56)
            compressWord(m)
            i += 8
        }

        switch left {
        case 7:
            tailBytes |= UInt64(buffer[6]) << 48
            fallthrough
        case 6:
            tailBytes |= UInt64(buffer[5]) << 40
            fallthrough
        case 5:
            tailBytes |= UInt64(buffer[4]) << 32
            fallthrough
        case 4:
            tailBytes |= UInt64(buffer[3]) << 24
            fallthrough
        case 3:
            tailBytes |= UInt64(buffer[2]) << 16
            fallthrough
        case 2:
            tailBytes |= UInt64(buffer[1]) << 8
            fallthrough
        case 1:
            tailBytes |= UInt64(buffer[0])
        default:
            precondition(left == 0)
        }
        tailByteCount = left

        byteCount += buffer.count
    }

    /// Add hashing components in `value` to this hash. This method simply calls `value.addHashes`.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add<H: SipHashable>(_ value: H) {
        value.addHashes(to: &self)
    }

    /// Add the hash value of `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add<H: Hashable>(_ value: H) {
        add(value.hashValue)
    }

    /// Finalize this hash and return the hash value.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func finalize() -> Int {
        if MemoryLayout<Int>.size == 8 {
            return Int(Int64(bitPattern: _finalize()))
        }
        else {
            precondition(MemoryLayout<Int>.size == 4)
            let hash = _finalize()
            return Int(truncatingBitPattern: hash ^ (hash >> 32))
        }
    }
}
