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

class ActiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!   // table view
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!   // indikator za učitavanje (loader) može biti prikazan ili sakriven (prikazuje se dok se učitavaju podaci, a sakriva kada se prikažu podaci)
    
    var aktivneStavke = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // getActiveItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getActiveItems()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aktivneStavke.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celija = tableView.dequeueReusableCell(withIdentifier: "activeCell") as! ActiveCell
        
        // popunjavanje podataka
        
        let podaci = aktivneStavke[indexPath.row]
        
        celija.lblTitle.text = podaci.title
        celija.lblContent.text = podaci.content
        
        let prioritet = podaci.priority
        
        if prioritet == 1 {
            celija.backgroundViewOfItem.layer.borderColor = UIColor.yellow.cgColor
        } else if prioritet == 2 {
            celija.backgroundViewOfItem.layer.borderColor = UIColor.orange.cgColor
        } else {
            celija.backgroundViewOfItem.layer.borderColor = UIColor.red.cgColor
        }
        
        celija.backgroundViewOfItem.layer.borderWidth = 2
        celija.backgroundViewOfItem.layer.cornerRadius = 10
        
        celija.accessoryType = .disclosureIndicator
        
        var dateFormatter = DateFormatter()
        // pravljenje tipa Date od Stringa
        dateFormatter.dateFormat = "YYYY-MM-dd"                   // dd  MMM     YYYY
        let date = dateFormatter.date(from: podaci.date)! // Date - dan, mesec i godinu
        
        dateFormatter.dateFormat = "YYYY"
        let godina = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "MMM"
        let mesec = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "dd"
        let dan = dateFormatter.string(from: date)
        
        celija.lblDay.text = dan
        celija.lblMonth.text = mesec
        celija.lblYear.text = godina
        
        
        return celija
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            ToDoRequests.deleteItem(id: aktivneStavke[indexPath.row].id!) { rezultat in
                print(rezultat)
                self.aktivneStavke.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let akcija = UIContextualAction(style: .normal, title: "Complete") { action, _, _ in
            print("COMPLETE")
            ToDoRequests.completeItem(id: self.aktivneStavke[indexPath.row].id!) { rezultat in
                print(rezultat)
                
                self.getActiveItems()
                
            }
            
        }

        akcija.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [akcija])
        
    }
    
    func getActiveItems() {
        
        ToDoRequests.getAllItems { rezulatati in
            
            let results = rezulatati["results"] as? [[String:Any]]
            if let results = results {
                
                self.aktivneStavke.removeAll()
                
                for res in results {
                    print(res)

                    let stavka = ToDoItem(id: res["id"] as! Int, title: res["title"] as! String, content: res["content"] as! String, isCompleted: res["isCompleted"] as! Int, priority: res["priority"] as! Int, date: res["date"] as! String)
                    
                    if stavka.isCompleted == 0 {
                        
                        self.aktivneStavke.append(stavka)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backToActive(_ unwindSegue: UIStoryboardSegue) {
        
    }
    

}

