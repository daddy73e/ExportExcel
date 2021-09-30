//
//  iOSTransModel.swift
//  ExcelToString
//
//  Created by Yeongeun Song on 2021/09/30.
//

import Foundation

protocol iOSTransDelegate:AnyObject {
    func enableBtnMergeIOS(isOn:Bool)
}

class iOSTransModel: TransModel {
    
    public weak var iosTransDelegate:iOSTransDelegate?
    
    public func workAuto(txtNameKo:String,
                         txtNameEn:String) {
        if arrayAllExcelItem.count == 0 {
            return
        }
        
        printExportFormat(array: arrayAllExcelItem, type: .kor) /* iOS 복붙용 한글 print */
        printExportFormat(array: arrayAllExcelItem, type: .eng) /* iOS 복붙용 영문 print */
        
        if let array = arrayFromString(fileName: txtNameKo, type: .kor) {
            if let filterArray = filterDifference(arrayEntire: arrayAllExcelItem, arrayEach: array) {
                arrayOriginFilterKo = filterArray /* 한글 코드와 다른부분 필터 */
            }
        }
        
        if let array = arrayFromString(fileName: txtNameEn, type: .eng) {
            if let filterArray = filterDifference(arrayEntire: arrayAllExcelItem, arrayEach: array) {
                arrayOriginFilterEng = filterArray /* 영문 코드와 다른부분 필터 */
            }
        }
        
        printfilterSortedArray(arry: arrayOriginFilterKo, type: .kor) /* 한글 필터 print */
        printfilterSortedArray(arry: arrayOriginFilterEng, type: .eng) /* 영문 필터 print */
        
        iosTransDelegate?.enableBtnMergeIOS(isOn: arrayOriginFilterKo.count != 0 && arrayOriginFilterEng.count != 0) /* merge버튼 활성화 */
        
        filterMerge() /* 한글, 영문 합치기 */
        
        printExportFormat(array: arrayFilterMerge, type: .kor) /* 필터값 복붙용 한글 print */
        printExportFormat(array: arrayFilterMerge, type: .eng) /* 필터값 복붙용 영문 print */
    }
    
    public func filterMerge() {
        filterMerge(osType: .ios)
    }
    
    public func originCheck(originFileName:String,
                            langType:LanguageType) {
        
        if let array = arrayFromString(fileName: originFileName, type: langType) {
            if let filterArray = filterDifference(arrayEntire: arrayAllExcelItem, arrayEach: array) {
                switch langType {
                case .none:
                    return
                case .kor:
                    arrayOriginFilterKo = filterArray
                case .eng:
                    arrayOriginFilterEng = filterArray
                }
                printfilterSortedArray(arry: filterArray, type: langType)
            }
        }
        
        let btnOn = arrayOriginFilterKo.count != 0 && arrayOriginFilterEng.count != 0
        iosTransDelegate?.enableBtnMergeIOS(isOn: btnOn)
    }
    
    private func arrayFromString(fileName:String,
                                 type:LanguageType) -> [EachLocale]? {
        var resultArray = [EachLocale]()
        let path = Bundle.main.path(forResource: fileName, ofType: "txt")
        do{
            let fileString = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            let arryString = fileString.components(separatedBy: ";")
             
            
            let printString = "\n***** iOS 코드에 사용중인 \(type.rawValue) String 갯수 *****\n\(arryString.count)\n*****************************************\n"
            updatePrint(strUpdate: printString)
            
            for each in arryString {
                let strEach = each.components(separatedBy: "=")
                if strEach.count == 2 {
                    let id = strEach[0].replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\n", with: "")
                    var lang = strEach[1].replacingOccurrences(of: "\"", with: "")
                    /* 첫번째 글자가 공백 이면 remove */
                    if lang.count != 0 {
                        if lang.first == " " {
                            lang.removeFirst()
                        }
                    }
                    
                    switch type {
                    case .none:
                        return nil
                    case .kor:
                        resultArray.append(EachLocale(strId: id, kor: lang, eng: ""))
                    case .eng:
                        resultArray.append(EachLocale(strId: id, kor: "", eng: lang))
                    }
                } else {
                    let errEach = each.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
                    if !errEach.isEmpty {
                        print("error \(each)")
                    }
                }
            }
        } catch {
            print("Error encoding!!")
        }
        return resultArray
    }
    
    public func printExportFormat(array: [EachLocale], type: LanguageType) {
        if array.count == 0 {
            return
        }
        printExportFormat(array: array, type: type, osType: .ios)
    }
}
