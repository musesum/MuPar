//  Created by warren on 7/7/17.

import Foundation
import Collections

public struct VisitFrom: OptionSet {

    public let rawValue: Int

    public static let bind   = VisitFrom(rawValue: 1 << 0) // 1
    public static let model  = VisitFrom(rawValue: 1 << 1) // 2
    public static let canvas = VisitFrom(rawValue: 1 << 2) // 4
    public static let user   = VisitFrom(rawValue: 1 << 3) // 8
    public static let remote = VisitFrom(rawValue: 1 << 4) // 16
    public static let midi   = VisitFrom(rawValue: 1 << 5) // 32
    public static let tween  = VisitFrom(rawValue: 1 << 6) // 64
    public init(rawValue: Int = 0) { self.rawValue = rawValue }

    static public var debugDescriptions: [(Self, String)] = [
        (.bind   , "bind"  ),
        (.model  , "model" ),
        (.canvas , "canvas"),
        (.user   , "user"  ),
        (.remote , "remote"),
        (.remote , "midi"  ),
        (.tween  , "tween" ),
    ]
    static public var logDescriptions: [(Self, String)] = [
        (.bind   , "􁀘"),
        (.model  , "􀬎"),
        (.canvas , "􀏅"),
        (.user   , "􀉩"),
        (.remote , "􀤆"),
        (.midi   , "􀑪"),
        (.tween  , "􀎶"),
    ]

    public var description: String {
        let result: [String] = Self.debugDescriptions.filter { contains($0.0) }.map { $0.1 }
        let joined = result.joined(separator: ", ")
        return "[\(joined)]"
    }
    public var log: String {
        let result: [String] = Self.logDescriptions.filter { contains($0.0) }.map { $0.1 }
        let joined = result.joined(separator: "")
       return joined
    }
    public var bind   : Bool { contains(.bind  ) }
    public var remote : Bool { contains(.remote) }
    public var canvas : Bool { contains(.canvas) }
    public var user   : Bool { contains(.user  ) }
    public var model  : Bool { contains(.model ) }
    public var midi   : Bool { contains(.midi  ) }
    public var tween  : Bool { contains(.tween ) }

    public static func + (lhs: VisitFrom, rhs: VisitFrom) -> VisitFrom {
        return VisitFrom(rawValue: lhs.rawValue | rhs.rawValue)
    }

    public static func += (lhs: inout VisitFrom, rhs: VisitFrom) {
        lhs = lhs + rhs
    }
}

/// Visit a node only once. Collect and compare with a set of nodes already visited.
public class Visitor {

    static var Id = 0  // unique identifier for each node
    public static func nextId() -> Int { Id += 1; return Id }

    private var lock = NSLock()
    public var visited = OrderedSet<Int>()
    public var blocked: OrderedSetClass<Int>?

    public var from: VisitFrom

    public init (_ ids: [Int?], from: VisitFrom = .model ) {
        self.from = from
        nowHeres(ids)
    }
    public init (_ id: Int,
                 from: VisitFrom = .model,
                 blocked: OrderedSetClass<Int>? = nil ) {

        self.from = from
        nowHere(id)
    }
    public init (_ from: VisitFrom) {
        self.from = from
    }

    public func remove(_ id: Int) {
        lock.lock()
        visited.remove(id)
        lock.unlock()
    }
    public func nowHere(_ id: Int) {
        lock.lock()
        visited.append(id)
        lock.unlock()
    }
    public func block(_ id: Int) {
        lock.lock()
        if blocked == nil {
            blocked = OrderedSetClass<Int>([id])
        }
        blocked?.append(id)
        lock.unlock()
    }
    public func nowHeres(_ ids: [Int?]) {
        lock.lock()
        for id in ids {
            if let id {
                visited.append(id)
            }
        }
        lock.unlock()
    }
    public func wasHere(_ id: Int) -> Bool {
        lock.lock()
        let visited = visited.contains(id)
        let blocking = blocked?.contains(id) ?? false
        lock.unlock()
        return visited || blocking
    }
    public func isLocal() -> Bool {
        return !from.remote
    }
    public func newVisit(_ id: Int) -> Bool {
        if wasHere(id) {
            return false
        } else {
            nowHere(id)
            return true
        }
    }
    public func via(_ via: VisitFrom) -> Visitor {
        self.from.insert(via)
        return self
    }
    public var log: String {
        lock.lock()
        let visits = visited.map { String($0)}.joined(separator: ",")
        lock.unlock()
        return "\(from.log):(\(visits))"
    }
}

