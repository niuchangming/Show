//
//  Constants.swift
//  DouYin
//
//  Created by Niu Changming on 21/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let BAMBUSER_APP_ID = "g9spSwNrRb1bR8soIE9OUA"
    static let FACEBOOK_APP_ID = "977193229120279"
    static let WECHAT_APP_ID = "wx761c050f021c979c"
    static let WECHAT_SECRET = "ae4c46579f27a5bc5224743d18f3ea80"
    static let FACEBOOK_LOGGED = "facebook"
    static let WECHAT_LOGGED = "wechat"
    static let MOBILE_LOGGED = "mobile"
    
    static let IS_IPHONE: Bool = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
    static let IS_IPHONE_4: Bool = IS_IPHONE && (Dimension.SCREEN_HEIGHT == 480.0)
    static let IS_IPHONE_5: Bool = IS_IPHONE && (Dimension.SCREEN_HEIGHT == 568.0)
    static let IS_IPHONE_6: Bool = IS_IPHONE && (Dimension.SCREEN_HEIGHT == 667.0)
    static let IS_IPHONE_6PLUS: Bool = IS_IPHONE && (UIScreen.main.nativeScale == 3.0)
    static let IS_IPHONE_X: Bool = IS_IPHONE && (Dimension.SCREEN_HEIGHT == 812.0)
    static let IS_RETINA: Bool = UIScreen.main.scale == 2.0
    
    struct ColorScheme {
        static let blackColor = "#5B5A62"
        static let orangeColor = "#FF9376"
        static let redColor = "#D50065"
        static let blueColor = "#2096BA"
        static let greenColor = "#6bc92c"
        static let lightGrayColor = "#F2F2F6"
    }
    
    struct Dimension {
        static let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
        static let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height
        static let W_RATIO: CGFloat = 1/375.0*SCREEN_WIDTH
        static let H_RATIO: CGFloat = 1/667.0*SCREEN_HEIGHT
        static let MARGIN_NOR: CGFloat = 15.0
        static let MARGIN_LARGE: CGFloat = 20.0
        static let MARGIN_MIDDLE: CGFloat = 8.0
        static let MARGIN_SMALL: CGFloat = 5.0
        static let TOP_SPACE: CGFloat = IS_IPHONE_X ? 24.0 : 0.0
        static let CORNER_SIZE: CGFloat = 4
        static let TEXT_SIZE_NOR: CGFloat = 15.0
        static let TEXT_SIZE_SMALL: CGFloat = 13.0
    }
    
    struct Auth {
        static let LOGGED_IN = "logged_in"
        static let ACCESS_TOKEN = "access_token"
        static let LOGIN_TYPE = "logged_type"
        static let FB_TOKEN_EXPIRED = "fb_expired"
        static let FB_ACCESS_TOKEN = "fb_access_token"
        static let WX_TOKEN_EXPIRED = "wx_expired"
        static let WX_ACCESS_TOKEN = "wx_access_token"
    }
}
