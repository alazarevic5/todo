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

class ActiveViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!   // table view
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!   // indikator za učitavanje (loader) može biti prikazan ili sakriven (prikazuje se dok se učitavaju podaci, a sakriva kada se prikažu podaci)
    

    var activeItems = [ToDoItem]()
    
     var uuid = UIDevice.current.identifierForVendor!.uuidString
    // var uuid = "12345"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // getActiveItems(items: ToDoItem.dummyData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getActiveItemsFromServer()
    }

    func getActiveItems(items: [ToDoItem]) {
        for item in items {
            if item.isCompleted == 0 {
                activeItems.append(item)
            }
        }
        activityIndicator.stopAnimating()
    }
    
    func getActiveItemsFromServer() {
        activityIndicator.startAnimating()
        let url = ItemsRequests.createURLForItems(uuid: self.uuid)!
        ItemsRequests.getAllItems(url: url) { [self] podaci in
            activeItems.removeAll()
            let rezultati = podaci["results"] as! [[String:Any]]
            
            for rezultat in rezultati {
                
                let stavka = ToDoItem(id: rezultat["id"] as! Int, title: rezultat["title"] as! String, content: rezultat["content"] as! String, isCompleted: rezultat["isCompleted"] as! Int, priority: rezultat["priority"] as! Int, date: rezultat["date"] as! String)
                if stavka.isCompleted == 0 {
                    activeItems.append(stavka)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        activityIndicator.stopAnimating()
                    }
                }
            }
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeCell", for: indexPath) as! ActiveCell
        
        cell.accessoryType = .disclosureIndicator
        
        let rowData = activeItems[indexPath.row]
        
        cell.lblTitle.text = rowData.title
        cell.lblContent.text = rowData.content
        
        let datum = rowData.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let datumDate = dateFormatter.date(from: datum)
        
        dateFormatter.dateFormat = "MMM"
        let month = dateFormatter.string(from: datumDate!)
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: datumDate!)
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: datumDate!)
        
        cell.lblDay.text = day
        cell.lblMonth.text = month
        cell.lblYear.text = year
        
        cell.backgroundViewOfItem.layer.borderWidth = 2
        cell.backgroundViewOfItem.layer.cornerRadius = 10
        switch rowData.priority {
        case 1:
            cell.backgroundViewOfItem.layer.borderColor = UIColor.yellow.cgColor
        case 2:
            cell.backgroundViewOfItem.layer.borderColor = UIColor.orange.cgColor
        case 3:
            cell.backgroundViewOfItem.layer.borderColor = UIColor.red.cgColor
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let stavkaZaBrisanje = activeItems[indexPath.row]
        
        ItemsRequests.deleteItem(id: stavkaZaBrisanje.id!)
        
        activeItems.remove(at: indexPath.row)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: "Complete") { action, _, _ in
            ItemsRequests.completeItem(id: self.activeItems[indexPath.row].id!) { rezultati in
                if (rezultati["message"] as? String) != nil {
                    self.activeItems.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                        
                        let alert = UIAlertController(title: "Note completed successfully", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    
                }
            }
            print("Tap")
        }
        completeAction.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    var odabrano: ToDoItem?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activeDetails" {
            let destinacija = segue.destination as! DetailsViewController
            destinacija.odabranaStavka = odabrano!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        odabrano = activeItems[indexPath.row]
        performSegue(withIdentifier: "activeDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func unwindToActive(_ unwindSegue: UIStoryboardSegue) {
        getActiveItemsFromServer()
    }
}

