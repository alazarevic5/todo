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
    
    static var uuid: String = "123456"
    
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
    
}
