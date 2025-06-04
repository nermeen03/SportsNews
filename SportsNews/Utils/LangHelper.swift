import Foundation

extension String {
    func localizedDigits() -> String {
        let isArabic: Bool
        
        if #available(iOS 16.0, *) {
            isArabic = Locale.current.language.languageCode?.identifier == "ar"
        } else {
            isArabic = Locale.current.languageCode == "ar"
        }
        
        guard isArabic else { return self }
        
        let arabicNumerals = ["٠": "0", "١": "1", "٢": "2", "٣": "3",
                             "٤": "4", "٥": "5", "٦": "6", "٧": "7",
                             "٨": "8", "٩": "9"]
        
        var result = ""
        for char in self {
            if Int(String(char)) != nil {
                // Convert Western digit to Arabic numeral
                if let arabicDigit = arabicNumerals.first(where: { $0.value == String(char) })?.key {
                    result.append(arabicDigit)
                } else {
                    result.append(char)
                }
            } else {
                // Check if character is already an Arabic numeral
                if arabicNumerals.keys.contains(String(char)) {
                    result.append(char)
                } else {
                    result.append(char)
                }
            }
        }
        
        return result
    }
    
    func localizedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
}
