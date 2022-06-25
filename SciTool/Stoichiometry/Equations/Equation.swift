//
//  Equation.swift
//  Stoichiometry
//
//  Created by Teddy Gaillard on 11/15/21.
//

import Foundation

struct Equation: CustomStringConvertible {
	var reactants: Array<BalancedCompound>
	var products: Array<BalancedCompound>
	
	typealias BalancedCompound = (coefficient: Int, compound: Compound)
	
	var isBalanced: Bool {
		var reactantCount: Dictionary<String, Int> = [:]
		var productCount: Dictionary<String, Int> = [:]
		
		for reactant in self.reactants {
			Self.countElements(compound: reactant.compound, multiplier: reactant.coefficient, elementCount: &reactantCount)
		}
		for product in self.products {
			Self.countElements(compound: product.compound, multiplier: product.coefficient, elementCount: &productCount)
		}
		return reactantCount == productCount
	}
	
	var description: String {
		var output = ""
		for (index, balancedCompound) in self.reactants.enumerated() {
			if balancedCompound.coefficient != 1 {
				output += String(balancedCompound.coefficient)
			}
			output += balancedCompound.compound.description
			if index < self.reactants.count - 1 {
				output += " + "
			}
		}
		output += " -> "
		for (index, balancedCompound) in self.products.enumerated() {
			if balancedCompound.coefficient != 1 {
				output += String(balancedCompound.coefficient)
			}
			output += balancedCompound.compound.description
			if index < self.reactants.count - 1 {
				output += " + "
			}
		}
		return output
	}
	
	private static func countElements(compound: Compound, multiplier: Int, elementCount: inout Dictionary<String, Int>) {
		for unit in compound.contents {
			switch unit.unit {
			case .element(let element):
				if elementCount[element.symbol] == nil {
					elementCount[element.symbol] = 0
				}
				elementCount[element.symbol]! += unit.count * multiplier
			case .group(let subCompound):
				Self.countElements(compound: subCompound, multiplier: multiplier, elementCount: &elementCount)
			}
		}
	}
}
