//
//  DetailsViewController.swift
//  ToDo
//
//  Created by Aleksandra Lazarevic on 31.3.22..
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    
    @IBOutlet weak var vwPriorityColor: UIView!
    @IBOutlet weak var lblPriorityName: UILabel!
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    
    var odabranaStavka: ToDoItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvContent.isEditable = false
        
        if let odabranaStavka = odabranaStavka {
            fillData(item: odabranaStavka)
        }
        
    }
    
    func fillData(item: ToDoItem) {
        self.lblTitle.text = item.title
        self.tvContent.text = item.content
        
        let dateString = item.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "MMM"
        self.lblMonth.text = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "dd"
        self.lblDay.text = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "YYYY"
        self.lblYear.text = dateFormatter.string(from: date!)
        
        switch item.priority {
        case 1:
            self.vwPriorityColor.backgroundColor = .systemYellow
            self.headerView.backgroundColor = .systemYellow
            self.lblPriorityName.text = "Low priority"
        case 2:
            self.vwPriorityColor.backgroundColor = .systemOrange
            self.headerView.backgroundColor = .systemOrange
            self.lblPriorityName.text = "Medium priority"
        case 3:
            self.vwPriorityColor.backgroundColor = .systemRed
            self.headerView.backgroundColor = .systemRed
            self.lblPriorityName.text = "High priority"
        default:
            break
        }
    }

}
