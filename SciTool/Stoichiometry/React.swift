//
//  React.swift
//  Stoichiometry
//
//  Created by Teddy Gaillard on 11/16/21.
//

import Foundation
import ArgumentParser

class ReactCommand {
	static var configuration = CommandConfiguration(commandName: "react")
	
	//@Argument(help: "The balanced chemical equation of the reaction") var equation: String
    var equation: String = ""
    var balanced = false
    var outputFormat: FormatUnit = .grams
    var verbose = false
    var reactants: Array<Known> = []
    var products: Array<Known> = []
	//@Flag(name: .shortAndLong, help: "Verbose mode") var verbose = false
//	@Flag(name: .shortAndLong, help: "Already balanced") var balanced = false
	//@Option(name: .shortAndLong, help: "Output format") var outputFormat: OutputFormat = .grams
	//@Option(name: .shortAndLong, parsing: .upToNextOption, help: "Known reactants") var reactants: Array<Known> = []
	//@Option(name: .shortAndLong, parsing: .upToNextOption, help: "Known products") var products: Array<Known> = []
	
    // $ stoic react "Na2(CO3) + CaCl2 -> Ca(CO3) + 2NaCl" -p 2 ?
    func run(equation: String, reactants: Array<Known>, products: Array<Known>) throws -> String {
        self.equation = equation
        self.reactants = reactants
        self.products = products
        var resultsPrinting: [String] = []
        do {
            let parsedEquation = try EquationParser.parse(self.equation)
            var measuredEquation = MeasuredEquation(equation: parsedEquation, verbose: self.verbose)
            let knownReactants = self.reactants.enumerated().filter {
                return $0.element.number != nil && $0.element.unit != nil
            }
            let knownProducts = self.products.enumerated().filter {
                return $0.element.number != nil
            }
            
            do {
                for knownReactant in knownReactants {
                    switch knownReactant.element.unit! {
                    case .moles:
                        try measuredEquation.applyKnown(index: knownReactant.offset, reactantMoles: knownReactant.element.number!)
                    case .grams:
                        try measuredEquation.applyKnown(index: knownReactant.offset, reactantGrams: knownReactant.element.number!)
                    case .milligrams:
                        try measuredEquation.applyKnown(index: knownReactant.offset, reactantGrams: knownReactant.element.number! / 1000)
                    case .liters:
                        try measuredEquation.applyKnown(index: knownReactant.offset, reactantMoles: knownReactant.element.number! / 22.4)
                    case .milliliters:
                        try measuredEquation.applyKnown(index: knownReactant.offset, reactantMoles: knownReactant.element.number! / 22400)
                    }
                }
                for knownProduct in knownProducts {
                    switch knownProduct.element.unit! {
                    case .moles:
                        try measuredEquation.applyKnown(index: knownProduct.offset, productMoles: knownProduct.element.number!)
                    case .grams:
                        try measuredEquation.applyKnown(index: knownProduct.offset, productGrams: knownProduct.element.number!)
                    case .milligrams:
                        try measuredEquation.applyKnown(index: knownProduct.offset, productGrams: knownProduct.element.number! / 1000)
                    case .liters:
                        try measuredEquation.applyKnown(index: knownProduct.offset, productMoles: knownProduct.element.number! / 22.4)
                    case .milliliters:
                        try measuredEquation.applyKnown(index: knownProduct.offset, productMoles: knownProduct.element.number! / 22400)
                    }
                }
            } catch let error {
                throw ReactError.CannotParseError
            }
            
            print("Reaction: \(parsedEquation)")
            resultsPrinting.append("Reaction: \(parsedEquation)")
            if !parsedEquation.isBalanced {
                resultsPrinting.append("Warning: equation is not balanced")
                print("\u{1B}[33mWarning: equation is not balanced\u{1B}[0m")
            }
            
            if self.verbose {
                Self.printMolarMasses(equation: parsedEquation)
            }
    
            try measuredEquation.fill()
            
            print("Reactants:")
            resultsPrinting.append("Reactants:")
            for reactant in measuredEquation.reactants {
                guard let moles = reactant.moles else {
                    throw ReactError.CannotParseError
                }
                let massInGrams = moles * reactant.compound.molarMass
                resultsPrinting.append("\(reactant.compound) required: \(self.outputFormat.format(moles: moles, grams: massInGrams))")
                print("\(reactant.compound) required: \(self.outputFormat.format(moles: moles, grams: massInGrams))")
            }
            
            resultsPrinting.append("Products:")
            print("Products:")
            for product in measuredEquation.products {
                guard let moles = product.moles else {
                    throw ReactError.CannotParseError
                }
                let massInGrams = moles * product.compound.molarMass
                resultsPrinting.append("\(product.compound) produced: \(self.outputFormat.format(moles: moles, grams: massInGrams))")
                print("\(product.compound) produced: \(self.outputFormat.format(moles: moles, grams: massInGrams))")
            }
        } catch let error {
            throw ReactError.CannotParseError
        }
        var stringToReturn = ""
        for stringSub in resultsPrinting  {
            stringToReturn = "\(stringToReturn)\(stringSub)\n"
        }
        return stringToReturn
    }
    
    private static func printMolarMasses(equation: Equation) {
        print("\u{1B}[1mMolar mass calculations:\u{1B}[0m")
        for unit in equation.reactants + equation.products {
            print("Molar mass of \(unit.compound) = \(unit.compound.molarMassCalculation) = \(unit.compound.molarMass) g/mol")
        }
    }
    
    struct Known: ExpressibleByArgument {
        init?(argument: String) {
            do {
                try initThrowing(argument: argument)
            }
            catch {
                return nil
            }
        }
        
        var number: Double?
        var unit: FormatUnit?
        
        mutating func initThrowing(argument: String) throws {
            if argument == "?" {
                self.number = nil
                self.unit = nil
            } else if argument.hasSuffix("g"), let number = Double(argument.prefix(argument.count - 1)) {
                self.number = number
                self.unit = .grams
            } else if argument.hasSuffix("mg"), let number = Double(argument.prefix(argument.count - 2)) {
                self.number = number
                self.unit = .milligrams
            } else if argument.hasSuffix("mol"), let number = Double(argument.prefix(argument.count - 3)) {
                self.number = number
                self.unit = .moles
            } else if argument.hasSuffix("l"), let number = Double(argument.prefix(argument.count - 1)) {
                self.number = number
                self.unit = .liters
            } else if argument.hasSuffix("L"), let number = Double(argument.prefix(argument.count - 1)) {
                self.number = number
                self.unit = .liters
            } else if argument.hasSuffix("ml"), let number = Double(argument.prefix(argument.count - 2)) {
                self.number = number
                self.unit = .milliliters
           } else if argument.hasSuffix("mL"), let number = Double(argument.prefix(argument.count - 2)) {
                self.number = number
                self.unit = .milliliters
            }else {
                throw ReactError.CannotParseError
                // default is 1 moles
            }
        }
    }
    
    enum FormatUnit: ExpressibleByArgument {
        case moles, grams, milligrams, liters, milliliters
        
        init?(argument: String) {
            switch argument {
            case "moles", "mol", "mole":
                self = .moles
            case "grams", "g", "gram":
                self = .grams
            case "milligrams", "mg", "milligram":
                self = .milligrams
            case "liters", "l", "liter":
                self = .liters
            case "milliliters", "ml", "milliliter":
                self = .milliliters
            default:
                return nil
            }
        }
        
        func format(moles: Double, grams: Double) -> String {
            switch self {
            case .moles:
                return "\(moles) mol"
            case .grams:
                return "\(grams)g"
            case .milligrams:
                return "\(grams * 1000)mg"
            case .liters:
                return "\(moles * 22.4)l"
            case .milliliters:
                return "\(moles * 22400)ml"
            }
        }
    }
    
    enum ReactError: Error {
        case CannotParseError
    }
}
