//
//  Day4.swift
//  AdventOfCode2025
//
//  Created by Marc-Antoine Malépart on 2025-12-04.
//


import Foundation
import Algorithms
import ArgumentParser
import AdventOfCodeUtilities

struct Day4: DayCommand {
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let rolls = rolls(input: try readFile())
        let clock = ContinuousClock()
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, numberOfRollsAccessibleByForklift) = clock.measure {
            part1(rolls: rolls)
        }
        print("How many rolls of paper can be accessed by a forklift?", numberOfRollsAccessibleByForklift)
        print("Elapsed time:", part1Duration, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let (part2Duration, numberOfRemovableRolls) = clock.measure {
            part2(rolls: rolls)
        }
        print(
            "How many rolls of paper in total can be removed by the Elves and their forklifts?",
            numberOfRemovableRolls
        )
        print("Elapsed time:", part2Duration)
    }
    
    private func rolls(input: String) -> Set<Point2D> {
        let grid = Grid2D<Square>(rawValue: input)
        return Set(grid.points)
    }
    
    private func part1(rolls: Set<Point2D>) -> Int {
        rolls.count(where: { point in
            adjacentRolls(to: point, in: rolls) < 4
        })
    }
    
    private func part2(rolls: Set<Point2D>) -> Int {
        var rolls = rolls
        var removedRolls = Set<Point2D>()
        var removedRollsPerIteration: Set<Point2D>
        
        repeat {
            removedRollsPerIteration = rolls.filter { point in
                adjacentRolls(to: point, in: rolls) < 4
            }
            
            removedRolls.formUnion(removedRollsPerIteration)
            rolls.subtract(removedRollsPerIteration)
        }
        while !removedRollsPerIteration.isEmpty
        
        return removedRolls.count
    }
}

private enum Square: Character {
    case roll = "@"
}

private func adjacentRolls(to point: Point2D, in rolls: Set<Point2D>) -> Int {
    let directions: [Translation2D] = [
        .up,
        .upRight,
        .right,
        .downRight,
        .down,
        .downLeft,
        .left,
        .upLeft,
    ]
    
    return directions.count(where: { translation in
        let adjacentPoint = point.applying(translation)
        return rolls.contains(adjacentPoint)
    })
}
