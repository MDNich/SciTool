//
//  EquationParser.swift
//  Stoichiometry
//
//  Created by Teddy Gaillard on 11/15/21.
//

import Foundation

class EquationParser {
	private let input: String
	private var current: Character
	private var state: State
	private var currentString: String
	private var output: Array<Token>
	
	private init(input: String) {
		self.input = input
		self.current = " "
		self.state = .free
		self.currentString = ""
		self.output = []
	}
	
	static func parse(_ input: String) throws -> Equation {
		let lexed = try Self.lex(input)
		let parsed = try Self.parse(lexed: lexed)
		return parsed
	}
	
	static func parseCompound(_ input: String) throws -> Compound {
		let lexed = try Self.lex(input)
		let parsed = try Self.parseCompound(lexed: lexed)
		return parsed
	}
	
	private func parse() throws {
		for character in self.input {
			self.current = character
			try self.handleCharacter()
		}
		try self.end()
	}
	
	private func handleCharacter() throws {
		switch self.state {
		case .free:
			try self.handleFree()
		case .block(level: let level):
			try self.handleBlock(level: level)
		case .element:
			try self.handleElement()
		case .number:
			try self.handleNumber()
		case .operation:
			try self.handleOperation()
		}
	}
	
	private func handleFree() throws {
		if String.capitalLetters.contains(self.current) {
			self.state = .element
			self.currentString = String(self.current)
		} else if String.digits.contains(self.current) {
			self.state = .number
			self.currentString = String(self.current)
		} else if self.current == "(" {
			self.state = .block(level: 1)
		} else if String.whitespace.contains(self.current) {
			self.state = .free
		} else if Token.Operation.characterSet.contains(self.current) {
			self.state = .operation
			self.currentString = String(self.current)
		} else {
			throw Error.unexpectedCharacter
		}
	}
	
	private func handleBlock(level: Int) throws {
		if self.current == "(" {
			self.state = .block(level: level + 1)
			self.currentString.append(self.current)
		} else if self.current == ")" {
			self.state = .block(level: level - 1)
			if level <= 1 {
				try self.output.append(.block(Self.lex(self.currentString)))
				self.currentString = ""
				self.state = .free
			}
		} else {
			self.currentString.append(self.current)
		}
	}
	
	private func handleElement() throws {
		if String.lowercaseLetters.contains(self.current) {
			self.currentString.append(self.current)
		} else if String.capitalLetters.contains(self.current) {
			try self.outputElement()
			self.state = .element
			self.currentString = String(self.current)
		} else if String.digits.contains(self.current) {
			try self.outputElement()
			self.state = .number
			self.currentString = String(self.current)
		} else if self.current == "(" {
			try self.outputElement()
			self.state = .block(level: 1)
			self.currentString = ""
		} else if Token.Operation.characterSet.contains(self.current) {
			try self.outputElement()
			self.state = .operation
			self.currentString = String(self.current)
		} else if String.whitespace.contains(self.current) {
			try self.outputElement()
			self.state = .free
			self.currentString = ""
		} else {
			throw Error.unexpectedCharacter
		}
	}
	
	private func handleNumber() throws {
		if String.digits.contains(self.current) {
			self.currentString.append(self.current)
		} else if String.capitalLetters.contains(self.current) {
			try self.outputNumber()
			self.state = .element
			self.currentString = String(self.current)
		} else if self.current == "(" {
			try self.outputNumber()
			self.state = .block(level: 1)
			self.currentString = ""
		} else if Token.Operation.characterSet.contains(self.current) {
			try self.outputNumber()
			self.state = .operation
			self.currentString = String(self.current)
		} else if String.whitespace.contains(self.current) {
			try self.outputNumber()
			self.state = .free
			self.currentString = ""
		} else {
			throw Error.unexpectedCharacter
		}
	}
	
	private func handleOperation() throws {
		if Token.Operation.characterSet.contains(self.current) {
			self.currentString.append(self.current)
		} else if String.capitalLetters.contains(self.current) {
			try self.outputOperation()
			self.state = .element
			self.currentString = String(self.current)
		} else if String.digits.contains(self.current) {
			try self.outputOperation()
			self.state = .number
			self.currentString = String(self.current)
		} else if self.current == "(" {
			try self.outputOperation()
			self.state = .block(level: 1)
			self.currentString = ""
		} else if String.whitespace.contains(self.current) {
			try self.outputOperation()
			self.state = .free
			self.currentString = ""
		} else {
			throw Error.unexpectedCharacter
		}
	}
	
	private func end() throws {
		switch self.state {
		case .free:
			break
		case .element:
			try self.outputElement()
		case .number:
			try self.outputNumber()
		case .operation:
			try self.outputOperation()
		case .block(_):
			throw Error.openBlock
		}
	}
	
	private func outputElement() throws {
		guard let element = Element(symbol: self.currentString) else {
			throw Error.invalidElement
		}
		self.output.append(.element(element))
	}
	
	private func outputNumber() throws {
		guard let number = Int(self.currentString) else {
			throw Error.unreachable
		}
		self.output.append(.number(number))
	}
	
	private func outputOperation() throws {
		guard let operation = Token.Operation(rawValue: self.currentString) else {
			throw Error.invalidOperation
		}
		self.output.append(.operation(operation))
	}
	
	private static func lex(_ input: String) throws -> Array<Token> {
		let parser = EquationParser(input: input)
		try parser.parse()
		return parser.output
	}
	
	private static func parse(lexed input: Array<Token>) throws -> Equation {
		guard let arrowIndex = (input.firstIndex { if case .operation(let operation) = $0, operation == .arrow { return true } else { return false }}) else {
			throw Error.noArrow
		}
		let reactantTokens = Array(input.prefix(upTo: arrowIndex))
		let productTokens = Array(input.suffix(from: arrowIndex + 1))
		let reactants = try Self.parseSide(lexed: reactantTokens)
		let products = try Self.parseSide(lexed: productTokens)
		
		return Equation(reactants: reactants, products: products)
	}
	
	private static func parseSide(lexed input: Array<Token>) throws -> Array<(coefficient: Int, compound: Compound)> {
		var compounds: Array<(coefficient: Int, compound: Compound)> = []
		var current: Array<Token> = []
		for token in input + [.operation(.add)] {
			if case .operation(let operation) = token, operation == .add {
				if case .number(let number) = current.first {
					let compound = try Self.parseCompound(lexed: Array(current.suffix(from: 1)))
					compounds.append((coefficient: number, compound: compound))
				} else {
					try compounds.append((coefficient: 1, compound: Self.parseCompound(lexed: current)))
				}
				current = []
			} else {
				current.append(token)
			}
		}
		return compounds
	}
	
	private static func parseCompound(lexed input: Array<Token>) throws -> Compound {
		var units: Array<(unit: Compound.Unit, count: Int)> = []
		var index = 0
		while index < input.count {
			switch input[index] {
			case .element(let element):
				if index < input.count - 1, case .number(let number) = input[index + 1] {
					units.append((unit: Compound.Unit.element(element), count: number))
					index += 1
				} else {
					units.append((unit: Compound.Unit.element(element), count: 1))
				}
			case .number(_):
				throw Error.unexpectedToken
			case .block(let block):
				if index < input.count - 1, case .number(let number) = input[index + 1] {
					try units.append((unit: Compound.Unit.group(parseCompound(lexed: block)), count: number))
					index += 1
				} else {
					try units.append((unit: Compound.Unit.group(parseCompound(lexed: block)), count: 1))
				}
			case .operation(_):
				throw Error.unexpectedToken
			}
			index += 1
		}
		
		return Compound(contents: units)
	}
	
	enum State {
		case free, element, number, operation
		case block(level: Int)
	}
	
	enum Token {
		case element(Element)
		case number(Int)
		case operation(Operation)
		case block(Array<Token>)
		
		enum Operation: String {
			case add = "+"
			case arrow = "->"
			
			static let characterSet = Set<Character>("+->")
		}
	}
	
	enum Error: Swift.Error {
		case unexpectedCharacter, invalidElement, unreachable, invalidOperation, openBlock, noArrow, unexpectedToken
	}
}
