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
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let banks = banks(from: try readLines())
        let clock = ContinuousClock()
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, totalOutputJoltage) = clock.measure {
            part1(banks: banks)
        }
        print("Total output joltage:", totalOutputJoltage)
        print("Elapsed time:", part1Duration, terminator: "\n\n")
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
    
    private func maximumJoltage(for bank: [Int], size: Int = 2) -> Int {
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
