//
//  AppDelegate.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 12/31/23.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var persistenceController = PersistenceController.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var pollutants = PollutantManager.shared
        pollutants.fetchAllPollutantData()
        
        UNUserNotificationCenter.current().delegate = self
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication) {
        self.persistenceController.saveContext()
    }


}

extension AppDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Check if the app is in the foreground
        if UIApplication.shared.applicationState == .active {
            // Present custom UI notification
            presentCustomUINotification(notification)
            completionHandler([])
        } else {
            // Use .banner or .list (or both) for iOS 14 and later
            completionHandler([.banner, .sound])
        }
    }

    private func presentCustomUINotification(_ notification: UNNotification) {
        // Find the active window scene
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }

        // Instantiate custom notification view controller
        let customNotificationVC = AQINotificationViewController()
        customNotificationVC.configure(with: notification)

        // Add as a child view controller
        rootViewController.addChild(customNotificationVC)
        rootViewController.view.addSubview(customNotificationVC.view)
        customNotificationVC.didMove(toParent: rootViewController)

        // Use Auto Layout to set constraints
        customNotificationVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNotificationVC.view.centerXAnchor.constraint(equalTo: rootViewController.view.centerXAnchor),
            customNotificationVC.view.centerYAnchor.constraint(equalTo: rootViewController.view.centerYAnchor),
            customNotificationVC.view.widthAnchor.constraint(equalToConstant: 200),
            customNotificationVC.view.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    

}





