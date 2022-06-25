//
//  String+CharacterSets.swift
//  Stoichiometry
//
//  Created by Teddy Gaillard on 11/15/21.
//

import Foundation

extension String {
	static let lowercaseLetters = Set<Character>("abcdefghijklmnopqrtstuvwxyz")
	static let capitalLetters = Set<Character>("ABCDEFGHIJKLMNOPRSTUVWXYZ")
	static let digits = Set<Character>("0123456789")
	static let whitespace = Set<Character>(" \r\n\t")
}
