//
//  NetworkEngine.swift
//  NearBy
//
//  Created by mahmoud diab on 7/7/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

//MARK:- Responsbility : Responsible for fetching data from any resource and decode it .It takes parameter of type End point to build the url request customized for a spesific resource. -

class NetworkEngine {
    
    //MARK:-  Generic get Request
    class func fetchData< ResponseType:Decodable>(serviceEndPoint:Endpoint, completion : @escaping(Result<ResponseType?,Error>) -> Void) {
        var components = URLComponents()
        components.scheme = serviceEndPoint.scheme
        components.host = serviceEndPoint.base
        components.path = serviceEndPoint.path
        components.queryItems = serviceEndPoint.parameter
        guard let urlString = components.url  else {return}
        var urlRequest = URLRequest(url: urlString)
        urlRequest.httpMethod = serviceEndPoint.method
        print(urlString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(error!))  }
                return
            } 
            do {
                let dataObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataObject))
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
