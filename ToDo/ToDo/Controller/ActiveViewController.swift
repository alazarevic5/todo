//
//  ViewController.swift
//  ToDo
//
//  Created by Aleksandra Lazarevic on 31.3.22..
//

import UIKit

class ActiveCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!     //naslov
    @IBOutlet weak var lblContent: UILabel!  // sadržaj
    
    @IBOutlet weak var lblDay: UILabel!      // dan
    @IBOutlet weak var lblMonth: UILabel!   // mesec
    @IBOutlet weak var lblYear: UILabel!    // godina
    
    @IBOutlet weak var backgroundViewOfItem: UIView! // Ovaj view dodat je iza svih ovih kontrola kako bi mogao da se napravi efekat okvira oko kontrola unutar ćelije
}

class ActiveViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!   // table view
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!   // indikator za učitavanje (loader) može biti prikazan ili sakriven (prikazuje se dok se učitavaju podaci, a sakriva kada se prikažu podaci)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    

}

