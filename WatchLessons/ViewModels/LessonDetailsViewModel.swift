//
//  LessonDetailsViewModel.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 03/03/2023.
//

import Foundation

class LessonDetailViewModel {
    
    func ifFileExist(fileName: String) -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let url = NSURL(fileURLWithPath: path)
        
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: "\(filePath).mp4") {
                return true
                
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func saveFileAtDocumentDir(at locationURL: URL, fileName: String) {
        let documentsDirectoryURL =  FileManager().urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        print(documentsDirectoryURL)

        // Here you can move your downloaded file
        
        do {
            try FileManager().moveItem(at: locationURL, to: documentsDirectoryURL.appendingPathComponent("\(fileName).mp4")!)
            print("File saved")

        } catch {
            print(error)
            print(error.localizedDescription)
            print("File not saved")
        }
    }
    
    func docFiles() {
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            for url in fileURLs {
                print(url)
            }
            
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }

    }
}
