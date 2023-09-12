import UIKit
import Flutter
// import RongIMLib
// import rongcloud_im_plugin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate{

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // 推送处理 1 (申请推送权限)
        registerUserNotification()
        
        // 获取推送数据
        let remoteNotificationUserInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]

        // 向 Flutter 层传递推送数据
        // if let userInfo = remoteNotificationUserInfo {
        //     DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
        //         RCIMFlutterWrapper.shared().sendData(toFlutter:userInfo as! [AnyHashable : Any])
        //     };
        // }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func registerUserNotification(){
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (_, _) in })
            center.delegate = self
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }


    // 推送处理 2 (注册用户通知设置)
    override func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
        super.application(application, didRegister: notificationSettings)
    }


    // 推送处理 3 (上传DeviceToken)
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // RCIMClient.shared()?.setDeviceTokenData(deviceToken)
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    //    RCIMFlutterWrapper.shared().sendData(toFlutter:userInfo)
        super.application(application, didReceiveRemoteNotification: userInfo)
    }
}
