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
        getActiveItems()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aktivneStavke.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celija = tableView.dequeueReusableCell(withIdentifier: "activeCell") as! ActiveCell
        
        // popunjavanje podataka
        
        return celija
    }

    func getActiveItems() {
        
        ToDoRequests.getAllItems { rezultati in
            
            let results = rezultati["results"] as? [[String : Any]]
            
            if let results = results {
                for res in results{
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
}

