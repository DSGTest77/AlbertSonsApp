//
//  AcronymViewModel.swift
//  AlbertsonsApp
//
//  Created by Yashwanth Adirala on 5/23/22.
//

import Foundation

class AcronymViewModel {
    
    var result: Acronym? = nil
    var network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func searchAcronym(acronym: String, completionHandler: @escaping(Error?) -> Void) {

        guard !acronym.isEmpty else {
            self.result = nil
            return
        }
        
        self.network.getModel(request: NetworkParams.acronymSearch(acronym).urlRequest) { [weak self] (result: Result<[Acronym], Error>) in
                switch result {
                case .success(let result):
                    // decode sucess
                    if let value = result.first {
                        // true success
                        self?.result = value
                        completionHandler(nil)
                    } else {
                        self?.result = nil
                        completionHandler(NetworkError.emptyResult)
                    }
                case .failure(let error):
                    completionHandler(error)
                }
            }
    }
    
    var count: Int {
        return self.result?.lfs.count ?? 0
    }
    
    func acronymText(for index: Int) -> String? {
        guard index < (self.result?.lfs.count ?? 0) else { return nil }
        return self.result?.lfs[index].lf
    }

}
