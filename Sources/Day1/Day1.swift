//
//  Day1.swift
//  
//
//  Created by Marc-Antoine Malépart on 2025-11-30.
//

import Foundation
import ArgumentParser
import AdventOfCodeUtilities
import RegexBuilder

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
        let moves = moves(from: try readLines())
        
        printTitle("Part 1", level: .title1)
        let password = part1(moves: moves)
        print("Password:", password, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let correctPassword = part2(moves: moves)
        print("Password using method 0x434C49434B:", correctPassword)
    }
    
    private func moves(from lines: [String]) -> [Move] {
        lines.compactMap(Move.init)
    }
    
    private func part1(moves: [Move]) -> Int {
        var currentPosition = 50
        var result = 0
        
        for move in moves {
            let rotated = currentPosition + move.delta
            let (quotient, remainder) = rotated.quotientAndRemainder(dividingBy: 100)
            let newPosition = if remainder < 0 {
                (remainder + 100) % 100
            }
            else {
                remainder
            }
            
            if newPosition == 0 {
                result += 1
            }
            
            currentPosition = newPosition
        }
        
        return result
    }
    
    private func part2(moves: [Move]) -> Int {
        var currentPosition = 50
        var result = 0
        
        for move in moves {
            let rotated = currentPosition + move.delta
            let (quotient, remainder) = rotated.quotientAndRemainder(dividingBy: 100)
            let newPosition = if remainder < 0 {
                (remainder + 100) % 100
            }
            else {
                remainder
            }
            
            var rotations = abs(quotient)
            if currentPosition != 0, case .left = move, rotated <= 0 {
                // If we didn't start from zero and rotated left to zero or wrapped around, we count an extra rotation.
                rotations += 1
            }
            
            result += rotations
            currentPosition = newPosition
        }
        
        return result
    }
}

private enum Move: LosslessStringConvertible {
    case left(Int)
    case right(Int)
    
    var delta: Int {
        switch self {
        case .left(let count):
            -count
            
        case .right(let count):
            count
        }
    }
    
    init?(_ description: String) {
        let regex = Regex {
            Capture {
                ChoiceOf {
                    "L"
                    "R"
                }
            }
            
            TryCapture {
                Repeat(0...) {
                    CharacterClass.digit
                }
                
                CharacterClass.digit
            } transform: {
                Int($0)
            }
        }
        .anchorsMatchLineEndings()
        
        guard let (_, direction, count) = description.wholeMatch(of: regex)?.output else {
            return nil
        }
        
        switch direction {
        case "L":
            self = .left(count)
            
        case "R":
            self = .right(count)
            
        default:
            return nil
        }
    }
    
    var description: String {
        switch self {
        case .left(let count):
            "L\(count)"
            
        case .right(let count):
            "R\(count)"
        }
    }
}

