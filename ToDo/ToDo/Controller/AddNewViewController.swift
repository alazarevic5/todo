//
//  AddNewViewController.swift
//  ToDo
//
//  Created by Aleksandra Lazarevic on 31.3.22..
//

import UIKit

class AddNewViewController: UIViewController {
    
    @IBOutlet weak var tfTitle: UITextField!   // text field za naslov
    @IBOutlet weak var tvContent: UITextView!  // text field za sadrzaj
    
    @IBOutlet weak var swLow: UISwitch!        // switch za nizak prioritet
    @IBOutlet weak var swMedium: UISwitch!     // switch za srednji prioritet
    @IBOutlet weak var swHigh: UISwitch!       // switch za visok prioritet
    
    @IBOutlet weak var dpDate: UIDatePicker!   // date picker za odabir datuma
    
    @IBOutlet weak var btnDone: UIBarButtonItem!   // taster done za potvrdu
    
    override func viewDidLoad() {
        super.viewDidLoad()

        swLow.isOn = true
        swMedium.isOn = false
        swHigh.isOn = false
        
    }
    
    
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        
        guard tfTitle.text! != "" && tvContent.text! != "" else {
            return
        }
        
        var priority = 1
        
        if swLow.isOn {
            priority = 1
        } else if swMedium.isOn {
            priority = 2
        } else if swHigh.isOn {
            priority = 3
        }
        
        let datum = dpDate.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let datumStr = dateFormatter.string(from: datum)
        
        var newItem = ToDoItem(id: nil, title: tfTitle.text!, content: tvContent.text!, isCompleted: 0, priority: priority, date: datumStr)
        
        ToDoRequests.addNewItem(newItem: newItem) { rezultat in
            
            print(rezultat)
            
            let dobijeniId = rezultat["id"] as! Int
            newItem.id = dobijeniId
            
        }
        
        performSegue(withIdentifier: "backToActive", sender: self)
    }
    
}
