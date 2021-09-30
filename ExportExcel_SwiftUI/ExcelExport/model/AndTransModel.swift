//
//  AndTransModel.swift
//  ExcelToString
//
//  Created by Yeongeun Song on 2021/09/30.
//

import UIKit
import SwiftyXMLParser

protocol AndTransDelegate:AnyObject {
    func enableBtnMergeAnd(isOn:Bool)
}

class AndTransModel: TransModel {

    public weak var andTransDelegate:AndTransDelegate?

    public func workAuto(txtNameKo:String,
                         txtNameEn:String) {
        if arrayAllExcelItem.count == 0 {
            return
        }
        
        printExportFormat(array: arrayAllExcelItem, type: .kor) /* iOS 복붙용 한글 print */
        printExportFormat(array: arrayAllExcelItem, type: .eng) /* iOS 복붙용 영문 print */
        
        if let array = arrayFromXml(fileName: txtNameKo, type: .kor) {
            if let filterArray = filterDifference(arrayEntire: arrayAllExcelItem, arrayEach: array) {
                arrayOriginFilterKo = filterArray /* 한글 코드와 다른부분 필터 */
            }
        }
        
        if let array = arrayFromXml(fileName: txtNameEn, type: .eng) {
            if let filterArray = filterDifference(arrayEntire: arrayAllExcelItem, arrayEach: array) {
                arrayOriginFilterEng = filterArray /* 영문 코드와 다른부분 필터 */
            }
        }
        
        printfilterSortedArray(arry: arrayOriginFilterKo, type: .kor) /* 한글 필터 print */
        printfilterSortedArray(arry: arrayOriginFilterEng, type: .eng) /* 영문 필터 print */
        
        andTransDelegate?.enableBtnMergeAnd(isOn: arrayOriginFilterKo.count != 0 && arrayOriginFilterEng.count != 0) /* merge버튼 활성화 */
        
        filterMerge() /* 한글, 영문 합치기 */
        
        printExportFormat(array: arrayFilterMerge, type: .kor) /* 필터값 복붙용 한글 print */
        printExportFormat(array: arrayFilterMerge, type: .eng) /* 필터값 복붙용 영문 print */
    }
    
    public func filterMerge() {
        filterMerge(osType: .android)
    }
    
    public func originCheck(originFileName:String,
                            langType:LanguageType) {
        
        if let array = arrayFromXml(fileName: originFileName, type: langType) {
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
        andTransDelegate?.enableBtnMergeAnd(isOn: btnOn)
    }
    
    private func arrayFromXml(fileName:String,
                              type:LanguageType) -> [EachLocale]? {
    
        var resultArray = [EachLocale]()
        let path = Bundle.main.path(forResource: fileName, ofType: "xml")
        do {
            let fileString = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            let xml = try XML.parse(fileString)
            let element = xml["resources","string"]
            
            let printString = "\n***** Android 코드에 사용중인 \(type.rawValue) String 갯수 *****\n\(element.all?.count ?? 0)\n*****************************************\n"
            updatePrint(strUpdate: printString)
            
            if let strings = element.all {
                for each in strings {
                    var eachId = ""
                    var eachValue = ""
                    if let id = each.attributes["name"] {
                        eachId = id
                    }
                    
                    if let value = each.text {
                        eachValue = value
                    }
                    
                    switch type {
                    case .none:
                        return nil
                    case .kor:
                        resultArray.append(EachLocale(strId: eachId, kor: eachValue, eng: ""))
                    case .eng:
                        resultArray.append(EachLocale(strId: eachId, kor: "", eng: eachValue))
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
        
        printExportFormat(array: array, type: type, osType: .android)
    }
    
}
