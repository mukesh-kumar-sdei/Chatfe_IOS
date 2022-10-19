//
//  HttpUtility.swift
//  Chatfe
//
//  Created by Piyush Mohan on 04/04/22.
//

import Foundation

struct HttpUtility {
    func getApiData<T: Decodable>(requestUrl: URL, resultType: T.Type, completionHandler: @escaping(_ result: T) -> Void) {
        URLSession.shared.dataTask(with: requestUrl) { responseData, httpUrlResponse, error in
            if (error == nil && responseData != nil && responseData?.count != 0) {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData!)
                    _ = completionHandler(result)
                } catch let error {
                    debugPrint("Error occurred while decoding \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func postApiData<T: Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler: @escaping(_ result: T) -> Void) {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        URLSession.shared.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            if (data != nil && data?.count != 0) {
                do {
                    let jsonResponse = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
                    debugPrint("JSON RESPONSE IS ===========", jsonResponse ?? "")
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    _ = completionHandler(response)
                } catch let decodingError {
                    debugPrint(decodingError)
                }
            }
        }.resume()
    }
    
    func postApiDecodedData<T: Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler: @escaping(_ result: T) -> Void) {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        URLSession.shared.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            if (data != nil && data?.count != 0) {
                do {
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = PersistentStorage.shared.context
                    let response = try decoder.decode(T.self, from: data!)
                    _ = completionHandler(response)
                } catch let decodingError {
                    debugPrint(decodingError)
                }
            }
        }.resume()
    }
}
