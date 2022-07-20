//
//  MassCommand.swift
//  Stoichiometry
//
//  Created by Teddy Gaillard on 11/17/21.
//

import Foundation
//import ArgumentParser

class MassCommand {
	//static var configuration = CommandConfiguration(commandName: "mass")
	
	var compound: String = ""
	var moles: Double?
	var grams: Double?
	
    func run(compound: String, moles: Double?, grams: Double?) throws -> String {
        self.compound = compound
        self.moles = moles
        self.grams = grams
		let compound: Compound
		do {
			compound = try EquationParser.parseCompound(self.compound)
		} catch let error {
            throw MassError.GeneralError
		}
		
		
		guard moles == nil || grams == nil else {
            throw MassError.GeneralError
		}
		
		if let moles = self.moles {
			return "\(moles) moles of \(compound) = \(moles * compound.molarMass) g"
		} else if let grams = self.grams {
			return "\(grams) grams of \(compound) = \(grams / compound.molarMass) mol"
		}
        return "ERROR"
	}
    enum MassError: Error {
        case GeneralError
    }
}
