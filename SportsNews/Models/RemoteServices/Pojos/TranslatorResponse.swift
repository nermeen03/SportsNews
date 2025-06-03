//
//  TranslatorResponse.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 03/06/2025.
//

class TranslatorResponse : Decodable{
    var translation : String
}

class LibreTranslateResponse : Decodable{
    var translatedText : String
}
