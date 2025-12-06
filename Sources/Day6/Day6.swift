//
//  Day6.swift
//  AdventOfCode2025
//
//  Created by Marc-Antoine Malépart on 2025-12-06.
//


import Foundation
import Algorithms
import ArgumentParser
import AdventOfCodeUtilities
import RegexBuilder

struct Day6: DayCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "day6",
            abstract: "Solve day 6 puzzle"
        )
    }
    
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let problems = problems(from: try readLines())
        let clock = ContinuousClock()
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, grandTotal) = clock.measure {
            part1(problems: problems)
        }
        print("What is the grand total found by adding together all of the answers to the individual problems?", grandTotal)
        print("Elapsed time:", part1Duration, terminator: "\n\n")
    }
    
    private func problems(from lines: [String]) -> [Problem] {
        let numberLines = lines.dropLast()
            .reduce(into: [[Int]]()) { partialResult, line in
                let numbers = line.components(separatedBy: .whitespaces)
                    .compactMap(Int.init)
                partialResult.append(numbers)
            }
        let operationLine = lines.last!
            .components(separatedBy: .whitespaces)
            .compactMap { substring in
                Operation(rawValue: String(substring))
            }
        
        return operationLine.enumerated().map { pair in
            let (index, operation) = pair
            let numbers = numberLines.map({ $0[index] })
            return Problem(numbers: numbers, operation: operation)
        }
    }
    
    private func part1(problems: [Problem]) -> Int {
        problems.reduce(into: 0) { grandTotal, problem in
            grandTotal += problem.solve()
        }
    }
}

private struct Problem {
    let numbers: [Int]
    
    let operation: Operation
    
    func solve() -> Int {
        operation.applying(to: numbers)
    }
}

private enum Operation: String {
    case add = "+"
    case multiply = "*"
    
    func applying(to numbers: [Int]) -> Int {
        switch self {
        case .add:
            numbers.reduce(0, +)
            
        case .multiply:
            numbers.reduce(1, *)
        }
    }
}
