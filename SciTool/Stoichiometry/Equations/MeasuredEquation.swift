//
//  MeasuredEquation.swift
//  Stoichiometry
//
//  Created by Teddy Gaillard on 11/15/21.
//

import Foundation

struct MeasuredEquation {
	var reactants: Array<MeasuredCompound>
	var products: Array<MeasuredCompound>
	var verbose: Bool
	
	init(reactants: Array<MeasuredEquation.MeasuredCompound>, products: Array<MeasuredEquation.MeasuredCompound>, verbose: Bool) {
		self.reactants = reactants
		self.products = products
		self.verbose = verbose
	}
	
	init(equation: Equation, verbose: Bool) {
		self.reactants = equation.reactants.map { return (coefficient: $0.coefficient, compound: $0.compound, moles: nil) }
		self.products = equation.products.map { return (coefficient: $0.coefficient, compound: $0.compound, moles: nil) }
		self.verbose = verbose
	}
	
	mutating func applyKnown(index: Int, reactantMoles: Double) throws {
		guard index < self.reactants.count else {
			throw Error.outOfRange
		}
		self.reactants[index].moles = reactantMoles
	}
	
	mutating func applyKnown(index: Int, reactantGrams: Double) throws {
		guard index < self.reactants.count else {
			throw Error.outOfRange
		}
		self.reactants[index].moles = reactantGrams / self.reactants[index].compound.molarMass
	}
	
	mutating func applyKnown(index: Int, productMoles: Double) throws {
		guard index < self.products.count else {
			throw Error.outOfRange
		}
		self.products[index].moles = productMoles
	}
	
	mutating func applyKnown(index: Int, productGrams: Double) throws {
		guard index < self.products.count else {
			throw Error.outOfRange
		}
		self.products[index].moles = productGrams / self.products[index].compound.molarMass
	}
	
	mutating func fill() throws {
		self = try self.filled()
	}
	
	func filled() throws -> Self {
		if self.verbose {
			print("\u{1B}[1mLimiting factor calculation:\u{1B}[0m")
		}
		
		var smallestReactionsPossible: Double? = nil
		var limitingFactor: Compound? = nil
		for (coefficient, compound, moles) in self.reactants where moles != nil {
			let reactionsPossible = moles! / Double(coefficient)
			
			if smallestReactionsPossible == nil {
				smallestReactionsPossible = reactionsPossible
				limitingFactor = compound
			} else if reactionsPossible < smallestReactionsPossible! {
				smallestReactionsPossible = reactionsPossible
				limitingFactor = compound
			}
			
			if self.verbose {
				print("Number of reactions possible with \(moles!) mol of \(compound): \(moles! / Double(coefficient))")
			}
		}
		for (coefficient, compound, moles) in self.products where moles != nil {
			let reactionsPossible = moles! / Double(coefficient)
			
			if smallestReactionsPossible == nil {
				smallestReactionsPossible = reactionsPossible
				limitingFactor = compound
			} else if reactionsPossible < smallestReactionsPossible! {
				smallestReactionsPossible = reactionsPossible
				limitingFactor = compound
			}
			
			if self.verbose {
				print("Number of reactions to produce \(moles!) mol of \(compound): \(moles! / Double(coefficient))")
			}
		}
		
		guard let reactionsOccurring = smallestReactionsPossible, let limitingFactor = limitingFactor else {
			throw Error.noKnowns
		}
		
		if self.verbose {
			print("Limiting factor: \(limitingFactor) (\(reactionsOccurring) reactions occurring)")
		}
		
		var outputReactants: Array<MeasuredCompound> = []
		for reactant in self.reactants {
			outputReactants.append((coefficient: reactant.coefficient, compound: reactant.compound, moles: Double(reactant.coefficient) * reactionsOccurring))
			
			if self.verbose {
				print("\(Double(reactant.coefficient) * reactionsOccurring) mol \(reactant.compound) used")
			}
		}
		var outputProducts: Array<MeasuredCompound> = []
		for product in self.products {
			outputProducts.append((coefficient: product.coefficient, compound: product.compound, moles: Double(product.coefficient) * reactionsOccurring))
			
			if self.verbose {
				print("\(Double(product.coefficient) * reactionsOccurring) mol \(product.compound) produced")
			}
		}
		
		return Self(reactants: outputReactants, products: outputProducts, verbose: self.verbose)
	}
	
	typealias MeasuredCompound = (coefficient: Int, compound: Compound, moles: Double?)
	
	enum Error: Swift.Error {
		case outOfRange, noKnowns
	}
}
