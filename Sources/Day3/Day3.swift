//
//  Day3.swift
//  AdventOfCode2025
//
//  Created by Marc-Antoine Malépart on 2025-12-03.
//


import Foundation
import Algorithms
import ArgumentParser
import AdventOfCodeUtilities
import RegexBuilder

struct Day3: DayCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "day3",
            abstract: "Solve day 3 puzzle"
        )
    }
    
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let banks = banks(from: try readLines())
        let clock = ContinuousClock()
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, totalOutputJoltageWith2Batteries) = clock.measure {
            part1(banks: banks)
        }
        print("Total output joltage with 2 batteries per bank:", totalOutputJoltageWith2Batteries)
        print("Elapsed time:", part1Duration, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let (part2Duration, totalOutputJoltageWith12Batteries) = clock.measure {
            part2(banks: banks)
        }
        print("Total output joltage with 12 batteries per bank:", totalOutputJoltageWith12Batteries)
        print("Elapsed time:", part2Duration)
    }
    
    private func banks(from lines: [String]) -> [[Int]] {
        lines.map { line in
            Array(line).compactMap { character in
                Int(String(character))
            }
        }
    }
    
    private func part1(banks: [[Int]]) -> Int {
        banks.reduce(into: 0) { partialResult, bank in
            partialResult += maximumJoltage(for: bank)
        }
    }
    
    private func part2(banks: [[Int]]) -> Int {
        banks.reduce(into: 0) { partialResult, bank in
            partialResult += maximumJoltage(for: bank, ofSize: 12)
        }
    }
    
    private func maximumJoltage(for bank: [Int], ofSize size: Int = 2) -> Int {
        var digits = [Int]()
        var startIndex = bank.startIndex
        
        for iteration in 0 ..< size {
            let (digitIndex, digit) = bank.indexed().dropFirst(startIndex).dropLast(size - 1 - iteration)
                .max { lhs, rhs in
                    lhs.element < rhs.element
                }!
            
            digits.append(digit)
            startIndex = bank.index(after: digitIndex)
        }
        
        return digits.reversed().indexed().reduce(into: 0) { partialResult, pair in
            let (index, digit) = pair
            partialResult += digit * Int(pow(10, Double(index)))
        }
    }
}
