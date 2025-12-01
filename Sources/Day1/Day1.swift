//
//  Day1.swift
//  
//
//  Created by Marc-Antoine Malépart on 2025-11-30.
//

import Foundation
import ArgumentParser
import AdventOfCodeUtilities

struct Day1: DayCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "day1",
            abstract: "Solve day 1 puzzle"
        )
    }
    
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let file = try readFile()
        
        printTitle("Part 1", level: .title1)
        // TODO: Solve part 1
    }
}
