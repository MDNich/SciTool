//
//  Compound.swift
//  Stoichiometry
//
//  Created by Teddy Gaillard on 11/15/21.
//

import Foundation

struct Compound: CustomStringConvertible {
	var contents: Array<(unit: Unit, count: Int)>
	
	var description: String {
		var output = ""
		for (unit, count) in contents {
			switch unit {
			case .element(let element):
				output += element.symbol
			case .group(let compound):
				output += "(\(compound.description))"
			}
			if count != 1 {
				output += String(count)
			}
		}
		return output
	}
	
	var molarMass: Double {
		var total: Double = 0
		for (unit, count) in self.contents {
			total += unit.molarMass * Double(count)
		}
		return total
	}
	
	var molarMassCalculation: String {
		var output = ""
		for (index, (unit, count)) in self.contents.enumerated() {
			let unitCalculation = unit.molarMassCalculation
			let multipliedCalculation = count == 1 ? unitCalculation : "\(count)x\(unitCalculation)"
			output += multipliedCalculation
			if index < self.contents.count - 1 {
				output += " + "
			}
		}
		return output
	}
	
	indirect enum Unit {
		case element(Element)
		case group(Compound)
		
		var molarMass: Double {
			switch self {
			case .element(let element):
				return element.mass
			case .group(let compound):
				return compound.molarMass
			}
		}
		
		var molarMassCalculation: String {
			switch self {
			case .element(let element):
				return String(element.mass)
			case .group(let compound):
				return "(\(compound.molarMassCalculation))"
			}
		}
	}
}
