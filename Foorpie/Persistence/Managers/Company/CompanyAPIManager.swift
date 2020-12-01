//
//  CompanyAPIManager.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 12/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class CompanyAPIManager: CompanyAPIManagerRepresentable {

    static var shared: CompanyAPIManager =  CompanyAPIManager()
    
    private init() {}
    
    func getCompanies(result: @escaping (Result<[Company], Error>) -> Void) {
        guard let url = URLManager.companiesURL() else { return result(.failure(RequestError.invalidURL)) }
        APIService.shared.makeRequest(url: url, method: .get, result: result)
    }
    
    func createCompany(_ company: Company, result: @escaping (Result<Company, Error>) -> Void) {
        guard let url = URLManager.companiesURL() else { return result(.failure(RequestError.invalidURL)) }
        APIService.shared.makeRequest(url: url, method: .post, body: company, result: result)
    }
    
    func deleteCompany(_ id: Int, result: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URLManager.companiesURL(id: id) else { return result(.failure(RequestError.invalidURL)) }
        print(url)
        APIService.shared.makeRequest(url: url, method: .delete) { (res: Result<SuccessResponse, Error>) in
            switch res {
            case .success(let successResponse):
                if successResponse.success == true {
                    result(.success(true))
                } else {
                    result(.failure(RequestError.unknown))
                }
            case .failure(let error):
                result(.failure(error))
            }
            
        }
    }
    
}
