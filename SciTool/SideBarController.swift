//
//  GestureConfigSidebarController.swift
//  ReceiverMac
//
//  Created by Marc D. Nichitiu on 12/11/21.
//  Copyright © 2021 MultiTouchFX. All rights reserved.
//

import Foundation
import Cocoa
class SideBarController: NSViewController {
	public static var isInit = false
	
    @IBOutlet weak var tableView: NSTableView!
    
	
	@IBAction func OpenGithub(_ sender: Any) {
		let url = URL(string: "https://github.com/mdnich/scitool")!
		if NSWorkspace.shared.open(url) {
			print("Browser Successfully opened")
		}
	}
	
	
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        print("Config Initialized")
		initTable()
    }
	
	func initTable()
	{
		print("init")
		var indset = IndexSet(integer: 1)
		tableView.selectRowIndexes(indset, byExtendingSelection: false)
        SideBarController.isInit = true
	}
	func update()
	{
		print("init")
		var selectedItem = tableView.selectedRowIndexes.first
		print(selectedItem)
		//var tabBarController = GestureConfigTabCtrl()
		//tabBarController.setTabNumber(tabIndex: selectedItem ?? 0)
        MasterViewController.TabViewS.selectTabViewItem(at: (selectedItem ?? 0 )-1 )
		
	}
    
}
extension SideBarController: NSTableViewDataSource {
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return 4
  }

}
extension SideBarController: NSTableViewDelegate {

  fileprivate enum CellIdentifiers {
    static let Header = "Header"
    static let EquipotentialLines = "EquipotLines"
    static let Placeholder1 = "Placeholder1"
	static let Placeholder2 = "Placeholder2"
	  static let GithubButton = "GithubButton"
  }
	func tableView(_ tableView: NSTableView, didSelectRowAt indexPath: IndexPath) {
		//var tabBarController = GestureConfigTabCtrl()
		print("init")
		print("item: \(tableView.selectedRow)")
        update()
		//tabBarController.selectedTabViewItemIndex = tableView.selectedRow
		//print(tabBarController.selectedTabViewItemIndex)

		//GestureConfigTabCtrl.setTabNumber(tabIndex: indexPath.item)
   }
	/*func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
		var tabBarController = GestureConfigTabCtrl()
		print("init")
		print("item: \(tableView.selectedRow)")
		tabBarController.selectedTabViewItemIndex = tableView.selectedRow
		print(tabBarController.selectedTabViewItemIndex)

		//GestureConfigTabCtrl.setTabNumber(tabIndex: indexPath.item)
   }*/
	
	func tableViewSelectionDidChange(_ notification: Notification) {
        if(SideBarController.isInit) {
			update()
		}
	}
	

	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		if(row == 0) {return false}
		else {
            return true
            
        }
	}

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

	  let text0: String = "Simulations"
	  let text1: String = "Equipotential Lines"
      let text2: String = "Nothing"
	  let text3: String = "Nothing2"
      var cellIdentifier: String = ""


    // 2
	  if tableColumn == tableView.tableColumns[0] {
		if row == 0 {
			cellIdentifier = CellIdentifiers.Header
		}
        else if row == 1 {
            cellIdentifier = CellIdentifiers.EquipotentialLines
        }
        else if row == 2 {
            cellIdentifier = CellIdentifiers.Placeholder1
        }
		else if row == 3 {
			  cellIdentifier = CellIdentifiers.Placeholder2
		}
		  /*else if row == 5 {
			  cellIdentifier = CellIdentifiers.GithubButton
		  }*/
	  }

    // 3
	  if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
		if(cellIdentifier == CellIdentifiers.Header) {
			  cell.textField?.stringValue = text0
		}
		if(cellIdentifier == CellIdentifiers.EquipotentialLines) {
			cell.textField?.stringValue = text1
			
		}
		if(cellIdentifier == CellIdentifiers.Placeholder1) {
			cell.textField?.stringValue = text2
		}
		  if(cellIdentifier == CellIdentifiers.Placeholder2) {
			  cell.textField?.stringValue = text3
		  }
		 /* if(cellIdentifier == CellIdentifiers.GithubButton) {
			  cell.imageView?.image = NSImage(named: "Github")
		  }*/
		  //cell.backgroundStyle = NSView.BackgroundStyle.
		return cell
	  }
	  return nil
	}
	
    
    
	//func tableView(_ tableView: NSTableView, d)
    
    

}

