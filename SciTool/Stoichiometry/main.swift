//
//  main.swift
//  Stoichiometry
//
//  Created by Teddy Gaillard on 11/15/21.
//

import Foundation
import ArgumentParser

struct StoichiometryCommand: ParsableCommand {
	static var configuration = CommandConfiguration(commandName: "stoic", subcommands: [ReactCommand.self])
}

StoichiometryCommand.main()
