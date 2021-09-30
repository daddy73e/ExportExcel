//
//  ContentViewModel.swift
//  ExcelExport
//
//  Created by Yeongeun Song on 2021/09/30.
//

import UIKit

class ContentViewModel: ObservableObject {
    private var transModelIOS:iOSTransModel?
    private var transModelAnd:AndTransModel?
    private let excelTxtName = Config.excelTxtName
    private let separateChar = Config.separateChar
    private let originKoiOSTxtName = Config.originKoiOSTxtName
    private let originEniOSTxtName = Config.originEniOSTxtName
    private let originKoAndTxtName = Config.originKoAndTxtName
    private let originEnAndTxtName = Config.originEnAndTxtName
    
    @Published var isOnTranslate = false
    @Published var isOnFilterMergeIOS = false
    @Published var isOnFilterExportIOS = false
    @Published var isOnFilterMergeAndroid = false
    @Published var isOnFilterExportAndroid = false
    @Published var exportText = ""
    
    public func test() {
        exportText += "111" + "\n"
    }
    
    public func translate() {
        setUpModel()
    }
    
    public func auto(osType:OSType) {
        switch osType {
        case .android:
            transModelAnd?.workAuto(txtNameKo: originKoAndTxtName,
                                    txtNameEn: originEnAndTxtName)
        case .ios:
            transModelIOS?.workAuto(txtNameKo: originKoiOSTxtName,
                                    txtNameEn: originEniOSTxtName)
        }
    }
    
    public func originCheck(langType:LanguageType, osType:OSType) {
        if langType == .none {
            return
        }
        
        switch osType {
        case .android:
            switch langType {
            case .kor:
                transModelAnd?.originCheck(originFileName: originKoAndTxtName, langType: langType)
            case .eng:
                transModelAnd?.originCheck(originFileName: originEnAndTxtName, langType: langType)
            default:
                break
            }
        case .ios:
            switch langType {
            case .kor:
                transModelIOS?.originCheck(originFileName: originKoiOSTxtName, langType: langType)
            case .eng:
                transModelIOS?.originCheck(originFileName: originEniOSTxtName, langType: langType)
            default:
                break
            }
        }
    }
    
    public func mergeFilter(osType:OSType) {
        switch osType {
        case .android:
            transModelAnd?.filterMerge()
        case .ios:
            transModelIOS?.filterMerge()
        }
    }
    
    public func exportFilter(osType:OSType) {
        switch osType {
        case .android:
            if let array = transModelAnd?.arrayFilterMerge {
                transModelAnd?.printExportFormat(array: array, type: .kor)
                transModelAnd?.printExportFormat(array: array, type: .eng)
            }
        case .ios:
            if let array = transModelIOS?.arrayFilterMerge {
                transModelIOS?.printExportFormat(array: array, type: .kor)
                transModelIOS?.printExportFormat(array: array, type: .eng)
            }
        }
    }
    
    public func exportExcel(osType:OSType, langType:LanguageType) {
        switch osType {
        case .android:
            if let array = transModelAnd?.arrayAllExcelItem {
                transModelAnd?.printExportFormat(array: array, type: langType)
            }
        case .ios:
            if let array = transModelIOS?.arrayAllExcelItem {
                transModelIOS?.printExportFormat(array: array, type: langType)
            }
        }
    }
    
    private func setUpModel() {
        let datas = translateExcelFileData()
        isOnTranslate = datas.count != 0
        
        if transModelIOS == nil {
            transModelIOS = iOSTransModel(excelItem: datas)
            transModelIOS?.iosTransDelegate = self
            transModelIOS?.transModelDelegate = self
        }
        
        if transModelAnd == nil {
            transModelAnd = AndTransModel(excelItem: datas)
            transModelAnd?.andTransDelegate = self
            transModelAnd?.transModelDelegate = self
        }
    }
    
    private func translateExcelFileData() -> [EachLocale] {
        var resultArray = [EachLocale]()
        let path = Bundle.main.path(forResource: excelTxtName, ofType: "txt")
        
        do{
            let fileString = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            let arryString = fileString.components(separatedBy: "\n")
        
            print("")
            print("***** 엑셀 데이터 갯수 *****")
            print("\(arryString.count)")
            print("************************")
            print("")
            for each in arryString {
                let strEach = each.components(separatedBy: separateChar)
                if strEach.count == 3 {
                    let strId = strEach[0].replacingOccurrences(of: "\t", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    let strKor = strEach[1].replacingOccurrences(of: "\t", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    let strEng = strEach[2].replacingOccurrences(of: "\t", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    let eachItem:EachLocale = EachLocale(strId: strId, kor: strKor, eng: strEng)
                    resultArray.append(eachItem)
                } else {
                }
            }
            
            resultArray.sort { $0.strId < $1.strId }
            return resultArray
        } catch {
            return []
        }
    }
    
    public func copyClipboard() {
        UIPasteboard.general.string = exportText
    }
}

extension ContentViewModel:iOSTransDelegate {
    func enableBtnMergeIOS(isOn: Bool) {
        isOnFilterMergeIOS = isOn
    }
}

extension ContentViewModel:AndTransDelegate {
    func enableBtnMergeAnd(isOn: Bool) {
        isOnFilterMergeAndroid = isOn
    }
}

extension ContentViewModel:TransModelDelegate {
    func observePrint(printStr: String) {
        exportText += printStr
    }
    
    func enableBtnExportMerge(isOn: Bool, osType: OSType) {
        switch osType {
        case .android:
            isOnFilterExportAndroid = isOn
        case .ios:
            isOnFilterExportIOS = isOn
        }
    }
}
