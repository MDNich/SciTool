//
//  StoicMassViewController.swift
//  SciTool
//
//  Created by Marc Nich on 6/28/22.
//

import Foundation
import AppKit

class StoicMassViewController: NSViewController {
    @IBOutlet weak var compoundInput: NSTextField!
    @IBOutlet weak var amountInput: NSTextField!
    @IBOutlet weak var knownUnits: NSPopUpButton!
    @IBOutlet weak var resultField: NSTextField!
    @IBOutlet weak var errorFlash: NSTextField!

    @IBAction func solve(sender: Any?) {
        errorFlash.isHidden = true
        resultField.stringValue = ""
        do {
            try verifyInputs()
            if(knownUnits.indexOfSelectedItem == 1) {
                var tmp = try MassCommand().run(compound: compoundInput.stringValue, moles: Double(amountInput.stringValue), grams: nil)
                if(tmp == "ERROR") {
                    errorFlash.isHidden = false
                    resultField.stringValue = ""
                }
                else {
                    resultField.stringValue = tmp
                }
            }
            else {
                var tmp = try MassCommand().run(compound: compoundInput.stringValue, moles: nil, grams: Double(amountInput.stringValue))
                if(tmp == "ERROR") {
                    errorFlash.isHidden = false
                    resultField.stringValue = ""
                }
                else {
                    resultField.stringValue = tmp
                }
            }
        }
        catch {
            errorFlash.isHidden = false
            resultField.stringValue = ""
        }
    }
    
    func verifyInputs() throws {
        if(compoundInput.stringValue == "") {throw MassSolverError.InvalidInputError}
        if(amountInput.stringValue == "") {throw MassSolverError.InvalidInputError}
    }
    
    enum MassSolverError: Error {
        case InvalidInputError
    }
}
