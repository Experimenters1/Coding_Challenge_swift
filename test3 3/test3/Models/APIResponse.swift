//
//  APIResponse.swift
//  test3
//
//  Created by Huy Vu on 2/22/24.
//

import Foundation


// MARK: - Model

struct APIResponse: Codable{
    let total: Int
    let total_pages: Int
    let results: [Result]
}



