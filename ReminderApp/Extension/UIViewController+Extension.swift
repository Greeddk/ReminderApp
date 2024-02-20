//
//  UIViewController+Extension.swift
//  ReminderApp
//
//  Created by Greed on 2/19/24.
//

import UIKit

extension UIViewController {
    
    func changeDateFormat(data: Date) -> String{
        let targetFormat = DateFormatter()
        targetFormat.dateFormat = "yyyy.M.d. a HH:mm"
        
        let comparisonFormat = DateFormatter()
        comparisonFormat.dateFormat = "yyyy.M.d"
        
        if comparisonFormat.string(from: Date()) == comparisonFormat.string(from: data) {
            let todayFormat = DateFormatter()
            todayFormat.dateFormat = "a HH:mm"
            return "오늘 \(todayFormat.string(from: data))"
        }
        return targetFormat.string(from: data)
    }

    func saveImageToDocument(image: UIImage, filename: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    func loadImageFromDocument(filename: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            return nil
        }
    }
    
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("file remove error",error)
            }
        } else {
            print("file doesn't exist")
        }
    }
    
}
