//
//  DateTimePickerView.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/11/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct DateTimePickerView: View {
    @Bindable var store: StoreOf<DateTimePickerReducer>
    
    /// DateTimePickerView에서만 사용됨
    private let buttonAndDivideLineColor = Color(
        red: 103 / 255,
        green: 103 / 255,
        blue: 103 / 255
    )
    
    var body: some View {
        if store.sheetType == .datePicker {
            VStack {
                HStack {
                    Text("날짜선택")
                        .font(.climeetFontTitle3())
                        .foregroundColor(Color.levelWhite)
                    Spacer()
                    Button(action: {
                        store.send(.cancelButtonTapped)
                    }) {
                        Image(uiImage: UIImage(named: "datepicker_close") ?? UIImage())
                    }
                }
                .padding(.leading, 13.5)
                .padding(.trailing, 9.5)
                .padding(.top, 54)
                
                VStack {
                    Button(action: {
                        store.send(.todayButtonTapped)
                    }, label: {
                        Text("오늘")
                            .font(.climeetFontTitle4())
                            .foregroundColor(
                                store.isSelectedDateToday ?
                                Color.starNotFilled
                                : Color.levelBlack
                            )
                    })
                    .frame(height: 41)
                    .frame(maxWidth: .infinity)
                    .background(
                        store.isSelectedDateToday ? self.buttonAndDivideLineColor
                        : Color.climeetMain
                    )
                    .cornerRadius(5)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(self.buttonAndDivideLineColor)
                        .padding(.top, 10)
                    
                    DateTimePicker(
                        selection: $store.selectedDate.sending(\.dateChanged),
                        textColor: UIColor(.starNotFilled),
                        pickerMode: .date
                    )
                    .frame(maxWidth: .infinity)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(self.buttonAndDivideLineColor)
                        .padding(.top, -10)
                    
                    Spacer()
                }
                .padding(.leading, 5.5)
                .padding(.trailing, 12.5)
                
                HStack(spacing: 10) {
                    Button(action: {
                        store.send(.cancelButtonTapped)
                    }, label: {
                        Text("취소")
                            .font(.climeetFontTitle4_5())
                            .foregroundColor(Color.levelWhite)
                    })
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(self.buttonAndDivideLineColor)
                    .cornerRadius(5)
                    
                    Button(action: {
                        store.send(.dateConfirmButtonTapped)
                    }, label: {
                        Text("확인")
                            .font(.climeetFontTitle4_5())
                            .foregroundColor(Color.levelBlack)
                    })
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(Color.climeetMain)
                    .cornerRadius(5)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 21.5)
            .background(Color.text09)
            
        } else {
            VStack {
                HStack {
                    Text("시간선택")
                        .font(.climeetFontTitle3())
                        .foregroundColor(Color.levelWhite)
                    Spacer()
                    Button {
                        store.send(.cancelButtonTapped)
                    } label: {
                        Image(uiImage: UIImage(named: "datepicker_close") ?? UIImage())
                    }
                }
                .padding(.leading, 13.5)
                .padding(.trailing, 9.5)
                .padding(.top, 54)
                
                VStack {
                    HStack(spacing: 15) {
                        Button(action: {
                            store.send(.startTimeButtonTapped)
                        }, label: {
                            VStack(spacing: 4) {
                                Text("시작")
                                    .font(.climeetFontTitle4())
                                    .foregroundColor(Color.levelWhite)
                                Text(
                                    DateFormatter.koreanHourMinuteFormatter.string(
                                        from: store.selectedStartTime
                                    )
                                )
                                .font(.climeetFontParagraph2())
                                .foregroundColor(
                                    store.isStartPickerActive ?
                                    Color.climeetMain : Color.levelWhite
                                )
                            }
                        })
                        .frame(height: 75)
                        .frame(maxWidth: .infinity)
                        .background(Color.text07)
                        .cornerRadius(15)
                        
                        Button(action: {
                            store.send(.endTimeButtonTapped)
                        }, label: {
                            VStack(spacing: 4) {
                                Text("종료")
                                    .font(.climeetFontTitle4())
                                    .foregroundColor(Color.levelWhite)
                                Text(
                                    DateFormatter.koreanHourMinuteFormatter.string(
                                        from: store.selectedEndTime
                                    )
                                )
                                .font(.climeetFontParagraph2())
                                .foregroundColor(
                                    !store.isStartPickerActive ?
                                    Color.climeetMain : Color.levelWhite
                                )
                            }
                        })
                        .frame(height: 75)
                        .frame(maxWidth: .infinity)
                        .background(Color.text07)
                        .cornerRadius(15)
                    }
                    .padding(.horizontal, 13.5)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(self.buttonAndDivideLineColor)
                        .padding(.top, 10)
                    
                    DateTimePicker(
                        selection:
                            store.isStartPickerActive ?
                        $store.selectedStartTime.sending(\.timeChanged)
                        : $store.selectedEndTime.sending(\.timeChanged),
                        textColor: UIColor(.starNotFilled),
                        pickerMode: .time
                    )
                    .frame(maxWidth: .infinity)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(self.buttonAndDivideLineColor)
                        .padding(.top, 10)
                }
                
                HStack(spacing: 10) {
                    Button(action: {
                        store.send(.cancelButtonTapped)
                    }, label: {
                        Text("취소")
                            .font(.climeetFontTitle4())
                            .foregroundColor(Color.levelWhite)
                    })
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(Color.text07)
                    .cornerRadius(5)
                    
                    Button(action: {
                        store.send(.timeConfirmButtonTapped)
                    }, label: {
                        Text("확인")
                            .font(.climeetFontTitle4())
                            .foregroundColor(Color.levelBlack)
                    })
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(Color.climeetMain)
                    .cornerRadius(5)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 21.5)
            .background(Color.text09)
        }
    }
}

#Preview {
    DateTimePickerView(store: Store(initialState: DateTimePickerReducer.State(sheetType: .datePicker), reducer: {
        DateTimePickerReducer()
    }))
}
