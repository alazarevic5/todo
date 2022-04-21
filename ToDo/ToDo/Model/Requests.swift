//
//  Requests.swift
//  ToDo
//
//  Created by Aleksandra Lazarevic on 2.4.22..
//

import Foundation

class ItemsRequests {
    
    static let baseUrl = "http://xcode.rs:8000/"
    static let postEndPoint = "addnew/"
    static let deleteEndPoint = "remove/"
    static let completeEndPoint = "completed/"
    
    static func createURLForItems (uuid: String) -> URL? {
        let url = URL(string: self.baseUrl + "all/" + uuid)
        return url
    }
    
    static func getAllItems (url: URL, hendler: @escaping ([String:Any]) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let jsonPodaci = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    hendler(jsonPodaci)
                }
            }
        }
        task.resume()
    }
    
    static func sendItemToServer (uuid: String, newItem: ToDoItem, result: @escaping ([String:Any])->Void) {
         
            let url = URL(string: self.baseUrl + postEndPoint)!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
                "title": newItem.title,
                "content": newItem.content,
                "priority":newItem.priority,
                "isCompleted": newItem.isCompleted,
                "date":newItem.date,
                "uuid": uuid
            ]
            let bodyData = try? JSONSerialization.data(
                withJSONObject: parameters,
                options: []
            )

            // Change the URLRequest to a POST request - default is GET
            request.httpMethod = "POST"
            request.httpBody = bodyData!


            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {   // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
                }
                print(response.description)
                print(response.statusCode)
                
                 let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                 if let jsonData = jsonData {
                     result(jsonData)
                 }
            }

            task.resume()
            
        }
    
    static func deleteItem(id: Int) {
        let url = URL(string: baseUrl + deleteEndPoint + "\(id)")!
        var req = URLRequest(url: url)
        req.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            if let data = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(jsonData)
                }
            }
        }
        task.resume()
    }
    
    static func completeItem(id: Int, result: @escaping ([String:Any])->Void) {
        let url = URL(string: baseUrl + completeEndPoint + "\(id)")!
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            if let data = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    result(jsonData)
                }
            }
        }
        task.resume()
    }
}

