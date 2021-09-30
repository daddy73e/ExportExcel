//
//  ContentView.swift
//  ExcelExport
//
//  Created by Yeongeun Song on 2021/09/30.
//

import SwiftUI

struct ContentView: View {
    /* Config */
    
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Button("Translate") {
                viewModel.translate()
            }.font(.largeTitle).padding(.all)
            
            Spacer()
            VStack {
                Text ("iOS").font(.largeTitle).padding(.all)
                Button("Auto") {
                    viewModel.auto(osType: .ios)
                }.font(.title2).padding().disabled(!viewModel.isOnTranslate)
                HStack {
                    Button("적용소스 한글 비교") {
                        viewModel.originCheck(langType: .kor, osType: .ios)
                    }.font(.title3).padding().disabled(!viewModel.isOnTranslate)
                    VStack {
                        Button("Filter 합치기") {
                            viewModel.mergeFilter(osType: .ios)
                        }.font(.title3).padding().disabled(!viewModel.isOnFilterMergeIOS)
                        
                        Button("Filter 내보내기") {
                            viewModel.exportFilter(osType: .ios)
                        }.font(.title3).padding().disabled(!viewModel.isOnFilterExportIOS)
                    }
                    
                    Button("적용소스 영문 비교") {
                        viewModel.originCheck(langType: .eng, osType: .ios)
                    }.font(.title3).padding().disabled(!viewModel.isOnTranslate)
                }
                HStack {
                    
                    Button("Excel(Ko)iOS 내보내기") {
                        viewModel.exportExcel(osType: .ios, langType: .kor)
                    }.font(.title3).padding().disabled(!viewModel.isOnTranslate)
                    
                    Button("Excel(En)iOS 내보내기") {
                        viewModel.exportExcel(osType: .ios, langType: .eng)
                    }.font(.title3).padding().disabled(!viewModel.isOnTranslate)
                }
            }
            VStack {
                Text ("Adnroid").font(.largeTitle).padding(.all)
                Button("Auto") {
                    viewModel.auto(osType: .android)
                }.font(.title2).padding().disabled(!viewModel.isOnTranslate)
                HStack {
                    Button("적용소스 한글 비교") {
                        viewModel.originCheck(langType: .kor, osType: .android)
                    }.font(.title3).padding().disabled(!viewModel.isOnTranslate)
                    VStack {
                        Button("Filter 합치기") {
                            viewModel.mergeFilter(osType: .android)
                        }.font(.title3).padding().disabled(!viewModel.isOnFilterMergeAndroid)
                        Button("Filter 내보내기") {
                            viewModel.exportFilter(osType: .android)
                        }.font(.title3).padding().disabled(!viewModel.isOnFilterExportAndroid)
                    }
                    Button("적용소스 영문 비교") {
                        viewModel.originCheck(langType: .eng, osType: .android)
                    }.font(.title3).padding().disabled(!viewModel.isOnTranslate)
                }
                HStack {
                    Button("Excel(Ko)Android 내보내기") {
                        viewModel.exportExcel(osType: .android, langType: .kor)
                    }.font(.title3).padding().disabled(!viewModel.isOnTranslate)
                    
                    Button("Excel(En)Android 내보내기") {
                        viewModel.exportExcel(osType: .android, langType: .eng)
                    }.font(.title3).padding().disabled(!viewModel.isOnTranslate)
                }
            }
            
            Spacer()
            VStack{
                Button("COPY") {
                    viewModel.copyClipboard()
                }.font(.title2).padding()
                ScrollView {
                    VStack {
                        Text(viewModel.exportText)
                            .lineLimit(nil)
                    }.frame(maxWidth: .infinity)
                }
            }.padding()
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
