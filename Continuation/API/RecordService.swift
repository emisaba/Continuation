import Firebase

struct RecordInfo {
    let image: UIImage
    let date: String
}

struct RecordService {
    
    static func uploadDaysInfo(info: RecordInfo, completion: @escaping((Error?) -> Void)) {
        
        ImageUploader.ImageUploader(image: info.image) { imageUrl in
            
            let documentTitle = info.date.replacingOccurrences(of: "/", with: "")
            let data = ["imageUrl": imageUrl, "date": info.date]
            
            COLLECTION_RECORDS.document(documentTitle).setData(data, completion: completion)
        }
    }
    
    static func fetchDayInfo(completion: @escaping(([Record]) -> Void)) {
        COLLECTION_RECORDS.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let days = documents.map { Record( day: $0.data()) }
            completion(days)
        }
    }
}
