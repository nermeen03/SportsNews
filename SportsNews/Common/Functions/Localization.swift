//
//  Localization.swift
//  SportsNews
//
//  Created by Nermeen Mohamed on 03/06/2025.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

func isEnglish() -> Bool{
    let currentLanguageCode = Locale.current.language.languageCode?.identifier ?? "en"
    if currentLanguageCode == "en" {
        return true
    } else {
        return false
    }
}
