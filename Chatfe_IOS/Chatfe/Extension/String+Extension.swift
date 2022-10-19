//
//  String+Extension.swift
//  Chatfe
//
//  Created by Piyush Mohan on 05/04/22.
//

import Foundation
import UIKit

extension String {
    public func isValidEmail() -> Bool {
        let stricterFilterString: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        return emailTest.evaluate(with: self)
    }
    
    public func isValidPincode() -> Bool {
        let stricterFilterString: String = "[1-9][0-9]{5}"
        let pincodeTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        return pincodeTest.evaluate(with: self)
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            attributedString.addAttribute(.font, value: UIColor.darkGray, range: NSMakeRange(0, attributedString.length))
            return attributedString
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension StringProtocol {
    var masked: String {
        return String(repeating: ".", count: Swift.max(0, count-6)) + suffix(4)
    }
}

extension String {
    func before(first delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            let before = prefix(upTo: index)
            return String(before)
        }
        return ""
    }
    
    func after(first delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            let after = suffix(from: index).dropFirst()
            return String(after)
        }
        return ""
    }
    
    var maskedEmail: String {
        return String(repeating: ".", count: Swift.max(0, count - 4)) + suffix(4)
    }
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    // remove a prefix if it exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
        // remove a suffix if it exixts
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

extension String {
    
    func convertToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        dateFormatter.timeZone = TimeZone.current
        if let dt = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let formattedStringDate = dateFormatter.string(from: dt)
            return formattedStringDate
        }
        return "01/01/1970"
    }
    
    func convertToDateMMddyyyy() -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let dt = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let formattedStringDate = dateFormatter.string(from: dt)
            return formattedStringDate
        }
        return "01/01/1970"
    }
    
    func convertDateToSpecificFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        if let dt = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MMM dd"
            let formattedStringDate = dateFormatter.string(from: dt)
            return formattedStringDate
        }
        return "01/01/1970"
    }
    
    func convertDateToSpecificFormat1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let dt = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MMM dd"
            let formattedStringDate = dateFormatter.string(from: dt)
            return formattedStringDate
        }
        return "01/01/1970"
    }
    
    func getFormattedDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        let date = formatter.date(from: self)
        return date
    }
    
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormats.yyyyMMddTHHmmssSSSZ
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd hh:mma"
        let date = formatter.date(from: self)
        return date
    }
    
    func convertDateToSpecificTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 2022-07-18T05:05:01.868Z
        if let dt = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "hh:mm a"
            let formattedStringDate = dateFormatter.string(from: dt)
            return formattedStringDate
        }
        return "01/01/1970"
    }
    
    func convertStringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        return date
    }
    
}


//MARK: - GLOBAL FUNCTIONs FOR USER STRING TO UTC (TO BE SENT TO SERVER) & VICE-VERSA
extension String {
    
    // LOCAL TO SERVER TIME
    func localToServerTime() -> String {
        // LOCAL STRING TO UTC DATE
        let formatter = DateFormatter()
//        formatter.dateFormat = DateFormats.yyyyMMddhhmma // "yyyy-MM-ddhh:mma"
//        formatter.dateFormat = "yyyy-MM-ddhh:mma"
        formatter.dateFormat = self.contains(":") ? "yyyy-MM-ddhh:mma" : "yyyy-MM-ddhha"
        formatter.timeZone = TimeZone.current
        if let eventDateTime = formatter.date(from: self) {
            // UTC DATE TO AGAIN STRING
            formatter.dateFormat = DateFormats.yyyyMMddTHHmmssSSSZ // "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            let strDate = formatter.string(from: eventDateTime)
            return strDate
        }
        return ""
    }
    
    // SERVER TO LOCAL TIME
    func serverToLocalTime() -> String {
        // SERVER STRING TO UTC DATE
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormats.yyyyMMddTHHmmssSSSZ // "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = formatter.date(from: self) {
            // UTC DATE TO AGAIN STRING
            formatter.dateFormat = DateFormats.yyyyMMddhhmma // "yyyy-MM-dd hh:mma"
            formatter.timeZone = TimeZone.current
            let timeStamp = formatter.string(from: date)
            return timeStamp
        }
        return ""
    }
    
    /// EXTRACT EVENT DATE
    func extractDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.yyyyMMddhhmma
        if let date = dateFormatter.date(from: self) {
//            dateFormatter.dateFormat = DateFormats.yyyyMMdd
            dateFormatter.dateFormat = DateFormats.MMddyyyy
            let strDate = dateFormatter.string(from: date)
            return strDate
        }
        return ""
    }
    
    func extractDate(outputFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.yyyyMMddhhmma
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = outputFormat
            let strDate = dateFormatter.string(from: date)
            return strDate
        }
        return ""
    }
    
    func extractCustomizeDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.yyyyMMddhhmma
        if let date = dateFormatter.date(from: self) {
//            dateFormatter.dateFormat = DateFormats.yyyyMMdd
            dateFormatter.dateFormat = "MMM dd"
            let strDate = dateFormatter.string(from: date)
            return strDate
        }
        return ""
    }
    
    /// EXTRACT START TIME
//    func extractStartTime(strDate: String) -> String {
    func extractStartTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.yyyyMMddhhmma // "yyyy-MM-ddhh:mma" // input format
//        if let date = dateFormatter.date(from: strDate) {
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "hh:mma" // output format
            let strTime = dateFormatter.string(from: date)
            return strTime
        }
        return ""
    }
    
    func extractStartTime(_ outputFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.yyyyMMddhhmma // "yyyy-MM-ddhh:mma" // input format
//        if let date = dateFormatter.date(from: strDate) {
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = outputFormat // output format
            let strTime = dateFormatter.string(from: date)
            return strTime
        }
        return ""
    }
    
    // TO BLOCK PAST TIME
    func checkPastTime() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mma"
        dateFormatter.timeZone = TimeZone.current
        let eventDate = dateFormatter.date(from: self)
        return eventDate ?? Date()
    }

    func currentDateTime() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mma"
        formatter.timeZone = TimeZone.current
        let strDate = formatter.string(from: Date())
    //        print("\nCURRENT DATE STRING :> \(strDate)")
        
    //    formatter.dateFormat = "yyyy-MM-dd hh:mma"
        
        let todayDate = formatter.date(from: strDate)
        return todayDate ?? Date()
    }

//    if enteredDate == currentDate {
//        print("EQUAL")
//    } else if enteredDate < currentDate {
//        print("LESS THAN CURRENT")
//    }  else if enteredDate > currentDate {
//        print("GREATER THAN CURRENT")
//    }
}

// TO BLOCK PAST TIME
func returnUTCDate(date: String) -> Date {
//func checkPastTime(date: String, startTime: String) -> Date {
//    let strEventDateTime = "\(date) \(startTime)"
//        print("INPUT STRING DATE TIME :> \(strEventDateTime)")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormats.yyyyMMddhhmma // "yyyy-MM-dd hh:mma"
    dateFormatter.timeZone = TimeZone.current
    let eventDate = dateFormatter.date(from: date)
    return eventDate ?? Date()
}

func currentDateTime() -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormats.yyyyMMddhhmma // "yyyy-MM-dd hh:mma"
    formatter.timeZone = TimeZone.current
    let strDate = formatter.string(from: Date())
//        print("\nCURRENT DATE STRING :> \(strDate)")
    
//    formatter.dateFormat = "yyyy-MM-dd hh:mma"
    
    let todayDate = formatter.date(from: strDate)
    return todayDate ?? Date()
}

func currentTimeStamp() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormats.yyyyMMddhhmma // "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    formatter.timeZone = TimeZone.current
    let strDate = formatter.string(from: Date())
    return strDate
}

extension String {
    
    func stringToImage() -> UIImage? {
        var image: UIImage?
        guard let url = URL(string: self) else { return nil }
        if let imageData = try? Data(contentsOf: url) {
            if let loadedImage = UIImage(data: imageData) {
                image = loadedImage
            }
        }
        return image
    }
    
    func serverToLocalFormattedTime() -> String {
        // SERVER STRING TO UTC DATE
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormats.yyyyMMddTHHmmssSSSZ // "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = formatter.date(from: self) {
            // UTC DATE TO AGAIN STRING
//            formatter.dateFormat = DateFormats.yyyyMMddhhmma // "yyyy-MM-dd hh:mma"
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.timeZone = TimeZone.current
            let timeStamp = formatter.string(from: date)
            return timeStamp
        }
        return ""
    }
    
    func extractFormattedStartTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        dateFormatter.dateFormat = DateFormats.yyyyMMddhhmma // "yyyy-MM-ddhh:mma" // input format
//        if let date = dateFormatter.date(from: strDate) {
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "hh:mm a" // output format
            let strTime = dateFormatter.string(from: date)
            return strTime
        }
        return ""
    }
    
    /// FOR EDIT ROOM - TO MATCH WITH START TIME ARRAY
    func getFormattedStartTime() -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.dateFormat = DateFormats.yyyyMMddhhmma // "yyyy-MM-ddhh:mma" // input format
//        if let date = dateFormatter.date(from: strDate) {
        if let date = dateFormatter.date(from: self) {
            if self.contains(":30") {
                dateFormatter.dateFormat = "hh:mma" // output format
            } else {
                dateFormatter.dateFormat = "ha" // output format
            }
            let strTime = dateFormatter.string(from: date)
            return strTime
        }
        return ""
    }
    
    func localStringToDate() -> Date {
        // STRING TO UTC DATE
        let dateFormatter = DateFormatter()
    //    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.dateFormat = DateFormats.yyyyMMddhhmma // "yyyy-MM-dd hh:mma"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // NSTimeZone(name: "UTC") as TimeZone?
    //    dateFormatter.timeZone = TimeZone.current
        if let date = dateFormatter.date(from: self) {// create   date from string
//            print("\nSERVER DATE (DATE TYPE) 1:> \(date)")
            return date
        }
        return Date()
    }

}
