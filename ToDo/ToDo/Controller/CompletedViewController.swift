//
//  CompletedViewController.swift
//  ToDo
//
//  Created by Aleksandra Lazarevic on 31.3.22..
//

import UIKit

class CompletedCell: UITableViewCell {
    
    @IBOutlet weak var vwBorder: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblYear: UILabel!
}

class CompletedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var completedItems = [ToDoItem]()
    
     var uuid = UIDevice.current.identifierForVendor!.uuidString
    // var uuid = "12345"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // getActiveItems(items: ToDoItem.dummyData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCompletedItemsFromServer()
    }

    
    func getCompletedItemsFromServer() {
        activityIndicator.startAnimating()
        let url = ItemsRequests.createURLForItems(uuid: self.uuid)!
        ItemsRequests.getAllItems(url: url) { [self] podaci in
            completedItems.removeAll()
            let rezultati = podaci["results"] as! [[String:Any]]
            
            for rezultat in rezultati {
                
                let stavka = ToDoItem(id: rezultat["id"] as! Int, title: rezultat["title"] as! String, content: rezultat["content"] as! String, isCompleted: rezultat["isCompleted"] as! Int, priority: rezultat["priority"] as! Int, date: rezultat["date"] as! String)
                if stavka.isCompleted == 1 {
                    completedItems.append(stavka)
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
        return completedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "completedCell", for: indexPath) as! CompletedCell
        
        cell.accessoryType = .disclosureIndicator
        
        let rowData = completedItems[indexPath.row]
        
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
        
        cell.vwBorder.layer.borderWidth = 2
        cell.vwBorder.layer.cornerRadius = 10
        switch rowData.priority {
        case 1:
            cell.vwBorder.layer.borderColor = UIColor.yellow.cgColor
        case 2:
            cell.vwBorder.layer.borderColor = UIColor.orange.cgColor
        case 3:
            cell.vwBorder.layer.borderColor = UIColor.red.cgColor
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let stavkaZaBrisanje = completedItems[indexPath.row]
        
        ItemsRequests.deleteItem(id: stavkaZaBrisanje.id!)
        
        completedItems.remove(at: indexPath.row)
        tableView.reloadData()
    }
    var odabrano: ToDoItem?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "completedDetails" {
            let destinacija = segue.destination as! DetailsViewController
            destinacija.odabranaStavka = odabrano!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        odabrano = completedItems[indexPath.row]
        performSegue(withIdentifier: "completedDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
