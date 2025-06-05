//
//  TranslatorResponse.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 03/06/2025.
//

class TranslatorResponse : Decodable{
    var translatedText : String
}

class TranslatorArrayResponse : Decodable{
    var translatedText : [String]
}
