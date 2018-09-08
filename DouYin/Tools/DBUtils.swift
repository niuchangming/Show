//
//  DBUtils.swift
//  DouYin
//
//  Created by Niu Changming on 8/9/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import CoreData

class DBUtils: NSObject {
    
    static let share : DBUtils = {
        let manager = DBUtils()
        return manager
    }()
    
    lazy var dataContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }()
    
    func like(resourceId: String, completed :@escaping (Status) -> ()){
        let likeAPI = String(format: "%@likes/like", Constants.HOST)
        ConnectionManager.shareManager.request(method: .post, url: likeAPI, parames: ["resourceId": resourceId, "token": AuthUtils.share.apiToken()] as [String: AnyObject], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                completed(.success)
                self.save(resourceId: resourceId, entityName: "ResourceLikeMap")
            } else {
                completed(.failure)
                print("Like Error: \(message)")
            }
        }) { (error) in
            completed(.failure)
            print("Like Error: \(String(describing: error?.localizedDescription))")
        }
    }
    
    func unlike(resourceId: String, completed :@escaping (Status) -> ()){
        let likeAPI = String(format: "%@likes/unlike", Constants.HOST)
        ConnectionManager.shareManager.request(method: .post, url: likeAPI, parames: ["resourceId": resourceId, "token": AuthUtils.share.apiToken()] as [String: AnyObject], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                completed(.success)
                self.delete(resourceId: resourceId, entityName: "ResourceLikeMap")
            } else {
                completed(.failure)
                print("Unlike Error: \(message)")
            }
        }) { (error) in
            completed(.failure)
            print("Unlike Error: \(String(describing: error?.localizedDescription))")
        }
    }
    
    func favorite(resourceId: String, completed :@escaping (Status) -> ()){
        let favouriteAPI = String(format: "%@favourites/favourite", Constants.HOST)
        ConnectionManager.shareManager.request(method: .post, url: favouriteAPI, parames: ["resourceId": resourceId, "token": AuthUtils.share.apiToken()] as [String: AnyObject], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                completed(.success)
                self.save(resourceId: resourceId, entityName: "ResourceFavoriteMap")
            } else {
                completed(.failure)
                print("Favorite Error: \(message)")
            }
        }) { (error) in
            completed(.failure)
            print("Favorite Error: \(String(describing: error?.localizedDescription))")
        }
    }
    
    func unFavorite(resourceId: String, completed :@escaping (Status) -> ()){
        let unFavouriteAPI = String(format: "%@favourites/cancel", Constants.HOST)
        ConnectionManager.shareManager.request(method: .post, url: unFavouriteAPI, parames: ["resourceId": resourceId, "token": AuthUtils.share.apiToken()] as [String: AnyObject], succeed: { (responseJson) in
            
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode == 1 {
                completed(.success)
                self.delete(resourceId: resourceId, entityName: "ResourceFavoriteMap")
            } else {
                completed(.failure)
                print("UnFavorite Error: \(message)")
            }
        }) { (error) in
            completed(.failure)
            print("UnFavorite Error: \(String(describing: error?.localizedDescription))")
        }
    }
    
    func fetchLike(resourceId: String) -> Int{
        var resultCount: Int = 0
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ResourceLikeMap")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "resourceId = %@", resourceId)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try dataContext.fetch(request)
            resultCount = result.count
        } catch {
            print("Fetch Like Failed")
        }
        return resultCount
    }
    
    func fetchFavorite(resourceId: String) -> Int{
        var resultCount: Int = 0
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ResourceFavoriteMap")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "resourceId = %@", resourceId)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try dataContext.fetch(request)
            resultCount = result.count
        } catch {
            print("Fetch Favorite Failed")
        }
        return resultCount
    }
    
    func save(resourceId: String, entityName: String){
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: dataContext)
        let likeManagedObj = NSManagedObject(entity: entity!, insertInto: dataContext)
        likeManagedObj.setValue(resourceId, forKey: "resourceId")
    }
    
    func delete(resourceId :String, entityName: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "resourceId = %@", resourceId)
        request.returnsObjectsAsFaults = false
        
        do{
            let fetchResult = try dataContext.fetch(request)
    
            guard let likeObj = fetchResult.first else { return }
            dataContext.delete(likeObj as! NSManagedObject)
        } catch {
            print("Delete Like Failed")
        }
    }
    
    func saveContext () {
        if dataContext.hasChanges {
            do {
                try dataContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
