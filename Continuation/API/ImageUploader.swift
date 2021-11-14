import UIKit
import FirebaseStorage

struct ImageUploader {
    
    static func ImageUploader(image: UIImage, completion: @escaping ((String) -> Void)) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = UUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "/image/\(filename)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            ref.downloadURL { url, error in
                guard let urlString = url?.absoluteString else { return }
                completion(urlString)
            }
        }
    }
}
