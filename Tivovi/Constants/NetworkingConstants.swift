

import Foundation

struct NetworkingConstants {
    
    //Staging URL
//    static let baseURL = "http://shop24.dk/"
    static let baseURL = "http://api.climadd.com/"

    //static let baseURL = "http://localhost/tivovi/public/"
    static let userPhoto = "uploads/users/"
    static let defaultImageUrl = "http://api.climadd.com"
   
    struct account {
        //Mark:-  Login - Singup - General
        static let API_register = "API_register"
        static let API_login = "API_login"
        static let API_showprofile = "API_showprofile"
        static let API_updateprofile = "API_updateprofile"
        static let API_forgotAction = "API_forgotAction"
        static let API_resetAction = "API_resetAction"
        static let API_resetPassword = "API_resetPassword"
        static let API_company_signup = "API_company_signup"
        static let API_company_login = "API_company_login"
        static let API_social_login = "API_register_social"
        static let API_shipment_action = "API_shipment_action"
        static let API_shipment_action2 = "API_shipment_action2"
        static let API_show_comments = "API_show_comments"
        static let API_add_comment = "API_add_comment"
        static let API_ajaxdatauser = "API_ajaxdatauser"
        static let API_ajaxdatauserAPINew = "API_ajaxdatauserAPINew"
        static let API_invite = "API_invite"

    }
    
    struct company {
        static let API_getAllCompany = "API_getAllCompany"
        static let API_getPackageByUserId = "API_getPackageByUserId"
        static let API_getPendingNotificationUserId = "API_getPendingNotificationUserId"
        static let API_RejectPackage = "API_RejectPackage"
        static let API_AcceptPackage = "API_AcceptPackage"
        static let API_updatePackageCompanyLogo = "API_updatePackageCompanyLogo"
        static let API_share_userdata = "API_share_userdata"
        static let API_deletePackage = "API_deletePackage"
        static let API_searchLogo = "API_searchlogo"
        static let API_applyLogo = "API_updatelogo"
        static let API_updatePackage = "API_updatePackage"
        static let API_friends = "API_friends"
        static let API_deleteFriend = "API_deleteFriend"
        static let API_acceptFriend = "API_acceptFriend"
        static let API_deleteshared = "API_deleteshared"
        
        static let API_ajaxdatauserAPINew = "API_ajaxdatauserAPINew"
        static let API_SearchUsers = "API_SearchUsers"
        
        static let API_addFriend = "API_addFriend"
        static let API_ShareShop = "API_ShareShop"
        static let API_deletePackageOrShared = "API_deletePackageOrShared"
        static let API_getshared = "API_getshared"
        static let API_updatesharednotification = "API_updatesharednotification"


    }
    
    struct swipePage {
        static let API_getRandomScreens = "API_getRandomScreens"
        static let API_screensLikeUnlike = "API_screensLikeUnlike"
        static let API_screensUndo = "API_screensUndo"
        static let API_getAllMyLikedScreens = "API_getAllMyLikedScreens"
        static let API_max_image = "dkscreens/iphone-max.zip.download/iphone-max/"
        static let Company_logo = "dkscreens/Company_logo/"
    }
    
    struct addImage {
        static let API_addImage = "API_addimage"
    }
    
}
