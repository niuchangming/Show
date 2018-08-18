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
    static let SENDBIRD_APP_ID = "9FFC187F-1F31-46B3-A77D-BB96008A8EED"
    static let BAMBUSER_APP_ID = "AaXc6qwSYn4LWD1egxzpAg" //"g9spSwNrRb1bR8soIE9OUA"
    static let FACEBOOK_APP_ID = "977193229120279"
    static let WECHAT_APP_ID = "wx761c050f021c979c"
    static let WECHAT_SECRET = "ae4c46579f27a5bc5224743d18f3ea80"
    static let FACEBOOK_LOGGED = "facebook"
    static let WECHAT_LOGGED = "wechat"
    static let MOBILE_LOGGED = "mobile"
    static let HOST = "http://ec2-52-41-0-146.us-west-2.compute.amazonaws.com:8081/api/"
    static let CAMERA360_KEY = "T5ZduqJjSBbnNKV/KO9gIYssoR/XntrEfuW6fvNvdYD5hVeSG/BWwvd4EJT7UdSBd3ggYEHOkcLPfDGMD2mR2/gNUg9A4PTb23Oi2/4ft0DIELXUpR772BGxyn430fiE4/rvdzT1M5d28LTBoAkCEG0KDHQKzejt9GtHWCqWFVBBs4sZlGuC3h8sfa1XV/7HtvIDHqhLQHymjmHOeFE3YA8DGHXUJ9Jd3HKcmU8u97eRIXM5Ak5aEhDbqXdFlzQu3irBZzfGCFBetoe5fUxUc3XmM9nnXdotSt7ngLEp/NPpZSZ8qrqbI09WahycfqdjFJgfAzEjt/dDrZd5609pMeP1W8Ze0SJTE/BmltQUTgrXP8lS4Slsm8uQIUV2IbkIB01UEQ3s4EXILQv+DeBLBobwvjDgKx/LdP7t0wvdtZV8q5ApuNIWoyriNhiRJgL+Dmi+9R//oXk7gRcDrr2NC6+dEZLUuPbHiH4ZzVZiLw=="
    
    static let IS_IPHONE: Bool = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
    static let IS_IPHONE_4: Bool = IS_IPHONE && (Dimension.SCREEN_HEIGHT == 480.0)
    static let IS_IPHONE_5: Bool = IS_IPHONE && (Dimension.SCREEN_HEIGHT == 568.0)
    static let IS_IPHONE_6: Bool = IS_IPHONE && (Dimension.SCREEN_HEIGHT == 667.0)
    static let IS_IPHONE_6PLUS: Bool = IS_IPHONE && (UIScreen.main.nativeScale == 3.0)
    static let IS_IPHONE_X: Bool = IS_IPHONE && (Dimension.SCREEN_HEIGHT == 812.0)
    static let IS_RETINA: Bool = UIScreen.main.scale == 2.0
    
    struct ColorScheme {
        static let blackColor = "#5B5A62"
        static let darkBlackColor = "#333"
        static let orangeColor = "#FC5C1B"
        static let redColor = "#D50065"
        static let blueColor = "#35A3FB"
        static let greenColor = "#6bc92c"
        static let grayColor = "#C3C3C3"
        static let purpleColor = "#805AFF"
        static let lightGrayColor = "#F2F2F6"
        static let darkBlueColor = "#161824"
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
        static let STATUS_BAR_HEIGHT: CGFloat = Constants.IS_IPHONE_X ? 44 : 20
        static let NAV_BAR_HEIGHT: CGFloat = Constants.IS_IPHONE_X ? 88 : 64
        static let NAV_STATUS_BAR_HEIGHT: CGFloat = NAV_BAR_HEIGHT + STATUS_BAR_HEIGHT
        static let TAB_BAR_HEIGHT: CGFloat = Constants.IS_IPHONE_X ? 49 + 34 : 49
        static let HOME_INDICATOR_HEIGHT: CGFloat = Constants.IS_IPHONE_X ? 34 : 0
        static let BOTTOM_MARGE: CGFloat = HOME_INDICATOR_HEIGHT + 44
        static let TOP_SPACE: CGFloat = IS_IPHONE_X ? 24.0 : 0.0
        static let CORNER_SIZE: CGFloat = 4
        static let TEXT_SIZE_LARGE: CGFloat = 18.0
        static let TEXT_SIZE_NOR: CGFloat = 15.0
        static let TEXT_SIZE_SMALL: CGFloat = 13.0
        static let TEXT_SIZE_EXTRA_SMALL: CGFloat = 12.0
    }
    
    struct Auth {
        static let LOGGED_IN = "logged_in"
        static let API_TOKEN = "api_token"
        static let LOGIN_TYPE = "logged_type"
        static let MOBILE = "logged_mobile"
        static let USER_CODE = "user_code"
        static let ROLE = "role"
        static let CHANNEL_ID = "channel_id"
        
        static let FB_TOKEN_EXPIRED = "fb_expired"
        static let FB_ACCESS_TOKEN = "fb_access_token"
        static let FB_USER_ID = "fb_user_id"
        
        static let WX_TOKEN_EXPIRED = "wx_expired"
        static let WX_ACCESS_TOKEN = "wx_access_token"
        static let WX_UNION_ID = "wx_union_id"
    }
}
