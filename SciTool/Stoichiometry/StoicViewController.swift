//
//  StoicViewController.swift
//  SciTool
//
//  Created by Marc Nich on 6/26/22.
//

import Foundation
import AppKit


class StoicViewController: NSViewController {
    
    var reactor: ReactCommand = ReactCommand()
    @IBOutlet weak var whatIsKnown: NSPopUpButton!
    @IBOutlet weak var equationField: NSTextField!
    @IBOutlet weak var verboseOutput: NSButton!

    @IBOutlet weak var amountsField: NSTextField!
    @IBOutlet weak var outputView: NSScrollView!
    
    @IBOutlet var outputTextView: NSTextView!
    @IBOutlet weak var errorLabel: NSTextField!
    
    
    @IBAction func react(sender: Any?) {
        print("reacting")
        errorLabel.isHidden = true
        do {
            if(verifyInputs()) {
                var quantities = amountsField.stringValue.components(separatedBy: ",")
                var list: [ReactCommand.Known] = []
                list.reserveCapacity(quantities.count)
                for i in 0...(quantities.count-1) {
                    print(quantities[i])
                    quantities[i].removeAll(where: isSpace)
                    list.append(try ReactCommand.Known.init(argument: quantities[i])!)
                }
                if(whatIsKnown.indexOfSelectedItem == 1) {
                    // Products
                    outputTextView.string = reactor.run(equation: equationField.stringValue, reactants: [], products: list)
                }
                else {
                    // Reactants
                    outputTextView.string = reactor.run(equation: equationField.stringValue, reactants: list, products: [])
                }
            }
            else {
                
            }
        }
        catch {
            errorLabel.isHidden = false
        }
    }
    
    func isSpace(_ spaceQ: String.Element) -> Bool {
        return spaceQ == " "
    }
    
    func verifyInputs() -> Bool {
        if(equationField.stringValue == "") {
            return false
        }
        if(amountsField.stringValue=="") {
            return false
        }
        return true
    }
    
    override func viewDidLoad()
    {
        
    }
}
