//
//  FixedCapacityArray.swift
//  the-narrator
//
//  Created by Chris Martin on 12/22/16.
//
//

import Foundation

public enum FixedCapacityError: Error {
    case full
}

public struct FixedCapacityArray<Element> {
    
    private var capacity: Int
    public var items = [Element]()
    
    public init(capacity: Int) {
        self.capacity = capacity
    }
    
    public subscript(index: Int) -> Element {
        return items[index]
    }
    
    public var isEmpty: Bool {
        return items.isEmpty
    }
    
    public var isFull: Bool {
        return items.count == capacity
    }
    
    public var count: Int {
        return items.count
    }
    
    public mutating func removeAll() {
        items.removeAll()
    }

    public mutating func remove(at index: Int) {
        items.remove(at: index)
    }
    
    public mutating func append(_ item: Element) throws {
        if !isFull {
            items.append(item)
        }
        else {
            throw FixedCapacityError.full
        }
    }
    
    public mutating func pop() -> Element? {
        return items.popLast()
    }
    
    public mutating func insert(_ item: Element, at index: Int) throws {
        if !isFull {
            self.items.insert(item, at: index)
        }
        else {
            throw FixedCapacityError.full
        }
    }
}
