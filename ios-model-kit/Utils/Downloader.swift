//
//  Downloader.swift
//  ios-model-kit
//
//  Created by Karina Zubko on 02.05.2023.
//

import Foundation

class Downloader {
    class func load(url: URL, completion: @escaping (Data?) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            if (error == nil) {
                print("Success, \(data?.count ?? 0)")
                completion(data)
            }
            else {
                print(error?.localizedDescription ?? "download error nil")
                completion(nil)
            }
        }
        task.resume()
    }
}
