//
//  Requests.swift
//  ToDo
//
//  Created by Gupa 1 on 6.4.22..
//

import Foundation
import UIKit

class ToDoRequests {
    
    static var baseURL: String = "http://www.xcode.rs:8000/"
    
    static var uuid: String = UIDevice.current.identifierForVendor!.uuidString //"12345"
    
    static func getAllItems(rezultati: @escaping ([String:Any]) -> Void) {
        
        // pravljenje URL-a
        let url = URL(string: baseURL + "all/" + uuid)!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    rezultati(jsonData)
                }
            }
            
        }
        task.resume()
    }
    
    static func addNewItem(newItem: ToDoItem, rezultati: @escaping ([String:Any]) -> Void) {
        
        let url = URL(string: baseURL + "addnew")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let parametri = [
            "title":newItem.title,
            "content":newItem.content,
            "date":newItem.date,
            "isCompleted":newItem.isCompleted,
            "priority":newItem.priority,
            "uuid":self.uuid
        ] as [String:Any]
        
        let jsonPodaci = try? JSONSerialization.data(withJSONObject: parametri, options: [])
        
        request.httpBody = jsonPodaci!
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let response = response {
                print(response.description)
            }
            
            if let data = data {
                let podaci = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                
                if let podaci = podaci {
                    rezultati(podaci)
                }
            }
            
        }
        task.resume()
        
    }
    
    static func deleteItem(id: Int , result: @escaping ([String:Any]) -> Void) {
        
        let url = URL(string: baseURL + "remove/" + "\(id)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let jsonPodaci = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    result(jsonPodaci)
                }
            }
            
        }
        task.resume()
    }
    
    static func completeItem (id: Int, result: @escaping ([String:Any]) -> Void) {
        let url = URL(string: baseURL + "completed/" + "\(id)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let response = response {
                print(response.description)
            }
            
            if let data = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    result(jsonData)
                }
            }
            
        }
        task.resume()
    }
    
}
