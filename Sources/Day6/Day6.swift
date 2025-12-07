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
import Collections
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
        let clock = ContinuousClock()
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, grandTotal) = try clock.measure {
            let problems = leftToRightProblems(from: try readLines())
            return problems.reduce(into: 0) { partialResult, problem in
                partialResult += problem.solve()
            }
        }
        print(
            "What is the grand total found by adding together all of the answers to the individual problems?",
            grandTotal
        )
        print("Elapsed time:", part1Duration, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let (part2Duration, rightToLeftGrandTotal) = try clock.measure {
            let problems = rightToLeftProblems(from: try readLines())
            return problems.reduce(into: 0) { partialResult, problem in
                partialResult += problem.solve()
            }
        }
        print(
            "What is the grand total found by adding together all of the answers to the individual problems?",
            rightToLeftGrandTotal
        )
        print("Elapsed time:", part2Duration, terminator: "\n\n")
    }
    
    private func leftToRightProblems(from lines: [String]) -> [Problem] {
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
    
    private func rightToLeftProblems(from lines: [String]) -> [Problem] {
        let operationLine = lines.last!
        var operations = Deque(
            operationLine
                .components(separatedBy: .whitespaces)
                .compactMap { substring in
                    Operation(rawValue: String(substring))
                }
        )
        
        var problems = [Problem]()
        let numberLines = lines.dropLast()
        let maxOffset = numberLines.map(\.count).max()!
        var numbers = [Int]()
        
        for offset in 0 ..< maxOffset {
            let column = String(numberLines.compactMap { line in
                if offset >= line.count {
                    return nil
                }
                
                let index = line.index(line.startIndex, offsetBy: offset)
                return line[index]
            })
            
            if column.allSatisfy(\.isWhitespace) {
                let operation = operations.popFirst()!
                let problem = Problem(numbers: numbers, operation: operation)
                problems.append(problem)
                numbers.removeAll()
                continue
            }
            
            let number = Int(column.trimmingCharacters(in: .whitespaces))!
            numbers.append(number)
        }
        
        if !numbers.isEmpty {
            let operation = operations.popFirst()!
            let problem = Problem(numbers: numbers, operation: operation)
            problems.append(problem)
        }
        
        return problems
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
