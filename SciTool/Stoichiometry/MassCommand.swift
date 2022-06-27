//
//  MassCommand.swift
//  Stoichiometry
//
//  Created by Teddy Gaillard on 11/17/21.
//

import Foundation
import ArgumentParser

struct MassCommand: ParsableCommand {
	static var configuration = CommandConfiguration(commandName: "mass")
	
	@Argument(help: "The compound to calculate the mass of") var compound: String
	@Option(name: .shortAndLong, help: "A number of moles of compound to convert to grams")
	var moles: Double?
	@Option(name: .shortAndLong, help: "A number of grams of compound to convert to moles")
	var grams: Double?
	@Flag(name: .shortAndLong, help: "Verbose mode") var verbose = false
	
	mutating func run() throws {
		let compound: Compound
		do {
			compound = try EquationParser.parseCompound(self.compound)
		} catch let error {
			fatalError("Invalid compound: \(error)")
		}
		
		if self.verbose {
			print("Molar mass of \(compound) = \(compound.molarMassCalculation) = \(compound.molarMass) g/mol")
		}
		
		guard moles == nil || grams == nil else {
			fatalError("Moles and grams options are mutually exclusive")
		}
		
		if let moles = self.moles {
			print("\(moles) moles of \(compound) = \(moles * compound.molarMass) g")
		} else if let grams = self.grams {
			print("\(grams) grams of \(compound) = \(grams / compound.molarMass) mol")
		} else if !self.verbose {
			print("Molar mass of \(compound) = \(compound.molarMass) g/mol")
		}
	}
}
