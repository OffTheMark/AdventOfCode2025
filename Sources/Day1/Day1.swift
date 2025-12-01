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
    }
    
    private func moves(from lines: [String]) -> [Move] {
        lines.compactMap(Move.init)
    }
    
    private func part1(moves: [Move]) -> Int {
        var position = 50
        var result = 0
        
        for move in moves {
            position += move.delta
            
            if position < 0 {
                position += 100
            }
            position %= 100
            
            if position == 0 {
                result += 1
            }
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

