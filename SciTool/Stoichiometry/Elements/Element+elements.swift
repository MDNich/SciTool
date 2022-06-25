//
//  Element+elements.swift
//  Stoichiometry
//
//  Created by Teddy Gaillard on 11/15/21.
//

import Foundation

extension Element {
	static let elements: Array<Element> = [
		Self(
			name: "Hydrogen",
			alternateNames: [],
			symbol: "H",
			atomicNumber: 1,
			mass: 1.008,
			series: .reactiveNonmetal,
			electronegativity: 2.2
		),
		Self(
			name: "Helium",
			alternateNames: [],
			symbol: "He",
			atomicNumber: 2,
			mass: 4.0026022,
			series: .nobleGas,
			electronegativity: nil
		),
		Self(
			name: "Lithium",
			alternateNames: [],
			symbol: "Li",
			atomicNumber: 3,
			mass: 6.94,
			series: .alkaliMetal,
			electronegativity: 0.98
		),
		Self(
			name: "Beryllium",
			alternateNames: [],
			symbol: "Be",
			atomicNumber: 4,
			mass: 9.01218315,
			series: .alkalineEarthMetal,
			electronegativity: 1.57
		),
		Self(
			name: "Boron",
			alternateNames: [],
			symbol: "B",
			atomicNumber: 5,
			mass: 10.81,
			series: .metalloid,
			electronegativity: 2.04
		),
		Self(
			name: "Carbon",
			alternateNames: [],
			symbol: "C",
			atomicNumber: 6,
			mass: 12.011,
			series: .reactiveNonmetal,
			electronegativity: 2.55
		),
		Self(
			name: "Nitrogen",
			alternateNames: [],
			symbol: "N",
			atomicNumber: 7,
			mass: 14.007,
			series: .reactiveNonmetal,
			electronegativity: 3.04
		),
		Self(
			name: "Oxygen",
			alternateNames: [],
			symbol: "O",
			atomicNumber: 8,
			mass: 15.999,
			series: .reactiveNonmetal,
			electronegativity: 3.44
		),
		Self(
			name: "Fluorine",
			alternateNames: [],
			symbol: "F",
			atomicNumber: 9,
			mass: 18.9984031636,
			series: .reactiveNonmetal,
			electronegativity: 3.98
		),
		Self(
			name: "Neon",
			alternateNames: [],
			symbol: "Ne",
			atomicNumber: 10,
			mass: 20.17976,
			series: .nobleGas,
			electronegativity: nil
		),
		Self(
			name: "Sodium",
			alternateNames: [],
			symbol: "Na",
			atomicNumber: 11,
			mass: 22.989769282,
			series: .alkaliMetal,
			electronegativity: 0.93
		),
		Self(
			name: "Magnesium",
			alternateNames: [],
			symbol: "Mg",
			atomicNumber: 12,
			mass: 24.305,
			series: .alkalineEarthMetal,
			electronegativity: 1.31
		),
		Self(
			name: "Aluminium",
			alternateNames: [],
			symbol: "Al",
			atomicNumber: 13,
			mass: 26.98153857,
			series: .postTransitionMetal,
			electronegativity: 1.61
		),
		Self(
			name: "Silicon",
			alternateNames: [],
			symbol: "Si",
			atomicNumber: 14,
			mass: 28.085,
			series: .metalloid,
			electronegativity: 1.9
		),
		Self(
			name: "Phosphorus",
			alternateNames: [],
			symbol: "P",
			atomicNumber: 15,
			mass: 30.9737619985,
			series: .reactiveNonmetal,
			electronegativity: 2.19
		),
		Self(
			name: "Sulfur",
			alternateNames: [],
			symbol: "S",
			atomicNumber: 16,
			mass: 32.06,
			series: .reactiveNonmetal,
			electronegativity: 2.58
		),
		Self(
			name: "Chlorine",
			alternateNames: [],
			symbol: "Cl",
			atomicNumber: 17,
			mass: 35.45,
			series: .reactiveNonmetal,
			electronegativity: 3.16
		),
		Self(
			name: "Argon",
			alternateNames: [],
			symbol: "Ar",
			atomicNumber: 18,
			mass: 39.9481,
			series: .nobleGas,
			electronegativity: nil
		),
		Self(
			name: "Potassium",
			alternateNames: [],
			symbol: "K",
			atomicNumber: 19,
			mass: 39.09831,
			series: .alkaliMetal,
			electronegativity: 0.82
		),
		Self(
			name: "Calcium",
			alternateNames: [],
			symbol: "Ca",
			atomicNumber: 20,
			mass: 40.0784,
			series: .alkalineEarthMetal,
			electronegativity: 1
		),
		Self(
			name: "Scandium",
			alternateNames: [],
			symbol: "Sc",
			atomicNumber: 21,
			mass: 44.9559085,
			series: .transitionMetal,
			electronegativity: 1.36
		),
		Self(
			name: "Titanium",
			alternateNames: [],
			symbol: "Ti",
			atomicNumber: 22,
			mass: 47.8671,
			series: .transitionMetal,
			electronegativity: 1.54
		),
		Self(
			name: "Vanadium",
			alternateNames: [],
			symbol: "V",
			atomicNumber: 23,
			mass: 50.94151,
			series: .transitionMetal,
			electronegativity: 1.63
		),
		Self(
			name: "Chromium",
			alternateNames: [],
			symbol: "Cr",
			atomicNumber: 24,
			mass: 51.99616,
			series: .transitionMetal,
			electronegativity: 1.66
		),
		Self(
			name: "Manganese",
			alternateNames: [],
			symbol: "Mn",
			atomicNumber: 25,
			mass: 54.9380443,
			series: .transitionMetal,
			electronegativity: 1.55
		),
		Self(
			name: "Iron",
			alternateNames: [],
			symbol: "Fe",
			atomicNumber: 26,
			mass: 55.8452,
			series: .transitionMetal,
			electronegativity: 1.83
		),
		Self(
			name: "Cobalt",
			alternateNames: [],
			symbol: "Co",
			atomicNumber: 27,
			mass: 58.9331944,
			series: .transitionMetal,
			electronegativity: 1.88
		),
		Self(
			name: "Nickel",
			alternateNames: [],
			symbol: "Ni",
			atomicNumber: 28,
			mass: 58.69344,
			series: .transitionMetal,
			electronegativity: 1.91
		),
		Self(
			name: "Copper",
			alternateNames: [],
			symbol: "Cu",
			atomicNumber: 29,
			mass: 63.5463,
			series: .transitionMetal,
			electronegativity: 1.9
		),
		Self(
			name: "Zinc",
			alternateNames: [],
			symbol: "Zn",
			atomicNumber: 30,
			mass: 65.382,
			series: .transitionMetal,
			electronegativity: 1.65
		),
		Self(
			name: "Gallium",
			alternateNames: [],
			symbol: "Ga",
			atomicNumber: 31,
			mass: 69.7231,
			series: .postTransitionMetal,
			electronegativity: 1.81
		),
		Self(
			name: "Germanium",
			alternateNames: [],
			symbol: "Ge",
			atomicNumber: 32,
			mass: 72.6308,
			series: .metalloid,
			electronegativity: 2.01
		),
		Self(
			name: "Arsenic",
			alternateNames: [],
			symbol: "As",
			atomicNumber: 33,
			mass: 74.9215956,
			series: .metalloid,
			electronegativity: 2.18
		),
		Self(
			name: "Selenium",
			alternateNames: [],
			symbol: "Se",
			atomicNumber: 34,
			mass: 78.9718,
			series: .reactiveNonmetal,
			electronegativity: 2.55
		),
		Self(
			name: "Bromine",
			alternateNames: [],
			symbol: "Br",
			atomicNumber: 35,
			mass: 79.904,
			series: .reactiveNonmetal,
			electronegativity: 2.96
		),
		Self(
			name: "Krypton",
			alternateNames: [],
			symbol: "Kr",
			atomicNumber: 36,
			mass: 83.7982,
			series: .nobleGas,
			electronegativity: 3
		),
		Self(
			name: "Rubidium",
			alternateNames: [],
			symbol: "Rb",
			atomicNumber: 37,
			mass: 85.46783,
			series: .alkaliMetal,
			electronegativity: 0.82
		),
		Self(
			name: "Strontium",
			alternateNames: [],
			symbol: "Sr",
			atomicNumber: 38,
			mass: 87.621,
			series: .alkalineEarthMetal,
			electronegativity: 0.95
		),
		Self(
			name: "Yttrium",
			alternateNames: [],
			symbol: "Y",
			atomicNumber: 39,
			mass: 88.905842,
			series: .transitionMetal,
			electronegativity: 1.22
		),
		Self(
			name: "Zirconium",
			alternateNames: [],
			symbol: "Zr",
			atomicNumber: 40,
			mass: 91.2242,
			series: .transitionMetal,
			electronegativity: 1.33
		),
		Self(
			name: "Niobium",
			alternateNames: [],
			symbol: "Nb",
			atomicNumber: 41,
			mass: 92.906372,
			series: .transitionMetal,
			electronegativity: 1.6
		),
		Self(
			name: "Molybdenum",
			alternateNames: [],
			symbol: "Mo",
			atomicNumber: 42,
			mass: 95.951,
			series: .transitionMetal,
			electronegativity: 2.16
		),
		Self(
			name: "Technetium",
			alternateNames: [],
			symbol: "Tc",
			atomicNumber: 43,
			mass: 98,
			series: .transitionMetal,
			electronegativity: 1.9
		),
		Self(
			name: "Ruthenium",
			alternateNames: [],
			symbol: "Ru",
			atomicNumber: 44,
			mass: 101.072,
			series: .transitionMetal,
			electronegativity: 2.2
		),
		Self(
			name: "Rhodium",
			alternateNames: [],
			symbol: "Rh",
			atomicNumber: 45,
			mass: 102.905502,
			series: .transitionMetal,
			electronegativity: 2.28
		),
		Self(
			name: "Palladium",
			alternateNames: [],
			symbol: "Pd",
			atomicNumber: 46,
			mass: 106.421,
			series: .transitionMetal,
			electronegativity: 2.2
		),
		Self(
			name: "Silver",
			alternateNames: [],
			symbol: "Ag",
			atomicNumber: 47,
			mass: 107.86822,
			series: .transitionMetal,
			electronegativity: 1.93
		),
		Self(
			name: "Cadmium",
			alternateNames: [],
			symbol: "Cd",
			atomicNumber: 48,
			mass: 112.4144,
			series: .transitionMetal,
			electronegativity: 1.69
		),
		Self(
			name: "Indium",
			alternateNames: [],
			symbol: "In",
			atomicNumber: 49,
			mass: 114.8181,
			series: .postTransitionMetal,
			electronegativity: 1.78
		),
		Self(
			name: "Tin",
			alternateNames: [],
			symbol: "Sn",
			atomicNumber: 50,
			mass: 118.7107,
			series: .postTransitionMetal,
			electronegativity: 1.96
		),
		Self(
			name: "Antimony",
			alternateNames: [],
			symbol: "Sb",
			atomicNumber: 51,
			mass: 121.7601,
			series: .metalloid,
			electronegativity: 2.05
		),
		Self(
			name: "Tellurium",
			alternateNames: [],
			symbol: "Te",
			atomicNumber: 52,
			mass: 127.603,
			series: .metalloid,
			electronegativity: 2.1
		),
		Self(
			name: "Iodine",
			alternateNames: [],
			symbol: "I",
			atomicNumber: 53,
			mass: 126.904473,
			series: .reactiveNonmetal,
			electronegativity: 2.66
		),
		Self(
			name: "Xenon",
			alternateNames: [],
			symbol: "Xe",
			atomicNumber: 54,
			mass: 131.2936,
			series: .nobleGas,
			electronegativity: 2.6
		),
		Self(
			name: "Cesium",
			alternateNames: [],
			symbol: "Cs",
			atomicNumber: 55,
			mass: 132.905451966,
			series: .alkaliMetal,
			electronegativity: 0.79
		),
		Self(
			name: "Barium",
			alternateNames: [],
			symbol: "Ba",
			atomicNumber: 56,
			mass: 137.3277,
			series: .alkalineEarthMetal,
			electronegativity: 0.89
		),
		Self(
			name: "Lanthanum",
			alternateNames: [],
			symbol: "La",
			atomicNumber: 57,
			mass: 138.905477,
			series: .lanthanoid,
			electronegativity: 1.1
		),
		Self(
			name: "Cerium",
			alternateNames: [],
			symbol: "Ce",
			atomicNumber: 58,
			mass: 140.1161,
			series: .lanthanoid,
			electronegativity: 1.12
		),
		Self(
			name: "Praseodymium",
			alternateNames: [],
			symbol: "Pr",
			atomicNumber: 59,
			mass: 140.907662,
			series: .lanthanoid,
			electronegativity: 1.13
		),
		Self(
			name: "Neodymium",
			alternateNames: [],
			symbol: "Nd",
			atomicNumber: 60,
			mass: 144.2423,
			series: .lanthanoid,
			electronegativity: 1.14
		),
		Self(
			name: "Promethium",
			alternateNames: [],
			symbol: "Pm",
			atomicNumber: 61,
			mass: 145,
			series: .lanthanoid,
			electronegativity: 1.13
		),
		Self(
			name: "Samarium",
			alternateNames: [],
			symbol: "Sm",
			atomicNumber: 62,
			mass: 150.362,
			series: .lanthanoid,
			electronegativity: 1.17
		),
		Self(
			name: "Europium",
			alternateNames: [],
			symbol: "Eu",
			atomicNumber: 63,
			mass: 151.9641,
			series: .lanthanoid,
			electronegativity: 1.2
		),
		Self(
			name: "Gadolinium",
			alternateNames: [],
			symbol: "Gd",
			atomicNumber: 64,
			mass: 157.253,
			series: .lanthanoid,
			electronegativity: 1.2
		),
		Self(
			name: "Terbium",
			alternateNames: [],
			symbol: "Tb",
			atomicNumber: 65,
			mass: 158.925352,
			series: .lanthanoid,
			electronegativity: 1.1
		),
		Self(
			name: "Dysprosium",
			alternateNames: [],
			symbol: "Dy",
			atomicNumber: 66,
			mass: 162.5001,
			series: .lanthanoid,
			electronegativity: 1.22
		),
		Self(
			name: "Holmium",
			alternateNames: [],
			symbol: "Ho",
			atomicNumber: 67,
			mass: 164.930332,
			series: .lanthanoid,
			electronegativity: 1.23
		),
		Self(
			name: "Erbium",
			alternateNames: [],
			symbol: "Er",
			atomicNumber: 68,
			mass: 167.2593,
			series: .lanthanoid,
			electronegativity: 1.24
		),
		Self(
			name: "Thulium",
			alternateNames: [],
			symbol: "Tm",
			atomicNumber: 69,
			mass: 168.934222,
			series: .lanthanoid,
			electronegativity: 1.25
		),
		Self(
			name: "Ytterbium",
			alternateNames: [],
			symbol: "Yb",
			atomicNumber: 70,
			mass: 173.0451,
			series: .lanthanoid,
			electronegativity: 1.1
		),
		Self(
			name: "Lutetium",
			alternateNames: [],
			symbol: "Lu",
			atomicNumber: 71,
			mass: 174.96681,
			series: .lanthanoid,
			electronegativity: 1.27
		),
		Self(
			name: "Hafnium",
			alternateNames: [],
			symbol: "Hf",
			atomicNumber: 72,
			mass: 178.492,
			series: .transitionMetal,
			electronegativity: 1.3
		),
		Self(
			name: "Tantalum",
			alternateNames: [],
			symbol: "Ta",
			atomicNumber: 73,
			mass: 180.947882,
			series: .transitionMetal,
			electronegativity: 1.5
		),
		Self(
			name: "Tungsten",
			alternateNames: [],
			symbol: "W",
			atomicNumber: 74,
			mass: 183.841,
			series: .transitionMetal,
			electronegativity: 2.36
		),
		Self(
			name: "Rhenium",
			alternateNames: [],
			symbol: "Re",
			atomicNumber: 75,
			mass: 186.2071,
			series: .transitionMetal,
			electronegativity: 1.9
		),
		Self(
			name: "Osmium",
			alternateNames: [],
			symbol: "Os",
			atomicNumber: 76,
			mass: 190.233,
			series: .transitionMetal,
			electronegativity: 2.2
		),
		Self(
			name: "Iridium",
			alternateNames: [],
			symbol: "Ir",
			atomicNumber: 77,
			mass: 192.2173,
			series: .transitionMetal,
			electronegativity: 2.2
		),
		Self(
			name: "Platinum",
			alternateNames: [],
			symbol: "Pt",
			atomicNumber: 78,
			mass: 195.0849,
			series: .transitionMetal,
			electronegativity: 2.28
		),
		Self(
			name: "Gold",
			alternateNames: [],
			symbol: "Au",
			atomicNumber: 79,
			mass: 196.9665695,
			series: .transitionMetal,
			electronegativity: 2.54
		),
		Self(
			name: "Mercury",
			alternateNames: [],
			symbol: "Hg",
			atomicNumber: 80,
			mass: 200.5923,
			series: .transitionMetal,
			electronegativity: 2
		),
		Self(
			name: "Thallium",
			alternateNames: [],
			symbol: "Tl",
			atomicNumber: 81,
			mass: 204.38,
			series: .postTransitionMetal,
			electronegativity: 1.62
		),
		Self(
			name: "Lead",
			alternateNames: [],
			symbol: "Pb",
			atomicNumber: 82,
			mass: 207.21,
			series: .postTransitionMetal,
			electronegativity: 1.87
		),
		Self(
			name: "Bismuth",
			alternateNames: [],
			symbol: "Bi",
			atomicNumber: 83,
			mass: 208.980401,
			series: .postTransitionMetal,
			electronegativity: 2.02
		),
		Self(
			name: "Polonium",
			alternateNames: [],
			symbol: "Po",
			atomicNumber: 84,
			mass: 209,
			series: .postTransitionMetal,
			electronegativity: 2
		),
		Self(
			name: "Astatine",
			alternateNames: [],
			symbol: "At",
			atomicNumber: 85,
			mass: 210,
			series: .metalloid,
			electronegativity: 2.2
		),
		Self(
			name: "Radon",
			alternateNames: [],
			symbol: "Rn",
			atomicNumber: 86,
			mass: 222,
			series: .nobleGas,
			electronegativity: 2.2
		),
		Self(
			name: "Francium",
			alternateNames: [],
			symbol: "Fr",
			atomicNumber: 87,
			mass: 223,
			series: .alkaliMetal,
			electronegativity: 0.79
		),
		Self(
			name: "Radium",
			alternateNames: [],
			symbol: "Ra",
			atomicNumber: 88,
			mass: 226,
			series: .alkalineEarthMetal,
			electronegativity: 0.9
		),
		Self(
			name: "Actinium",
			alternateNames: [],
			symbol: "Ac",
			atomicNumber: 89,
			mass: 227,
			series: .actinoid,
			electronegativity: 1.1
		),
		Self(
			name: "Thorium",
			alternateNames: [],
			symbol: "Th",
			atomicNumber: 90,
			mass: 232.03774,
			series: .actinoid,
			electronegativity: 1.3
		),
		Self(
			name: "Protactinium",
			alternateNames: [],
			symbol: "Pa",
			atomicNumber: 91,
			mass: 231.035882,
			series: .actinoid,
			electronegativity: 1.5
		),
		Self(
			name: "Uranium",
			alternateNames: [],
			symbol: "U",
			atomicNumber: 92,
			mass: 238.028913,
			series: .actinoid,
			electronegativity: 1.38
		),
		Self(
			name: "Neptunium",
			alternateNames: [],
			symbol: "Np",
			atomicNumber: 93,
			mass: 237,
			series: .actinoid,
			electronegativity: 1.36
		),
		Self(
			name: "Plutonium",
			alternateNames: [],
			symbol: "Pu",
			atomicNumber: 94,
			mass: 244,
			series: .actinoid,
			electronegativity: 1.28
		),
		Self(
			name: "Americium",
			alternateNames: [],
			symbol: "Am",
			atomicNumber: 95,
			mass: 243,
			series: .actinoid,
			electronegativity: 1.13
		),
		Self(
			name: "Curium",
			alternateNames: [],
			symbol: "Cm",
			atomicNumber: 96,
			mass: 247,
			series: .actinoid,
			electronegativity: 1.28
		),
		Self(
			name: "Berkelium",
			alternateNames: [],
			symbol: "Bk",
			atomicNumber: 97,
			mass: 247,
			series: .actinoid,
			electronegativity: 1.3
		),
		Self(
			name: "Californium",
			alternateNames: [],
			symbol: "Cf",
			atomicNumber: 98,
			mass: 251,
			series: .actinoid,
			electronegativity: 1.3
		),
		Self(
			name: "Einsteinium",
			alternateNames: [],
			symbol: "Es",
			atomicNumber: 99,
			mass: 252,
			series: .actinoid,
			electronegativity: 1.3
		),
		Self(
			name: "Fermium",
			alternateNames: [],
			symbol: "Fm",
			atomicNumber: 100,
			mass: 257,
			series: .actinoid,
			electronegativity: 1.3
		),
		Self(
			name: "Mendelevium",
			alternateNames: [],
			symbol: "Md",
			atomicNumber: 101,
			mass: 258,
			series: .actinoid,
			electronegativity: 1.3
		),
		Self(
			name: "Nobelium",
			alternateNames: [],
			symbol: "No",
			atomicNumber: 102,
			mass: 259,
			series: .actinoid,
			electronegativity: 1.3
		),
		Self(
			name: "Lawrencium",
			alternateNames: [],
			symbol: "Lr",
			atomicNumber: 103,
			mass: 266,
			series: .actinoid,
			electronegativity: 1.3
		),
		Self(
			name: "Rutherfordium",
			alternateNames: [],
			symbol: "Rf",
			atomicNumber: 104,
			mass: 267,
			series: .transitionMetal,
			electronegativity: nil
		),
		Self(
			name: "Dubnium",
			alternateNames: [],
			symbol: "Db",
			atomicNumber: 105,
			mass: 268,
			series: .transitionMetal,
			electronegativity: nil
		),
		Self(
			name: "Seaborgium",
			alternateNames: [],
			symbol: "Sg",
			atomicNumber: 106,
			mass: 269,
			series: .transitionMetal,
			electronegativity: nil
		),
		Self(
			name: "Bohrium",
			alternateNames: [],
			symbol: "Bh",
			atomicNumber: 107,
			mass: 270,
			series: .transitionMetal,
			electronegativity: nil
		),
		Self(
			name: "Hassium",
			alternateNames: [],
			symbol: "Hs",
			atomicNumber: 108,
			mass: 269,
			series: .transitionMetal,
			electronegativity: nil
		),
		Self(
			name: "Meitnerium",
			alternateNames: [],
			symbol: "Mt",
			atomicNumber: 109,
			mass: 278,
			series: nil,
			electronegativity: nil
		),
		Self(
			name: "Darmstadtium",
			alternateNames: [],
			symbol: "Ds",
			atomicNumber: 110,
			mass: 281,
			series: nil,
			electronegativity: nil
		),
		Self(
			name: "Roentgenium",
			alternateNames: [],
			symbol: "Rg",
			atomicNumber: 111,
			mass: 282,
			series: nil,
			electronegativity: nil
		),
		Self(
			name: "Copernicium",
			alternateNames: [],
			symbol: "Cn",
			atomicNumber: 112,
			mass: 285,
			series: .transitionMetal,
			electronegativity: nil
		),
		Self(
			name: "Nihonium",
			alternateNames: [],
			symbol: "Nh",
			atomicNumber: 113,
			mass: 286,
			series: nil,
			electronegativity: nil
		),
		Self(
			name: "Flerovium",
			alternateNames: [],
			symbol: "Fl",
			atomicNumber: 114,
			mass: 289,
			series: .postTransitionMetal,
			electronegativity: nil
		),
		Self(
			name: "Moscovium",
			alternateNames: [],
			symbol: "Mc",
			atomicNumber: 115,
			mass: 289,
			series: nil,
			electronegativity: nil
		),
		Self(
			name: "Livermorium",
			alternateNames: [],
			symbol: "Lv",
			atomicNumber: 116,
			mass: 293,
			series: nil,
			electronegativity: nil
		),
		Self(
			name: "Tennessine",
			alternateNames: [],
			symbol: "Ts",
			atomicNumber: 117,
			mass: 294,
			series: nil,
			electronegativity: nil
		),
		Self(
			name: "Oganesson",
			alternateNames: [],
			symbol: "Og",
			atomicNumber: 118,
			mass: 294,
			series: nil,
			electronegativity: nil
		),
		Self(
			name: "Ununennium",
			alternateNames: [],
			symbol: "Uue",
			atomicNumber: 119,
			mass: 315,
			series: nil,
			electronegativity: nil
		)
	]
}
