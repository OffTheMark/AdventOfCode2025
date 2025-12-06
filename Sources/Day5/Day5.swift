//
//  Day5.swift
//  AdventOfCode2025
//
//  Created by Marc-Antoine Malépart on 2025-12-05.
//


import Foundation
import Algorithms
import ArgumentParser
import AdventOfCodeUtilities
import RegexBuilder

struct Day5: DayCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "day5",
            abstract: "Solve day 5 puzzle"
        )
    }
    
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let (freshIngredientRanges, ingredients) = parse(input: try readFile())
        let clock = ContinuousClock()
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, numberOfFreshIngredients) = clock.measure {
            part1(freshIngredientRanges: freshIngredientRanges, ingredients: ingredients)
        }
        print("How many of the available ingredient IDs are fresh?", numberOfFreshIngredients)
        print("Elapsed time:", part1Duration, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let (part2Duration, allFreshIngredients) = clock.measure {
            part2(freshIngredientRanges: freshIngredientRanges)
        }
        print(
            "How many ingredient IDs are considered to be fresh according to the fresh ingredient ID ranges?",
            allFreshIngredients
        )
        print("Elapsed time:", part2Duration)
    }
    
    private func parse(input: String) -> (freshIngredientRanges: [ClosedRange<Int>], ingredients: [Int]) {
        let blocks = input.split(separator: "\n\n")
        
        let freshIngredientRangeRegex = Regex {
            TryCapture {
                Repeat(.digit, 1...)
            } transform: {
                Int($0)
            }
            
            "-"
            
            TryCapture {
                Repeat(.digit, 1...)
            } transform: {
                Int($0)
            }
        }
        
        let freshIngredientRanges: [ClosedRange<Int>] = blocks[0].components(separatedBy: .newlines)
            .compactMap { line in
                guard let (_, lowerBound, upperBound) = line.wholeMatch(of: freshIngredientRangeRegex)?.output else {
                    return nil
                }
                
                return lowerBound ... upperBound
            }
        let ingredients = blocks[1].components(separatedBy: .newlines)
            .compactMap(Int.init)
        
        return (freshIngredientRanges, ingredients)
    }
    
    private func part1(freshIngredientRanges: [ClosedRange<Int>], ingredients: [Int]) -> Int {
        ingredients.count(where: { ingredient in
            freshIngredientRanges.contains(where: { range in
                range.contains(ingredient)
            })
        })
    }
    
    private func part2(freshIngredientRanges: [ClosedRange<Int>]) -> Int {
        let sortedRanges = freshIngredientRanges.sorted(using: KeyPathComparator(\.lowerBound))
        var result = 0
        var currentFreshProduct = sortedRanges.first!.lowerBound
        
        for range in sortedRanges {
            if range.contains(currentFreshProduct) {
                let partialRange = currentFreshProduct ... range.upperBound
                result += partialRange.count
                currentFreshProduct = range.upperBound + 1
            }
            else if currentFreshProduct < range.lowerBound {
                result += range.count
                currentFreshProduct = range.upperBound + 1
            }
        }
        
        return result
    }
}
