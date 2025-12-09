//
//  Day9.swift
//  AdventOfCode2025
//
//  Created by Marc-Antoine Malépart on 2025-12-08.
//

import Foundation
import ArgumentParser
import AdventOfCodeUtilities
import RegexBuilder

struct Day9: DayCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "day9",
            abstract: "Solve day 9 puzzle"
        )
    }
    
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let clock = ContinuousClock()
        let input = try readFile()
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, part1Result) = clock.measure {
            part1(input: input)
        }
        print("Part 1:", part1Result)
        print("Elapsed time:", part1Duration, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let (part2Duration, part2Result) = clock.measure {
            part2(input: input)
        }
        print("Part 2:", part2Result)
        print("Elapsed time:", part2Duration)
    }
    
    private func part1(input: String) -> Int {
        // TODO
        return 0
    }
    
    private func part2(input: String) -> Int {
        // TODO
        return 0
    }
}
