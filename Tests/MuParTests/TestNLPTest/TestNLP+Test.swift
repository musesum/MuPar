//  Test+Test.swift
//  Created by warren on 9/3/17.
//  Copyright © 2017 DeepMuse
//  License: Apache 2.0 - see License file

import Foundation
import MuPar
import MuVisit

extension TestNLP {

    func testAndPrintTestGraph() -> Int {

        var err = 0
        if let root = root {
            let script = root.makeScript() //remake script from parse graph
            err = ParStr.testCompare(script, script, echo: true) // should match
            print("-------------------------------")
            print(script)
            print(" ⟹ What follows is a dump of the graph of the test script,\n" +
            "which is sometimes valueable for tracking down the parse details.\n" +
            "-----------------------------------------------------------------\n" +
            "⦙  Predecessor                  Node                    Successors ")
            root.printGraph(Visitor(0)) // print the parse graph
            print("-----------------------------------------------------------------")
        } else {
            err = 1
        }
        return err
    }

    func testScript() -> Int {

        func testPhrase(_ request: String) -> Int {

            print("\"\(request)\" ⟹ ", terminator: "")

            parWords.update(request, Date().timeIntervalSince1970)

            if let parItem = root?.findMatch(parWords).parLast {

                let foundString = parItem.foundString(withHops: true)
                let totalHops = parItem.totalHops()
                print("\(foundString) ⟹ hops:\(totalHops) ✔︎")
                return 0
            } else {
                print("⁉️ failed")
                return 1
            }
        }

        func eventListChecker(_ str: Substring) -> String? {
            let ret =  str.hasPrefix("yo") ? "yo" : nil
            return ret
        }

        // ────────────── begin ──────────────

        var err = testAndPrintTestGraph()
        ParStr.tracing = false

        ParRecents.shortTermMemory = 0 // 0 seconds of short term memory

        err += testPhrase("test show all alarms")
        err += testPhrase("test show alarms")
        err += testPhrase("test please show alarms")

        print("\n-------------------------------")
        print("⟹ before attaching eventListChecker() - `yo` is unknown")
        let _ = testPhrase("test show event yo") // should produce an error

        print("\n⟹ runtime is attaching eventListChecker() callback to eventList()")
        root?.setMatch("test show event eventList()", eventListChecker)

        print("\n⟹ now `yo` is now matched during runtime")
        err += testPhrase("test show event yo") // should now be ok as yo is n
        err += testPhrase("test event show yo")
        err += testPhrase("yo test show event")
        err += testPhrase("test show yo event")
        err += testPhrase("test event yo show")

        print("\n-------------------------------")
        print("⟹ with no shortTermMemory, partial matches fail")
        ParRecents.shortTermMemory = 0 // 8 seconds of short term memory
        let _ = testPhrase("test show event yo")
        let _ = testPhrase("test hide yo")    // should hide yo event
        let _ = testPhrase("test hide event")
        let _ = testPhrase("hide event")
        let _ = testPhrase("hide")

        print("\n⟹ after setting ParRecents.shortTermMemory = 8 seconds")
        ParRecents.shortTermMemory = 8 // 8 seconds of short term memory
        err += testPhrase("test show event yo")
        err += testPhrase("test hide yo")    // should hide yo event
        err += testPhrase("test hide event")
        err += testPhrase("hide event")
        err += testPhrase("hide")

        return err
    }
}
