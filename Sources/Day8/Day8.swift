//
//  Day7.swift
//  AdventOfCode2025
//
//  Created by Marc-Antoine Malépart on 2025-12-08.
//

import Foundation
import ArgumentParser
import AdventOfCodeUtilities
import RegexBuilder

struct Day8: DayCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "day8",
            abstract: "Solve day 8 puzzle"
        )
    }
    
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let clock = ContinuousClock()
        let junctionBoxes = junctionBoxes(from: try readLines())
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, product) = clock.measure {
            part1(junctionBoxes: junctionBoxes, maxConnections: 1_000)
        }
        print("Wwhat do you get if you multiply together the sizes of the three largest circuits?", product)
        print("Elapsed time:", part1Duration, terminator: "\n\n")
    }
    
    private func junctionBoxes(from lines: [String]) -> [Point3D] {
        let regex = Regex {
            let coordinate = TryCapture {
                Optionally("-")
                
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
            
            coordinate
            ","
            coordinate
            ","
            coordinate
        }
        .anchorsMatchLineEndings()
        
        return lines.compactMap { line in
            guard let match = line.wholeMatch(of: regex) else {
                return nil
            }
            
            return Point3D(
                x: match.output.1,
                y: match.output.2,
                z: match.output.3
            )
        }
    }
    
    private func part1(junctionBoxes: [Point3D], maxConnections: Int) -> Int {
        var circuitsByBox = [Point3D: Set<Point3D>]()
        
        func connect(_ lhs: Point3D, _ rhs: Point3D) {
            let lhsConnections = circuitsByBox[lhs, default: []]
            let rhsConnections = circuitsByBox[rhs, default: []]
            
            for box in lhsConnections.union([lhs]) {
                circuitsByBox[box, default: []].formUnion(rhsConnections.union([rhs]).subtracting([box]))
            }
            for box in rhsConnections.union([rhs]) {
                circuitsByBox[box, default: []].formUnion(lhsConnections.union([lhs]).subtracting([box]))
            }
        }
        
        let pairsAndConnections: [(lhs: Point3D, rhs: Point3D, distance: Double)] = junctionBoxes
            .combinations(ofCount: 2)
            .map { combination in
                let lhs = combination[0]
                let rhs = combination[1]
                
                return (lhs, rhs, lhs.euclidianDistance(to: rhs))
            }
        let shortestConnections = pairsAndConnections.min(count: maxConnections) { lhs, rhs in
            lhs.distance < rhs.distance
        }
        
        for connection in shortestConnections {
            connect(connection.lhs, connection.rhs)
        }
        
        let circuits = Set(
            circuitsByBox.map({ pair in
                pair.value.union([pair.key])
            })
        )
        let threeBiggestCircuits = circuits.max(count: 3) { lhs, rhs in
            lhs.count < rhs.count
        }
        
        // TODO
        return threeBiggestCircuits.reduce(into: 1) { partialResult, circuit in
            partialResult *= circuit.count
        }
    }
}
