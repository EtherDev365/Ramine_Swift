//
//  AppDelegate.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import GoogleSignIn
import GTMOAuth2
import FBSDKCoreKit
import Firebase
import UserNotifications
import FirebaseAnalytics
import FirebaseMessaging
import Flurry_iOS_SDK

import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate  {

    let prefs = UserDefaults.standard
    var window: UIWindow?
    let toolBar = UIToolbar()
    var navController : UINavigationController?	
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true

        let backButton = UIImage(named: "next")
        _ = backButton?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 10)

        // GOOGLE
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID
        
        Flurry.startSession("7HK47RC83SNVX73W8ZX8", with: FlurrySessionBuilder
            .init()
            .withCrashReporting(true)
            .withLogLevel(FlurryLogLevelAll))
        
        if prefs.object(forKey: "loginKey") as! String? == "1"
        {
            let model = UserModel.sharedInstance
            model.setUserDefaultsValues()
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            let vc = MainViewController()
                   let navOne = UINavigationController(rootViewController: vc)
            navOne.setNavigationBarHidden(true, animated: false)
            let mainVC = navOne
            window?.rootViewController = mainVC
        }
//        }else{
//            window = UIWindow(frame: UIScreen.main.bounds)
//            window?.makeKeyAndVisible()
//            let mainVC = HomeVC()
//            window?.rootViewController = mainVC
//        }

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (isSuccess, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        FIRApp.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
       BarButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .highlighted)
       UINavigationBar.appearance().barTintColor = UIColor.white
       // UINavigationBar.appearance().isTranslucent = false
        
        // these next lines aren't needed if you like the default
        
       // UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]  // shouldn't be needed, but if you want something
        UINavigationBar.appearance().tintColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)
        
        
        // Commented by Ramesh
//        scheduleLocal()
        
        return true
    }
    
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = ""
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        let array = [21,22,23,24,25]
        _ = [DateComponents]()
        for item in array
        {
            var dateComponent = DateComponents()
            dateComponent.hour = 23
            dateComponent.minute = item
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
    }
    
    func getImageWithColorPosition(color: UIColor, size: CGSize, lineSize: CGSize) -> UIImage {
        let rect = CGRect(x:0, y: 0, width: size.width, height: size.height)
        let rectLine = CGRect(x:0, y:-1,width: lineSize.width,height: lineSize.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        color.setFill()
        UIRectFill(rectLine)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    @objc func tokenRefreshNotification(notification: NSNotification) {
        
    }
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            //print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //print(FIRInstanceID.instanceID().token())
        let prefs = UserDefaults.standard
        
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        //print("Device Token: \(token)")
        
        if let instanceIdToken = FIRInstanceID.instanceID().token() {
            //print("New token \(instanceIdToken)")
            prefs.set(instanceIdToken, forKey: "device_token")
           
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //print("Registration failed!")
       // //print(FIRInstanceID.instanceID().token()!)
        let prefs = UserDefaults.standard
        prefs.set("123", forKey: "device_token")
        //print("APNs registration failed: \(error)")
    }
    // Firebase notification received
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        
        // custom code to handle push while app is in the foreground
        //print("Handle push from foreground \(notification.request.content.userInfo)")
        
        
        // Reading message body
//        let dict = notification.request.content.userInfo["aps"] as! NSDictionary
//
//        var messageBody:String?
//        var messageTitle:String = "Alert"
//
//        if let alertDict = dict["alert"] as? Dictionary<String, String> {
//            messageBody = alertDict["body"]!
//            if alertDict["title"] != nil { messageTitle  = alertDict["title"]! }
//
//        } else {
//            messageBody = dict["alert"] as? String
//        }
//
//        //print("Message body is \(messageBody!) ")
//        //print("Message messageTitle is \(messageTitle) ")
        
        // Let iOS to display message
        completionHandler([.alert,.sound, .badge])
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //print("Message \(response.notification.request.content.userInfo)")
        completionHandler()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATIONS.USER_NOTIFICATION_BADGE), object: nil)
    }
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //print("Entire message \(userInfo)")
        
        let state : UIApplication.State = application.applicationState
        switch state {
        case UIApplicationState.active:
            print("If needed notify user about the message")
        default:
            print("Run code to download content")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATIONS.USER_NOTIFICATION_BADGE), object: nil)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaultManager().saveFavorite(favoriteArray)
    }
    
    
    //MARK: Google sign in
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        if #available(iOS 9.0, *) {
            
            return GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,  annotation: [:])
        }
        
        return true
        
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return  GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication, annotation: annotation)
        
    }

}

