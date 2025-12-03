//
//  Day2.swift
//
//
//  Created by Marc-Antoine Malépart on 2025-12-02.
//

import Foundation
import Algorithms
import ArgumentParser
import AdventOfCodeUtilities
import RegexBuilder

struct Day2: DayCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "day2",
            abstract: "Solve day 2 puzzle"
        )
    }
    
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let ranges = try ranges()
        let clock = ContinuousClock()
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, sumOfInvalidIDs) = clock.measure {
            part1(ranges: ranges)
        }
        print("Sum of invalid IDs:", sumOfInvalidIDs)
        print("Elapsed time:", part1Duration, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let (part2Duration, sumOfTrulyInvalidIDs) = clock.measure {
            part2(ranges: ranges)
        }
        print("Sum of truly invalid IDs:", sumOfTrulyInvalidIDs)
        print("Elapsed time:", part2Duration)
    }
    
    private func ranges() throws -> [ProductIDRange] {
        try readFile()
            .components(separatedBy: ",")
            .compactMap(ProductIDRange.init)
    }
    
    private func part1(ranges: [ProductIDRange]) -> Int {
        func isInvalid(_ productID: ProductID) -> Bool {
            let description = productID.description
            let count = description.count
            
            guard count.isMultiple(of: 2) else {
                return false
            }
            
            let size = count / 2
            
            let chunk = String(description.prefix(size))
            return description == String(repeating: chunk, count: 2)
        }
        
        var result = 0
        for range in ranges {
            result += range.productIDs.reduce(into: 0, { partialResult, productID in
                if isInvalid(productID) {
                    partialResult += productID.rawValue
                }
            })
        }
        
        return result
    }
    
    private func part2(ranges: [ProductIDRange]) -> Int {
        func isInvalid(_ productID: ProductID) -> Bool {
            let description = productID.description
            let count = description.count
            
            if count < 2 {
                return false
            }
            
            let halfCount = count / 2
            let sizeRange = 1 ... halfCount
            
            return sizeRange.contains { size in
                guard count.isMultiple(of: size) else {
                    return false
                }
                
                let repeatCount = count / size
                
                let chunk = String(description.prefix(size))
                let candidate = String(repeating: chunk, count: repeatCount)
                return description == candidate
            }
        }
        
        var result = 0
        for range in ranges {
            result += range.productIDs.reduce(into: 0, { partialResult, productID in
                if isInvalid(productID) {
                    partialResult += productID.rawValue
                }
            })
        }
        
        return result
    }
}

private struct ProductIDRange {
    let firstID: ProductID
    
    let lastID: ProductID
    
    var productIDs: ClosedRange<ProductID> {
        firstID ... lastID
    }
}

extension ProductIDRange: LosslessStringConvertible {
    init?(_ description: String) {
        let regex = Regex {
            let identifier = TryCapture {
                One(.anyOf("123456789"))
                
                Repeat(0...) {
                    CharacterClass.digit
                }
            } transform: {
                Int($0)
            }
            
            identifier
            
            "-"
            
            identifier
        }
        
        guard let (_, firstID, lastID) = description.wholeMatch(of: regex)?.output else {
            return nil
        }
        
        self.firstID = ProductID(firstID)
        self.lastID = ProductID(lastID)
    }
    
    var description: String {
        "\(firstID)-\(lastID)"
    }
}

private struct ProductID {
    let rawValue: Int
    
    var description: String {
        String(rawValue)
    }
    
    init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension ProductID: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension ProductID: Strideable {
    func distance(to other: ProductID) -> Int {
        rawValue.distance(to: other.rawValue)
    }
    
    func advanced(by n: Int) -> ProductID {
        ProductID(rawValue.advanced(by: n))
    }
}

extension RegexComponent where Self == CharacterClass {
    static var positiveDigit: Self { .anyOf("123456789") }
}
