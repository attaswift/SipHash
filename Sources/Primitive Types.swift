//
//  Primitive Types.swift
//  SipHash
//
//  Created by Károly Lőrentey on 2016-11-14.
//  Copyright © 2016. Károly Lőrentey.
//

public extension SipHash {
    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: Bool) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<Bool>.size))
    }

    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: UInt) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<UInt>.size))
    }

    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: Int64) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<Int64>.size))
    }

    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: UInt64) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<UInt64>.size))
    }

    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: Int32) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<Int32>.size))
    }

    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: UInt32) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<UInt32>.size))
    }

    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: Int16) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<Int16>.size))
    }

    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: UInt16) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<UInt16>.size))
    }

    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: Int8) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<Int8>.size))
    }

    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: UInt8) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<UInt8>.size))
    }

    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: Float) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<Float>.size))
    }

    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: Double) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<Double>.size))
    }

    /// Add `value` to this hash.
    ///
    /// - Requires: `finalize()` hasn't been called on this instance yet.
    public mutating func add(_ value: Float80) {
        var data = value
        add(UnsafeRawBufferPointer(start: &data, count: MemoryLayout<Float80>.size))
    }
}
