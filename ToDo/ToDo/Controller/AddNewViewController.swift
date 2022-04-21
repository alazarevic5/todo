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

        // Do any additional setup after loading the view.
        swLow.isOn = true
        swMedium.isOn = false
        swHigh.isOn = false
        
        hideKeyboardWhenTappedAround()
    }
    
    func createAndSendItem() {
        var priority = 1
        
        guard tfTitle.text != "" && tvContent.text != "" else {
            return
        }
        
        if swLow.isOn {
            priority = 1
        } else if swMedium.isOn {
            priority = 2
        }
        else {
            priority = 3
        }
        
    //  formatiranje datuma
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let datum = dateFormatter.string(from: dpDate.date)
    
        let uuid = UIDevice.current.identifierForVendor!.uuidString
    
        var newToDoItem = ToDoItem(id: nil, title: tfTitle.text!, content: tvContent.text!, isCompleted: 0, priority: priority, date: datum)
        
        ItemsRequests.sendItemToServer(uuid: uuid, newItem: newToDoItem) { result in
            let newId = result["id"] as! Int
            newToDoItem.id = newId
            print(newToDoItem)
        }
        performSegue(withIdentifier: "povratak", sender: self)
    }
    @IBAction func btnDoneTapped(_ sender: Any) {
        createAndSendItem()
        
    }
    
    func hideKeyboardWhenTappedAround() {
            let tapGesture = UITapGestureRecognizer(target: self,
                             action: #selector(hideKeyboard))
            view.addGestureRecognizer(tapGesture)
        }

        @objc func hideKeyboard() {
            view.endEditing(true)
        }
    
    
    @IBAction func swLowValueChanged(_ sender: Any) {
        if swLow.isOn {
            swMedium.isOn = false
            swHigh.isOn = false
        } else if swLow.isOn == false {
            swMedium.isOn = true
            swHigh.isOn = false
        }
    }
    
    @IBAction func swMediumValueChanged(_ sender: Any) {
        
        if swMedium.isOn {
            swLow.isOn = false
            swHigh.isOn = false
        } else if swMedium.isOn == false {
            swLow.isOn = false
            swHigh.isOn = true
        }
        
    }
    @IBAction func swHighValueChanged(_ sender: Any) {
        if swHigh.isOn {
            swLow.isOn = false
            swMedium.isOn = false
        } else if swHigh.isOn == false {
            swLow.isOn = true
            swMedium.isOn = false
        }
    }
}
