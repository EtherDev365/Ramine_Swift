//
//  PackageModel.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftDate

enum OptionPackageEnum {
    case Track, Share, Message, Photo
}

class PackageModel {
    
    var id:String?
    var courier = ""
    var shipmentId = ""
    var user_id:String?
    var uri:String?
    var title = ""
    var description:String?
    var text_description = ""
    var time:String?
    var image:String?
    var status:String?
    var share_by_user = ""
    var sharedbyuser = ""
    var notified = ""

    var created_at = ""
    var updated_at:String?
    var commentCount = ""
    var logoUrl:String?
    var defaultUrl:String?
    
    var purchaseDate = ""
    
    var return_days: Int
    var notification_days: Int
    var setNotificationReturnDay = "on"
    
    var waranty_months: Int
    var w_notification_days: Int
    var setNotificationWarrantyDay = "on"
    var setTrackTrace = "on"

    var setNotificationStatusDay = "on"
    var priceMatchDay: Int = 0
    var priceMatchNotificationDay: Int = 0
    var setNotificationPriceMatchDay = "on"
    
    var imageUrls: [String]
    var imageUrlsThumbs: [String]
    var avatar = ""
    var activeAction: [OptionPackageEnum] = []
    
    var shareContent:String?
    var shopurl: String?
    
    var Default_image: String?

    
    init() {
        self.id = ""
        self.courier = ""
        self.shipmentId = ""
        self.user_id = ""
        self.uri = ""
        self.title = ""
        self.description = ""
        self.text_description = ""
        self.time = ""
        self.image = ""
        self.status = ""
        self.share_by_user = ""
        self.sharedbyuser = ""
        self.created_at = ""
        self.updated_at = ""
        self.commentCount = ""
        self.logoUrl = ""
        self.defaultUrl = ""
        self.notified = ""
        self.return_days = 1
        self.notification_days = 1
        
        self.waranty_months = 1
        self.w_notification_days = 1
        self.shareContent = ""
        self.imageUrls = []
        self.imageUrlsThumbs = []

        self.shopurl = ""
        self.Default_image = "";
    }
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        
       
        self.courier = json["courier"].stringValue
        self.shipmentId = json["shipmentId"].stringValue
        self.user_id = json["user_id"].stringValue
        self.uri = json["uri"].stringValue
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.text_description = json["text_description"].stringValue
        self.time = json["time"].stringValue
        self.image = json["image"].stringValue
        self.status = json["status"].stringValue
        self.share_by_user = json["share_by_user"].stringValue
        self.sharedbyuser = json["sharedbyuser"].stringValue
        self.notified = json["notified"].stringValue
        created_at = json["created_at"].stringValue
        self.updated_at = json["updated_at"].stringValue
        self.commentCount = json["commentCount"].stringValue
        self.logoUrl = json["logoUrl"].stringValue
        self.defaultUrl = json["defaultUrl"].stringValue
        self.setTrackTrace = json["t_onoff"].stringValue
        self.shopurl = json["shopurl"].stringValue
        self.shareContent =  json["shareinfo"].stringValue
        self.Default_image = json["Default_image"].stringValue
        avatar = json["Avtaar"].stringValue

        
        purchaseDate = json["purchase_date"].stringValue
        
        return_days = json["return_days"].int ?? 7
//        notification_days = json["notification_days"].int ?? 1
        notification_days = 7
        setNotificationReturnDay = json["r_onoff"].stringValue
        
        waranty_months = json["waranty_months"].int ?? 1
//        w_notification_days = json["W_notification_days"].int ?? 7
        w_notification_days = 30
        setNotificationWarrantyDay = json["w_onoff"].stringValue

        priceMatchDay = json["PriceMatch_days"].intValue
//        priceMatchNotificationDay = json["PriceMatch_notification_days"].intValue
        priceMatchNotificationDay = 7

        setNotificationPriceMatchDay = json["p_onoff"].stringValue
        
        self.imageUrls = []
        if let images = json["images"].dictionary {
            if let files = images["files"]?.array {
                for file in files {
                    if file.string != nil {
                        self.imageUrls += [file.string!]
                    }
                }
            }
        }
        
        self.imageUrlsThumbs = []
        if let images = json["images"].dictionary {
            if let files = images["filesthumb"]?.array {
                for file in files {
                    if file.string != nil {
                        self.imageUrlsThumbs += [file.string!]
                    }
                }
            }
        }
        updateActionActive()
    }
    
    func setImages(json: JSON)
    {
        self.imageUrls = []
        if let files = json["files"].array {
                for file in files {
                    if file.string != nil {
                        self.imageUrls += [file.string!]
                    }
                }
            }
        
    }
    
    func updateActionActive() {
        
        if share_by_user.count > 0 {
            activeAction.append(.Share)
        }
        
        if commentCount.count > 0 {
            activeAction.append(.Message)
        }
        
        if shipmentId.count > 0 {
            activeAction.append(.Track)
        }
        
        if imageUrls.count > 0 {
            activeAction.append(.Photo)
        }
    }
    
    func clone() -> PackageModel {
        let package = PackageModel()
        
        package.id = id
        package.courier = courier
        package.shipmentId = shipmentId
        package.user_id = shipmentId
        package.uri = uri
        package.title = title
        package.description = description
        package.text_description = text_description
        package.time = time
        package.image = image
        package.status = status
        package.share_by_user = share_by_user
        package.sharedbyuser = sharedbyuser
        package.created_at = created_at
        package.updated_at = updated_at
        package.commentCount = commentCount
        package.logoUrl = logoUrl
        package.defaultUrl = defaultUrl
        
        package.purchaseDate = purchaseDate
        
        package.return_days = return_days
        package.notification_days = notification_days
        package.setNotificationReturnDay = setNotificationReturnDay
        
        package.waranty_months = waranty_months
        package.w_notification_days = w_notification_days
        package.setNotificationWarrantyDay = setNotificationWarrantyDay
        package.priceMatchDay = priceMatchDay
        package.priceMatchNotificationDay = priceMatchNotificationDay
        package.setNotificationPriceMatchDay = setNotificationPriceMatchDay
        package.shopurl = shopurl
        package.activeAction = activeAction
        package.Default_image = Default_image
        return package
    }
}

//MARK: - Purchase Date
extension PackageModel {
    
    func getPurchaseDateDisplay() -> String {

        if let purchaseDateValue = getPurchaseDate() {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.dateFormat = "dd/MM/yyyy" //added by raminde
            return formatter.string(from: purchaseDateValue)
        }
        
        return "----:--:--"
    }
    
    func getPurchaseDate() -> Date? {
        
        if purchaseDate.count > 0 {

            return CODateFormatter.dateFormatter.date(from: purchaseDate)?.convertToLocal()
        }
        
     
        
        return CODateFormatter.dateFormatter.date(from: created_at)?.convertToLocal()
    }
}

//MARK: - Price Match Date
extension PackageModel {
    
    func getPriceMatchDateDisplay() -> String {
        
//        if let returnDateValue = getReturnDate() {
//            return CODateFormatter.noneTimeDateFormatter.string(from: returnDateValue)
//        }
        if let returnDateValue = getPriceMatchDate() {
                    return CODateFormatter.noneTimeDateFormatter.string(from: returnDateValue)
                }
        
        return "----:--:--"
    }
    
    func getPriceMatchDate() -> Date? {

        if let purchaseDateValue = getPurchaseDate() {
            return purchaseDateValue.addDay(n: priceMatchDay)
        }
        
        return nil
    }
    
    func getPriceMatchDay() -> Int {
        
        guard let purchaseDateValue = getPurchaseDate() else {
            return 0
        }
        
        guard let returnDateValue = getPriceMatchDate() else {
            return 0
        }
        
        
//        return Date.daysBetween(start: purchaseDateValue, end: returnDateValue)
        return Date.daysBetween(start: Date().localDate(), end: returnDateValue)
    }
    
    func getNotificationPriceMatchDateDisplay() -> String {

        if let returnDateValue = getNotificationPriceMatchDate() {
            return CODateFormatter.noneTimeDateFormatter.string(from: returnDateValue)
        }
        
        return "----:--:--"
    }
    
    func getNotificationPriceMatchDate() -> Date? {

        if let returnDateValue = getPriceMatchDate() {
            return returnDateValue.minusDay(n: priceMatchNotificationDay)
        }
        
        return nil
    }
    
    func getNotificationPriceMatchDay() -> Int {
        
        guard let notificationReturnDateValue = getNotificationPriceMatchDate() else {
            return 0
        }
        
        guard let returnDateValue = getPriceMatchDate() else {
            return 0
        }
        
        
        if ( Date().localDate().isBetween(startDate: notificationReturnDateValue, endDate: getPriceMatchDate()!))
      {
        //  print("come")
          return 0
      }else
      {
         // print("do not come")
          
          return 1
      }
             
        
        
        
//        return Date.daysBetween(start: notificationReturnDateValue, end: returnDateValue)
        return Date.daysBetween(start: Date().localDate(), end: notificationReturnDateValue)
    }
}

extension Date
{
    func isBetween(startDate:Date, endDate:Date)->Bool
    {
         return (startDate.compare(self) == .orderedAscending) && (endDate.compare(self) == .orderedDescending)
    }
}

//MARK: - Return Date
extension PackageModel {
    
    func getReturnDateDisplay() -> String {
        
        if let returnDateValue = getReturnDate() {
            return CODateFormatter.noneTimeDateFormatter.string(from: returnDateValue)
        }
        
        return "----:--:--"
    }
    
    func getReturnDate() -> Date? {

        if let purchaseDateValue = getPurchaseDate() {
            //print("date with added return days \(purchaseDateValue.addDay(n: return_days))")
            return purchaseDateValue.addDay(n: return_days)
        }
        
        return nil
    }
    
    func getReturnDay() -> Int {
        
        guard let purchaseDateValue = getPurchaseDate() else {
            return 0
        }
        
        guard let returnDateValue = getReturnDate() else {
            return 0
        }
        
        
//        return Date.daysBetween(start: purchaseDateValue, end: returnDateValue)
        return Date.daysBetween(start: Date().localDate(), end: returnDateValue)
    }
    
    func getNotificationReturnDateDisplay() -> String {

        if let returnDateValue = getNotificationReturnDate() {
            return CODateFormatter.noneTimeDateFormatter.string(from: returnDateValue)
        }
        
        return "----:--:--"
    }
    
    func getNotificationReturnDate() -> Date? {

        if let returnDateValue = getReturnDate() {
            
         //   print("date with minus notification days \(returnDateValue.minusDay(n: notification_days))")

            return returnDateValue.minusDay(n: notification_days)
        }
        
        return nil
    }
    
    func getNotificationReturnDay() -> Int {
        
        guard let notificationReturnDateValue = getNotificationReturnDate() else {
            return 0
        }
        
        guard getReturnDate() != nil else {
            return 0
        }
        
        //print("Todays Date \(Date().localDate())")

        //print("notificationReturnDateValue \(notificationReturnDateValue)")

//        //print(Date().localDate());
//        //print(notificationReturnDateValue);
        
        
//        return Date.daysBetween(start: notificationReturnDateValue, end: returnDateValue)
        
        
      
        
        
        if ( Date().localDate().isBetween(startDate: notificationReturnDateValue, endDate: getReturnDate()!))
        {
          //  print("come")
            return 0
        }else
        {
           // print("do not come")
            
            return 1
        }
       

        return Date.daysBetween(start: Date().localDate(), end: notificationReturnDateValue)
    }
}


//MARK: - Warranty Date
extension PackageModel {
    
    func getWarrantyDateDisplay() -> String {
        
        if let warrantyDateValue = getWarrantyDate() {
            return CODateFormatter.noneTimeDateFormatter.string(from: warrantyDateValue)
        }
        
        return "----:--:--"
    }
    
    func getWarrantyDate() -> Date? {

        if let purchaseDateValue = getPurchaseDate() {
            return purchaseDateValue.addYear(n: waranty_months)
        }
        
        return nil
    }
    
    func getWarrantyDay() -> Int {
        
        guard let purchaseDateValue = getPurchaseDate() else {
            return 0
        }
        
        guard let warrantyDateValue = getWarrantyDate() else {
            return 0
        }
        
//        return Date.daysBetween(start: purchaseDateValue, end: warrantyDateValue)
        return Date.daysBetween(start: Date().localDate(), end: warrantyDateValue)
    }
    
    func getNotificationWarrantyDateDisplay() -> String {
        
        if let warrantyDateValue = getNotificationWarrantyDate() {
            return CODateFormatter.noneTimeDateFormatter.string(from: warrantyDateValue)
        }
        
        return "----:--:--"
    }
    
    func getNotificationWarrantyDate() -> Date? {
        
        if let warrantyDateValue = getWarrantyDate() {
            return warrantyDateValue.minusDay(n: w_notification_days)
        }
        
        return nil
    }
    
    func getNotificationWarrantyDay() -> Int {
        
        guard let notificationWarrantyDateValue = getNotificationWarrantyDate() else {
            return 0
        }
        
        guard let warrantyDateValue = getWarrantyDate() else {
            return 0
        }
        
        print("Notification start date : \(notificationWarrantyDateValue)")

      print("Todays Date : \(Date().localDate())")
      
      print("Return Date : \(getWarrantyDate())")
        
        if ( Date().localDate().isBetween(startDate: notificationWarrantyDateValue, endDate: getWarrantyDate()!))
        {
           // print("come")
            return 0
        }else
        {
          //  print("do not come")
            
            return 1
        }
        
//        return Date.daysBetween(start: notificationWarrantyDateValue, end: warrantyDateValue)
        return Date.daysBetween(start: Date().localDate(), end: notificationWarrantyDateValue)
    }
    func dateDifference(notificationDate: String?) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        guard let dateA = formatter.date(from: notificationDate ?? "") else { return -1 }
        guard let dateB = formatter.date(from: formatter.string(from: Date())) else { return -1 }
        let diffInDays = Calendar.current.dateComponents([.day], from: dateA, to: dateB).day
        return diffInDays ?? -1
    }
}

extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
    
    
    func convertToLocal() -> Date {
        let nowUTC = self
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
}

