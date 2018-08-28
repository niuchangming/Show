//
//  Utils.swift
//  DouYin
//
//  Created by Niu Changming on 5/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import AssetsLibrary

class Utils: NSObject {
    
    static func makeGradientColor(`for` object : AnyObject) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [(UIColor(hexString: Constants.ColorScheme.redColor).cgColor), (UIColor(hexString: Constants.ColorScheme.orangeColor).cgColor)]
        gradient.locations = [0.0 , 1.0]
        
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: object.frame.size.width, height: object.frame.size.height)
        return gradient
    }
    
    static func isNotNil(obj: Any?) -> Bool {
        if obj is String {
            if (obj as? String) != nil && ((obj as? String)?.count)! > 0{
                return true
            }else {
                return false
            }
        }else if obj is Array<Any> {
            if (obj as? Array<Any>) != nil {
                return true
            }else {
                return false
            }
        }else if obj is Dictionary<AnyHashable, Any> {
            if (obj as? Dictionary<String, Any>) != nil {
                return true
            }else {
                return false
            }
        }else if obj is Data {
            if (obj as? Data) != nil {
                return true
            }else {
                return false
            }
        }else if obj is NSNumber {
            if (obj as? NSNumber) != nil{
                return true
            }else {
                return false
            }
        }else if obj is UIImage {
            if (obj as? UIImage) != nil {
                return true
            }else {
                return false
            }
        }
        return obj != nil
    }
    
    static func viewController(responder: UIResponder) -> UIViewController? {
        if let vc = responder as? UIViewController {
            return vc
        }
        
        if let next = responder.next {
            return viewController(responder: next)
        }
    
        return nil
    }
    
    static func isNumber(str: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: str)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    static func deviceId() -> String{
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static func fakeName() -> String{
        let names = ["阙造", "广锡一", "席寺", "扶驾", "郑萱黄", "林樊牵", "孟登元", "鱼彰", "皮忧暑", "左稗", "宦醇", "糜弋招", "席准", "方抑", "乌泔", "苗鲁", "孟候依", "龙珠饯", "洪打鹰", "缪负铎"]
    
        return names[Int(arc4random_uniform(UInt32(names.count)))]
    }
    
    static func stringToDictionary(str: String) -> [String: Any]? {
        if let data = str.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func makeGradientColor(`for` object : AnyObject, startColor: UIColor, endColor: UIColor) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: object.frame.size.width, height: object.frame.size.height)
        return gradient
    }
    
    static func popAlert(title: String?, message: String?, controller: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func mergeVideoAndAudio(videoUrl: URL,
                                   audioUrl: URL,
                                   shouldFlipHorizontally: Bool = false,
                                   completion: @escaping (_ error: Error?, _ url: URL?) -> Void) {
        
        let mixComposition = AVMutableComposition()
        var mutableCompositionVideoTrack = [AVMutableCompositionTrack]()
        var mutableCompositionAudioTrack = [AVMutableCompositionTrack]()
        var mutableCompositionAudioOfVideoTrack = [AVMutableCompositionTrack]()
        
        //start merge
        
        let aVideoAsset = AVAsset(url: videoUrl)
        let aAudioAsset = AVAsset(url: audioUrl)
        
        let compositionAddVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
                                                                 preferredTrackID: kCMPersistentTrackID_Invalid)
        
        let compositionAddAudio = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio,
                                                                 preferredTrackID: kCMPersistentTrackID_Invalid)
        
        let compositionAddAudioOfVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio,
                                                                        preferredTrackID: kCMPersistentTrackID_Invalid)
        
        let aVideoAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        let aAudioOfVideoAssetTrack: AVAssetTrack? = aVideoAsset.tracks(withMediaType: AVMediaType.audio).first
        let aAudioAssetTrack: AVAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaType.audio)[0]
        
        compositionAddVideo?.preferredTransform = aVideoAssetTrack.preferredTransform
        
        if shouldFlipHorizontally {
            var frontalTransform: CGAffineTransform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            frontalTransform = frontalTransform.translatedBy(x: -aVideoAssetTrack.naturalSize.width, y: 0.0)
            frontalTransform = frontalTransform.translatedBy(x: 0.0, y: -aVideoAssetTrack.naturalSize.width)
            compositionAddVideo?.preferredTransform = frontalTransform
        }
        
        mutableCompositionVideoTrack.append(compositionAddVideo!)
        mutableCompositionAudioTrack.append(compositionAddAudio!)
        mutableCompositionAudioOfVideoTrack.append(compositionAddAudioOfVideo!)
        
        do {
            try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero,
                                                                                aVideoAssetTrack.timeRange.duration),
                                                                of: aVideoAssetTrack,
                                                                at: kCMTimeZero)
            try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero,
                                                                                aVideoAssetTrack.timeRange.duration),
                                                                of: aAudioAssetTrack,
                                                                at: kCMTimeZero)

            if let aAudioOfVideoAssetTrack = aAudioOfVideoAssetTrack {
                try mutableCompositionAudioOfVideoTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero,
                                                                                           aVideoAssetTrack.timeRange.duration),
                                                                           of: aAudioOfVideoAssetTrack,
                                                                           at: kCMTimeZero)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // Exporting
        let savePathUrl: URL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/mergedVideo.mp4")
        do { // delete old video
            try FileManager.default.removeItem(at: savePathUrl)
        } catch { print(error.localizedDescription) }
        
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        assetExport.outputFileType = AVFileType.mp4
        assetExport.outputURL = savePathUrl
        assetExport.shouldOptimizeForNetworkUse = true
        
        assetExport.exportAsynchronously { () -> Void in
            switch assetExport.status {
            case AVAssetExportSessionStatus.completed:
                print("success")
                completion(nil, savePathUrl)
            case AVAssetExportSessionStatus.failed:
                print("failed \(assetExport.error?.localizedDescription ?? "error nil")")
                completion(assetExport.error, nil)
            case AVAssetExportSessionStatus.cancelled:
                print("cancelled \(assetExport.error?.localizedDescription ?? "error nil")")
                completion(assetExport.error, nil)
            default:
                print("complete")
                completion(assetExport.error, nil)
            }
        }
    }
}
















