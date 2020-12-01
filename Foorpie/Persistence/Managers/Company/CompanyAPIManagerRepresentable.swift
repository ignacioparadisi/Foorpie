//
//  CompanyAPIManagerRepresentable.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 12/1/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol CompanyAPIManagerRepresentable {
    func getCompanies(result: @escaping (Result<[Company], Error>) -> Void)
    func createCompany(_ company: Company, result: @escaping (Result<Company, Error>) -> Void)
    func deleteCompany(_ id: Int, result: @escaping (Result<Bool, Error>) -> Void)
}
