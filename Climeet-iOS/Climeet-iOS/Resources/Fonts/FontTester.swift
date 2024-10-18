//
//  test.swift
//  Climeet-iOS
//
//  Created by mac on 5/24/24.
//

import SwiftUI

struct FontTester: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("title1 : 클라이머스")
                .font(.climeetFontTitle1())
            Text("title2 : 클라이머스")
                .font(.climeetFontTitle2())
            Text("title3 : 클라이머스")
                .font(.climeetFontTitle3())
            Text("title3.5 : 클라이머스")
                .font(.climeetFontTitle3_5())
            Text("title4 : 클라이머스")
                .font(.climeetFontTitle4())
            Text("title4.5 : 클라이머스")
                .font(.climeetFontTitle4_5())
            Text("Paragraph1 : 클라이머스")
                .font(.climeetFontParagraph1())
            Text("Paragraph2 : 클라이머스")
                .font(.climeetFontParagraph2())
            Text("Paragraph3 : 클라이머스")
                .font(.climeetFontParagraph3())
            Text("Paragraph4 : 클라이머스")
                .font(.climeetFontParagraph4())
            Text("Paragraph5 : 클라이머스")
                .font(.climeetFontParagraph5())
            Text("Paragraph6 : 클라이머스")
                .font(.climeetFontCaptionText1())
            Text("CaptionText1 : 클라이머스")
                .font(.climeetFontCaptionText1())
            Text("CaptionText2 : 클라이머스")
                .font(.climeetFontCaptionText2())
            Text("CaptionText3 : 클라이머스")
                .font(.climeetFontCaptionText3())
        }
    }
}

#Preview {
    FontTester()
}
