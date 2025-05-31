//
//  APIResponse.swift
//  SportsNews
//
//  Created by mac on 31/05/2025.
//

struct APIResponse<T:Decodable> : Decodable {
    let success : Int
    let result : T
}
