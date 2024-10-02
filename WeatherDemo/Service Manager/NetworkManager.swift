//
//  WebServiceManager.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 25/09/24.
//

import Foundation
import RxSwift

struct WeatherError: Decodable {
    let cod: String
    let message: String
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(from url: String) -> Observable<T> {
        guard let url = URL(string: url) else {
            return Observable.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }

        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(NSError(domain: "Invalid response", code: -1, userInfo: nil))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    if let data = data {
                        do {
                            let decodedData = try JSONDecoder().decode(WeatherError.self, from: data)
                            let error = NSError(domain: decodedData.message, code: httpResponse.statusCode)
                            observer.onError(error)
                        } catch {
                            let error = NSError(domain: "HTTP error", code: httpResponse.statusCode, userInfo: nil)
                            observer.onError(error)
                        }
                    } else {
                        let error = NSError(domain: "HTTP error", code: httpResponse.statusCode, userInfo: nil)
                        observer.onError(error)
                    }
                    return
                }
                
                guard let data = data else {
                    observer.onError(NSError(domain: "No data", code: -1, userInfo: nil))
                    return
                }

                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decodedData)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
