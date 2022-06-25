//
//  React.swift
//  Stoichiometry
//
//  Created by Teddy Gaillard on 11/16/21.
//

import Foundation
import ArgumentParser

struct ReactCommand: ParsableCommand {
	static var configuration = CommandConfiguration(commandName: "react")
	
	@Argument(help: "The balanced chemical equation of the reaction") var equation: String
	
	@Flag(name: .shortAndLong, help: "Verbose mode") var verbose = false
//	@Flag(name: .shortAndLong, help: "Already balanced") var balanced = false
	@Option(name: .shortAndLong, help: "Output format") var outputFormat: OutputFormat = .grams
	@Option(name: .shortAndLong, parsing: .upToNextOption, help: "Known reactants") var reactants: Array<Known> = []
	@Option(name: .shortAndLong, parsing: .upToNextOption, help: "Known products") var products: Array<Known> = []
	
	mutating func run() {
		do {
			let parsedEquation = try EquationParser.parse(self.equation)
			var measuredEquations = MeasuredEquation(equation: parsedEquation, verbose: self.verbose)
			let knownReactants = self.reactants.enumerated().filter {
				return $0.element.optional != nil
			}.map {
				return (index: $0.offset, grams: $0.element.optional!)
			}
			let knownProducts = self.products.enumerated().filter {
				return $0.element.optional != nil
			}.map {
				return (index: $0.offset, grams: $0.element.optional!)
			}
			try measuredEquations.applyKnowns(reactants: knownReactants, products: knownProducts)
			
			print("Reaction: \(parsedEquation)")
			if !parsedEquation.isBalanced {
				print("Warning: equation is not balanced")
			}
			
			if self.verbose {
				Self.printMolarMasses(equation: parsedEquation)
			}
	
			try measuredEquations.fill()
			
			print("Reactants:")
			for reactant in measuredEquations.reactants {
				guard let moles = reactant.moles else {
					fatalError("unreachable")
				}
				let massInGrams = moles * reactant.compound.molarMass
				print("\(reactant.compound) required: \(self.outputFormat.format(moles: moles, grams: massInGrams))")
			}
			
			print("Products:")
			for product in measuredEquations.products {
				guard let moles = product.moles else {
					fatalError("unreachable")
				}
				let massInGrams = moles * product.compound.molarMass
				print("\(product.compound) produced: \(self.outputFormat.format(moles: moles, grams: massInGrams))")
			}
		} catch let error {
			fatalError(error.localizedDescription)
		}
	}
	
	private static func printMolarMasses(equation: Equation) {
		print("Molar mass calculations:")
		for unit in equation.reactants + equation.products {
			print("Molar mass of \(unit.compound) = \(unit.compound.molarMassCalculation) = \(unit.compound.molarMass) g/mol")
		}
	}
	
	enum Known: ExpressibleByArgument {
		case moles(Double)
		case none
		
		init?(argument: String) {
			if argument == "?" {
				self = .none
			} else if let double = Double(argument) {
				self = .moles(double)
			} else {
				return nil
			}
		}
		
		var optional: Double? {
			switch self {
			case .moles(let value):
				return value
			case .none:
				return nil
			}
		}
	}
	
	enum OutputFormat: ExpressibleByArgument {
		case moles, grams, milligrams
		
		init?(argument: String) {
			switch argument {
			case "moles", "mol", "mole":
				self = .moles
			case "grams", "g", "gram":
				self = .grams
			case "milligrams", "mg", "milligram":
				self = .milligrams
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
			}
		}
	}
}
