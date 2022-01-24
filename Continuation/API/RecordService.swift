import Firebase

struct RecordInfo {
    let image: UIImage
    let date: String
}

struct RecordService {
    
    static func uploadDaysInfo(info: RecordInfo, completion: @escaping((Error?) -> Void)) {
        
        ImageUploader.ImageUploader(image: info.image) { imageUrl in
            
            let date = info.date.replacingOccurrences(of: "/", with: ".")
            let data: [String: Any] = ["imageUrl": imageUrl,
                                       "date": date,
                                       "timeStamp": Timestamp()]
            
            COLLECTION_RECORDS.addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchDayInfo(completion: @escaping(([Record]) -> Void)) {
        COLLECTION_RECORDS.order(by: "timeStamp", descending: false).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let days = documents.map { Record( day: $0.data()) }
            print("###days: \(days)")
            completion(days)
        }
    }
}
