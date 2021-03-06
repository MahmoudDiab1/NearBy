//
//  NetworkEngine.swift
//  NearBy
//
//  Created by mahmoud diab on 7/7/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

//MARK:- Responsbility : Responsible for fetching data from any resource and decode it.It takes parameter of type End point to build the url request customized for a spesific resource -

class NetworkEngine {
    
    //MARK:-  Generic get Request
    class func fetchData< ResponseType:Decodable>(serviceEndPoint:Endpoint, completion : @escaping(Result<ResponseType?,ErrorHandler>) -> Void) {
        
        // Construct url request
        var components = URLComponents()
        components.scheme = serviceEndPoint.scheme
        components.host = serviceEndPoint.base
        components.path = serviceEndPoint.path
        components.queryItems = serviceEndPoint.parameter
        guard let urlString = components.url  else {return}
        var urlRequest = URLRequest(url: urlString)
        urlRequest.httpMethod = serviceEndPoint.method
        // print(urlString)
        
        // Data task (GET)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let recievedError = error as NSError? {
                
                //offline(Network disconnected)
                guard  recievedError.code != -1009 else { completion(.failure(.offline));return}
            }// requestFailed
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            } // responseUnsuccessful
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 2999 else {
                completion(.failure(.responseUnsuccessful))
                return
            }
            // invalidData
            guard let dataResponse = data else {
                completion(.failure(.invalidData))
                return
            }
            
            // Decode
            do {
                let dataObject = try JSONDecoder().decode(ResponseType.self, from: dataResponse)
                DispatchQueue.main.async {
                    completion(.success(dataObject))
                }
            } catch {
                let error = try? JSONDecoder().decode(APIErrorModel.self, from: dataResponse)
                DispatchQueue.main.async {
                    if error?.errorType != nil  {
                        guard let errorModelResult = error else { return }
                        completion(.failure(.APIError(error: errorModelResult)))
                    } else {
                        completion( .failure(.jsonConversionFail) )
                    }
                }
            }
        }
        task.resume()
    }
    
    
    //Function to test if enternet existed or not.
    class  func isConnected(completion:@escaping(Bool)->()) {
        let url = URL(string:"https://www.google.com/") 
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            if let error  = error as NSError? {
                if error.code == -1009 { completion(false) } else { completion(true) }
            } else { completion(true) }
        }
        task.resume()
    }
}
