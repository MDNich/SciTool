//
//  Element.swift
//  Stoichiometry
//
//  Created by Teddy Gaillard on 11/15/21.
//

import Foundation

struct Element: CustomStringConvertible {
	let name: String
	let alternateNames: Set<String>
	let symbol: String
	let atomicNumber: Int
	let mass: Double
	let series: Series?
	let electronegativity: Double?
	
	var description: String {
		self.name
	}
	
	init(name: String, alternateNames: Set<String>, symbol: String, atomicNumber: Int, mass: Double, series: Element.Series?, electronegativity: Double?) {
		self.name = name
		self.alternateNames = alternateNames
		self.symbol = symbol
		self.atomicNumber = atomicNumber
		self.mass = mass
		self.series = series
		self.electronegativity = electronegativity
	}
	
	init?(name: String) {
		for element in Self.elements {
			if element.name == name {
				self.init(
					name: element.name,
					alternateNames: element.alternateNames,
					symbol: element.symbol,
					atomicNumber: element.atomicNumber,
					mass: element.mass,
					series: element.series,
					electronegativity: element.electronegativity
				)
				return
			}
		}
		return nil
	}
	
	init?(atomicNumber: Int) {
		for element in Self.elements {
			if element.atomicNumber == atomicNumber {
				self.init(
					name: element.name,
					alternateNames: element.alternateNames,
					symbol: element.symbol,
					atomicNumber: element.atomicNumber,
					mass: element.mass,
					series: element.series,
					electronegativity: element.electronegativity
				)
				return
			}
		}
		return nil
	}
	
	init?(symbol: String) {
		for element in Self.elements {
			if element.symbol == symbol {
				self.init(
					name: element.name,
					alternateNames: element.alternateNames,
					symbol: element.symbol,
					atomicNumber: element.atomicNumber,
					mass: element.mass,
					series: element.series,
					electronegativity: element.electronegativity
				)
				return
			}
		}
		return nil
	}
	
	enum Series {
		case reactiveNonmetal, alkaliMetal, alkalineEarthMetal, transitionMetal, lanthanoid, actinoid, postTransitionMetal, metalloid, nobleGas
	}
}
