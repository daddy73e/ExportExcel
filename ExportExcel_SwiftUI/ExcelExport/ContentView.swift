//
//  ContentView.swift
//  ExcelExport
//
//  Created by Yeongeun Song on 2021/09/30.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                Button("Translate") {
                    viewModel.translate()
                }.font(.largeTitle).padding(.all)
                
                Spacer()
                VStack {
                    HStack{
                        Text ("iOS")
                            .font(.body)
                            .foregroundColor(Color.black)
                            .padding()
                            .font(.system(size: 15, weight: .bold, design: .default))
                        Spacer()
                    }.background(Color("bgcolor"))
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
                        
                        Button("Excel(Ko)\niOS 내보내기") {
                            viewModel.exportExcel(osType: .ios, langType: .kor)
                        }.font(.title3).padding().disabled(!viewModel.isOnTranslate)
                        
                        Button("Excel(En)\niOS 내보내기") {
                            viewModel.exportExcel(osType: .ios, langType: .eng)
                        }.font(.title3).padding().disabled(!viewModel.isOnTranslate)
                    }
                }
                VStack {
                    HStack{
                        Text ("ANDROID")
                            .font(.body)
                            .foregroundColor(Color.black)
                            .padding()
                            .font(.system(size: 15, weight: .bold, design: .default))
                        Spacer()
                    }.background(Color("bgcolor"))
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
                        Button("Excel(Ko)\nAndroid 내보내기") {
                            viewModel.exportExcel(osType: .android, langType: .kor)
                        }.font(.title3).padding().disabled(!viewModel.isOnTranslate)
                        
                        Button("Excel(En)\nAndroid 내보내기") {
                            viewModel.exportExcel(osType: .android, langType: .eng)
                        }.font(.title3).padding().disabled(!viewModel.isOnTranslate)
                    }
                }
                
                Spacer()
                VStack{
                    Button("클립보드 복사") {
                        viewModel.copyClipboard()
                    }
                    .font(.title2)
                    .foregroundColor(Color.blue)
                    HStack {
                        Spacer()
                        Button("초기화") {
                            viewModel.celarExportText()
                        }
                        .font(.body)
                        .foregroundColor(Color.blue)
                    }
                    ScrollView {
                        VStack {
                            Text(viewModel.exportText)
                                .lineLimit(nil)
                                .foregroundColor(Color.black)
                                .font(.system(size: 8))
                                .padding()
                        }.frame(maxWidth: .infinity)
                    }
                }.background(Color.white).padding()
            }.padding(.vertical, 10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
