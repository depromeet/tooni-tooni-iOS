//
//  AppDelegate+Push.swift
//  TooniTooni
//
//  Created by buzz on 2021/07/06.
//

import UIKit

extension AppDelegate {

  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    PushManager.shared.remoteNotificationDidRegister(deviceToken: deviceToken)
  }

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    PushManager.shared.remoteNotification(
      application,
      didReceiveRemoteNotification: userInfo
    )
    completionHandler(UIBackgroundFetchResult.newData)
  }

  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print(error)
    PushManager.shared.remoteNotificationDidFailToRegister()
  }
}
