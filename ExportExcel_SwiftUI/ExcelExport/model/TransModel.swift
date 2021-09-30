//
//  TransModel.swift
//  ExcelToString
//
//  Created by Yeongeun Song on 2021/09/30.
//

import UIKit

protocol TransModelDelegate:AnyObject {
    func enableBtnExportMerge(isOn:Bool, osType:OSType)
    func observePrint(printStr:String)
}

class TransModel: NSObject {
    
    public var arrayAllExcelItem = [EachLocale]()
    
    public var arrayOriginFilterKo = [EachLocale]()
    public var arrayOriginFilterEng = [EachLocale]()
    public var arrayFilterMerge = [EachLocale]()
    public weak var transModelDelegate:TransModelDelegate?
    
    init(excelItem:[EachLocale]) {
        self.arrayAllExcelItem = excelItem
    }
    
    public func filterDifference(arrayEntire:[EachLocale],
                                  arrayEach:[EachLocale]) -> [EachLocale]? {
        let filter = arrayEach.filter { origin in
            let originId = origin.strId
            return !arrayEntire.contains(where: { each in
                each.strId == originId
            })
        }
        let filterSorted = filter.sorted { $0.strId < $1.strId }
        return filterSorted
    }
    
    public func filterMerge(osType:OSType) {
        arrayFilterMerge.removeAll()
        var mergeLanType:LanguageType = .none
        var count = 0
        
        if arrayOriginFilterKo.count > arrayOriginFilterEng.count {
            count = arrayOriginFilterKo.count
            arrayFilterMerge.append(contentsOf: arrayOriginFilterKo)
            mergeLanType = .kor
        } else {
            count = arrayOriginFilterEng.count
            arrayFilterMerge.append(contentsOf: arrayOriginFilterEng)
            mergeLanType = .eng
        }
        
        var tempArray = [EachLocale]()
        if mergeLanType == .kor {
            /* merge에 KO가 설정되어있음 */
            tempArray.append(contentsOf: arrayOriginFilterEng)
            for index in 0..<count {
                for each in tempArray {
                    if arrayFilterMerge[index].strId == each.strId {
                        arrayFilterMerge[index].eng = each.eng
                    } else {
                        if !arrayFilterMerge.contains(where: { $0.strId == each.strId }) {
//                            print(each)
                            arrayFilterMerge.append(each)
                        }
                    }
                }
            }
        } else {
            /* merge에 ENG 가 설정되어있음 */
            tempArray.append(contentsOf: arrayOriginFilterKo)
            for index in 0..<count {
                for each in tempArray {
                    if arrayFilterMerge[index].strId == each.strId {
                        arrayFilterMerge[index].kor = each.kor
                    } else {
                        if !arrayFilterMerge.contains(where: { $0.strId == each.strId }) {
//                            print(each)
                            arrayFilterMerge.append(each)
                        }
                    }
                }
            }
        }
        transModelDelegate?.enableBtnExportMerge(isOn: true, osType: osType)
        printfilterSortedAll(arry: arrayFilterMerge)
    }
    
    public func printExportFormat(array:[EachLocale],
                                   type:LanguageType,
                                   osType:OSType) {

        var printString = "\n******************** \(osType.rawValue) 복사 붙여넣기용 \(type.rawValue) EXPORT ********************\n"
        updatePrint(strUpdate: printString)
        
        if array.count == 0 {
            return
        }
        
        switch osType {
        case .android:
            let space = "    "
            printString = "<resources>\n"
            updatePrint(strUpdate: printString)
            for each in array {
                switch type {
                case .kor:
                    printString = "\(space)<string name=\"\(each.strId)\">\(each.kor)</string>\n"
                    updatePrint(strUpdate: printString)
                case .eng:
                    printString = "\(space)<string name=\"\(each.strId)\">\(each.eng)</string>\n"
                    updatePrint(strUpdate: printString)
                default:
                    break
                }
            }
            printString = "</resources>\n"
            updatePrint(strUpdate: printString)
        case .ios:
            for each in array {
                switch type {
                case .kor:
                    printString = "\"\(each.strId)\" = \"\(each.kor)\"\n"
                    updatePrint(strUpdate: printString)
                case .eng:
                    printString = "\"\(each.strId)\" = \"\(each.eng)\"\n"
                    updatePrint(strUpdate: printString)
                case .none:
                    return
                }
            }
        }
        
        printString = "************ Count = \(array.count) ************\n"
        updatePrint(strUpdate: printString)
    }
    
    public func printfilterSortedArray(arry:[EachLocale],
                                       type:LanguageType) {
        var printString = "\n***** \(type.rawValue) 기존 코드에 사용중인 값이지만 신규 Excel에 없는 값 *****\n"
        updatePrint(strUpdate: printString)
        for index in 0..<arry.count {
            let each = arry[index]
            var trans = ""
            switch type {
            case .none:
                continue
            case .kor:
                trans = each.kor
            case .eng:
                trans = each.eng
            }
            printString = "(\(String(format: "%02d", index)))  ID : \(each.strId)      \(type.rawValue) 번역 : \(trans)\n"
            updatePrint(strUpdate: printString)
        }
        
        printString = "******************** Count = \(arry.count) **********************\n"
        updatePrint(strUpdate: printString)
    }
    
    private func printfilterSortedAll(arry:[EachLocale]) {
        var printString = "\n***** 한글, 영문 통합 기존 코드에 사용중인 값이지만 신규 Excel에 없는 값 *****\n\n"
        updatePrint(strUpdate: printString)
        for each in arry {
            printString = "ID : \(each.strId)\n한글 변역:\"\(each.kor)\"\n영문 번역:\"\(each.eng)\"\n\n"
            updatePrint(strUpdate: printString)
        }
        printString = "******************* Count = \(arry.count) *******************\n"
        updatePrint(strUpdate: printString)
    }
    
    public func updatePrint(strUpdate:String) {
        print(strUpdate)
        transModelDelegate?.observePrint(printStr: strUpdate)
    }
}
