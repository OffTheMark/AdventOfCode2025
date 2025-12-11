//
//  Day10.swift
//  AdventOfCode2025
//
//  Created by Marc-Antoine Malépart on 2025-12-10.
//

import Foundation
import Algorithms
import ArgumentParser
import AdventOfCodeUtilities
import Collections
import RegexBuilder

struct Day10: DayCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "day10",
            abstract: "Solve day 10 puzzle"
        )
    }
    
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let clock = ContinuousClock()
        let machines = machines(from: try readLines())
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, leastButtonPresses) = clock.measure {
            part1(machines: machines)
        }
        print(
            "What is the fewest button presses required to correctly configure the indicator lights on all of the machines?",
            leastButtonPresses
        )
        print("Elapsed time:", part1Duration, terminator: "\n\n")
    }
    
    private func machines(from lines: [String]) -> [Machine] {
        lines.compactMap(Machine.init)
    }
    
    private func part1(machines: [Machine]) -> Int {
        machines.enumerated().reduce(into: 0) { partialResult, pair in
            let leastButtonPresses = leastButtonPresses(for: pair.element)
            partialResult += leastButtonPresses
        }
    }
    
    private func leastButtonPresses(for machine: Machine) -> Int {
        // Use Dijkstra's algorithm to find shortest sequence of buttons that produce the startup sequence
        var heap: Heap<Node> = [Node(lights: machine.initialSequence)]
        var visited = Set<[IndicatorLight]>()
        
        while let currentNode = heap.popMin() {
            if currentNode.lights == machine.startupSequence {
                return currentNode.buttonPresses
            }
            
            visited.insert(currentNode.lights)
            
            for button in machine.buttons {
                let nextNode = currentNode.pressing(button)
                
                if !visited.contains(nextNode.lights) {
                    heap.insert(nextNode)
                }
            }
        }
        
        fatalError("Should not happen")
    }
}

private struct Node {
    let lights: [IndicatorLight]
    var buttonPresses = 0
    
    func pressing(_ button: Machine.Button) -> Node {
        var lights = lights
        for index in button {
            lights[index].toggle()
        }
        return Node(
            lights: lights,
            buttonPresses: buttonPresses + 1
        )
    }
}

extension Node: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.buttonPresses < rhs.buttonPresses
    }
}

private struct Machine {
    typealias Button = [Int]
    
    let startupSequence: [IndicatorLight]
    let buttons: [Button]
    
    var initialSequence: [IndicatorLight] {
        [IndicatorLight](repeating: .off, count: startupSequence.count)
    }
}

extension Machine {
    init?(_ description: String) {
        let regex = Regex {
            Anchor.startOfLine
            
            "["
            
            TryCapture {
                Repeat(1...) {
                    ChoiceOf {
                        "."
                        "#"
                    }
                }
            } transform: { substring in
                substring.compactMap(IndicatorLight.init)
            }
            
            "] "
            
            let button = Regex {
                let index = Repeat(.digit, 1...)
                
                "("
                
                index
                
                ZeroOrMore {
                    ","
                    index
                }
                
                ")"
            }
            
            TryCapture {
                One(button)
                
                ZeroOrMore {
                    " "
                    
                    One(button)
                }
            } transform: { substring -> [Button] in
                let parts = substring.components(separatedBy: " ")
                return parts.map { part in
                    let trimmed = part.trimmingCharacters(in: CharacterSet(charactersIn: "()"))
                    return trimmed.components(separatedBy: ",")
                        .compactMap(Int.init)
                }
            }
        }
        
        guard let output = description.firstMatch(of: regex)?.output else {
            return nil
        }
        
        self.startupSequence = output.1
        self.buttons = output.2
    }
}

private enum IndicatorLight: Character {
    case off = "."
    case on = "#"
    
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
            
        case .on:
            self = .off
        }
    }
}
