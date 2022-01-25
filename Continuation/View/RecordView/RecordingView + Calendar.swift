import UIKit

extension RecordView {
    
    // MARK: - Action
    
    @objc func didTapPreMonthButton() {
        selectDate = CalendarHelper().minusMonth(date: selectDate) ?? Date()
        setMonthView()
    }
    
    @objc func didTapNextMonthButton() {
        selectDate = CalendarHelper().plusMonth(date: selectDate) ?? Date()
        setMonthView()
    }
    
    // MARK: - Helper
    
    func setMonthView() {
        totalSquare.removeAll()
        
        guard let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectDate) else { return }
        guard let daysInMonth = CalendarHelper().daysInMonth(date: selectDate) else { return }
        guard let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth) else { return }
        
        var count: Int = 1
        
        while (count <= 42) {
            if(count <= startingSpaces || count - startingSpaces > daysInMonth) {
                totalSquare.append("")
            } else {
                totalSquare.append(String(count - startingSpaces))
                
                let year = CalendarHelper().yearString(date: selectDate)
                let month = CalendarHelper().monthString(date: selectDate)
                let fullDate = "\(year).\(month).\((String(count - startingSpaces)))"
                fullDateForCheckIfRecordExist.append(fullDate)
            }
            count += 1
        }
        createMonthFont()
        collectionView.reloadData()
    }
    
    func createMonthFont() {
        let monthString = CalendarHelper().titleMonthJapaneseString(date: selectDate)
        let numberAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.aileron(size: 38), .kern: -10]
        let textAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.senobi(size: 30)]
        let attributedText = NSMutableAttributedString(string: monthString, attributes: numberAttributes)
        attributedText.append(NSAttributedString(string: " 月", attributes: textAttributes))
        monthLabel.attributedText = attributedText
    }
    
    func checkIfRecordExist(totalSquare: String) -> DataForSquare {
        
        var dateString: String = ""
        var dataForSquare: DataForSquare?
        
        fullDateForCheckIfRecordExist.forEach  { string in
            let lastTwoString = string.suffix(2)
            let modifiedLastTwoString = lastTwoString.replacingOccurrences(of: ".", with: "")
            if modifiedLastTwoString == totalSquare { dateString = string }
        }
        
        days.forEach { day in
            if day.date == dateString {
                dataForSquare = DataForSquare(dateString: totalSquare, record: day)
            }
        }
        
        return dataForSquare ?? DataForSquare(dateString: totalSquare, record: nil)
    }
}
