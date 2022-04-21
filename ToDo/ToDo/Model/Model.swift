//
//  Model.swift
//  ToDo
//
//  Created by Aleksandra Lazarevic on 31.3.22..
//

import Foundation

// Nacrt stavke

struct ToDoItem {
    var id: Int?           // jedinstveni identifikator stavke - id
    var title: String      // naslov
    var content: String    // sadrzaj
    var isCompleted: Int   // da li je kompletirana? (0 - nekompletirana, 1 - kompletirana)
    var priority: Int      // prioritet (1 - nizak, 2 - srednji, 3 - visok)
    var date: String       // datum
    
    static var dummyData: [ToDoItem] {
        return [
            ToDoItem(title: "Homework", content: "Do the homework...", isCompleted: 0, priority: 2, date: "2022-3-30"),
            ToDoItem(title: "Bake a cake", content: "Bake a cake for birthday", isCompleted: 0, priority: 3, date: "2022-3-31"),
            ToDoItem(title: "Gym", content: "Go to the gym", isCompleted: 0, priority: 2, date: "2022-4-1"),
            ToDoItem(title: "Course", content: "Start learning a new programming language", isCompleted: 1, priority: 3, date: "2022-3-20")
        ]
    }
}
