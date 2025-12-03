//
//  ClockExtensions.swift
//  AdventOfCode2025
//
//  Created by Marc-Antoine Malépart on 2025-12-02.
//


extension Clock {
    func measure<Result>(_ work: () throws -> Result) rethrows -> (duration: Instant.Duration, result: Result) {
        var result: Result!
        let duration = try measure {
            result = try work()
        }
        return (duration, result)
    }
}
