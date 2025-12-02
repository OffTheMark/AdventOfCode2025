//
//  Day2.swift
//
//
//  Created by Marc-Antoine Malépart on 2025-12-02.
//

import Foundation
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
        
        printTitle("Part 1", level: .title1)
        let sumOfInvalidIDs = part1(ranges: ranges)
        print("Sum of invalid IDs:", sumOfInvalidIDs, terminator: "\n\n")
    }
    
    private func ranges() throws -> [ProductIDRange] {
        try readFile()
            .components(separatedBy: ",")
            .compactMap(ProductIDRange.init)
    }
    
    private func part1(ranges: [ProductIDRange]) -> Int {
        let invalidIDs: [ProductID] = ranges.reduce(into: []) { partialResult, range in
            partialResult.append(contentsOf: range.invalidIDs)
        }
        
        return invalidIDs.reduce(into: 0) { partialResult, productID in
            partialResult += productID.rawValue
        }
    }
}

private struct ProductIDRange {
    let firstID: ProductID
    
    let lastID: ProductID
    
    var invalidIDs: [ProductID] {
        (firstID ... lastID).filter(\.isInvalid)
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
    
    var isInvalid: Bool {
        let count = description.count
        
        guard count.isMultiple(of: 2) else {
            return false
        }
        
        let leftHalf = description[
            description.startIndex ..< description.index(description.startIndex, offsetBy: count / 2)
        ]
        let rightHalf = description[
            description.index(description.startIndex, offsetBy: count / 2) ..< description.endIndex
        ]
        
        return leftHalf == rightHalf
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
