//
//  FeaturedManager.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 20/02/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

class Network {
    
    func fetch(url: URL, method: HTTPMethod = .get) -> Observable<Data> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return Observable.create { observer in
            var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            request.httpMethod = method.rawValue
            
            let network = Alamofire.request(request).validate(statusCode: 200..<300).responseData { response in
                switch response.result {
                case .failure:
                    observer.onError(response.error!)
                case .success:
                    let cachedResponse = CachedURLResponse(response: response.response!, data: response.data! as Data, userInfo: nil, storagePolicy: .allowed)
                    URLCache.shared.storeCachedResponse(cachedResponse, for: response.request!)
                    
                    observer.onNext(cachedResponse.data)
                    observer.onCompleted()
                }
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            return Disposables.create {
                network.cancel()
            }
        }.observeOn(MainScheduler.instance)
    }
    
    func downloadImage(url: URL) -> Observable<Data> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return Observable.create { observer in
            var network: DataRequest?
            
            if Cache.instance.has(key: url.absoluteString) {
                observer.onNext(Cache.instance.get(key: url.absoluteString)!)
                observer.onCompleted()
            }
            else {
                network = Alamofire.request(url).responseData { response in
                    switch response.result {
                    case .failure:
                        observer.onError(response.error!)
                    case .success:
                        if let data = response.result.value {
                            Cache.instance.put(key: url.absoluteString, data: data)
                            observer.onNext(data)
                            observer.onCompleted()
                        }
                        else {
                            observer.onError(NetworkError.invalidResponse)
                        }
                    }
                }
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            return Disposables.create {
                if let network = network {
                    network.cancel()
                }
            }
        }.observeOn(MainScheduler.instance)
    }
    
}
