//
//  FleckFramework.swift
//  FleckFramework
//
//  Created by Muhammad Tayyab on 27/06/2019.
//

import Foundation
import UIKit
class FleckFramework  {
    public static func navigateToViewConroller(viewconroller: UIViewController, fingerNumber:Int, cnicData:String){
        let storyBoard = UIStoryboard(name : "Main", bundle: nil)
        let cameraController = storyBoard.instantiateViewController(withIdentifier: "FleckCameraViewController") as? FleckCameraViewController
        cameraController!.finger = "\(fingerNumber)"
        let lastCnic = cnicData.last!
        let cnicDig:Int = Int(String(lastCnic)) ?? 0
        if(cnicDig % 2 != 0){
            cameraController!.qualityThreash = UnsafeMutablePointer<Int32>.allocate(capacity: 35)
        }else {
            if(fingerNumber == 6 || fingerNumber == 1){
                cameraController!.qualityThreash = UnsafeMutablePointer<Int32>.allocate(capacity: 20)
            }else{
                cameraController!.qualityThreash = UnsafeMutablePointer<Int32>.allocate(capacity: 25)}
        }
        cameraController!.delegate_ = viewconroller as! FleckCallBack
        viewconroller.navigationController!.pushViewController(cameraController!, animated: true)
        
    }
}
