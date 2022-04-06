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
    }
    
}
