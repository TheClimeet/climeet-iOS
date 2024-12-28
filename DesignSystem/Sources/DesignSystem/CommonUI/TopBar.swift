import SwiftUI

#if os(iOS)
struct TopBarModifier<Left, Right>: ViewModifier where Left: View, Right: View {
    var title: String
    var titleFont: Font
    var titleColor: Color
    var backgroundColor: Color
    var padding: (Edge.Set, CGFloat?)
    var leftItem: (() -> Left)?
    var rightItem: (() -> Right)?
    var underLine: Bool
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            TopBar(
                title: self.title,
                titleFont: self.titleFont,
                titleColor: self.titleColor,
                backgroundColor: self.backgroundColor,
                padding: self.padding,
                leftItem: self.leftItem,
                rightItem: self.rightItem,
                underLine: self.underLine
            )
            .zIndex(999)
            content
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarBackButtonHidden()
    }
}

struct TopBar<Left, Right>: View where Left: View, Right: View {
    var title: String
    var titleFont: Font
    var titleColor: Color
    var backgroundColor: Color
    var padding: (Edge.Set, CGFloat?)
    var leftItem: (() -> Left)?
    var rightItem: (() -> Right)?
    var underLine: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                self.leftItem?()
                Spacer()
                self.rightItem?()
            }
            .overlay {
                Text(self.title)
                    .font(titleFont)
                    .foregroundColor(self.titleColor)
            }
            .padding(padding.0, padding.1)
            .padding(.top, 16)
            .padding(.bottom, 16)
            
            if underLine {
                Line()
                    .frame(height: 2)
                    .background(Color.white)
            }
        }
        .background(
            self.backgroundColor
                .ignoresSafeArea()
        )
    }
}

extension View {
    public func topBar<Left: View, Right: View>(
        title: String,
        titleFont: Font = .climeetFontTitle3(),
        titleColor: Color = .white,
        backgroundColor: Color = .text09,
        padding: (Edge.Set, CGFloat?) = (.horizontal, 16),
        @ViewBuilder leftItem: @escaping () -> Left,
        @ViewBuilder rightItem: @escaping () -> Right,
        underLine: Bool = false
    ) -> some View {
        modifier(
            TopBarModifier(
                title: title,
                titleFont: titleFont,
                titleColor: titleColor,
                backgroundColor: backgroundColor,
                padding: padding,
                leftItem: leftItem,
                rightItem: rightItem,
                underLine: underLine
            )
        )
    }
    
    public func backTopBar(
        title: String,
        backAction: @escaping () -> Void,
        underLine: Bool = false
    ) -> some View {
        modifier(
            TopBarModifier(
                title: title,
                titleFont: .climeetFontTitle3(),
                titleColor: .white,
                backgroundColor: .text09,
                padding: (.horizontal, 16),
                leftItem: {
                    Button {
                        backAction()
                    } label: {
                        Image(.icBack)
                    }
                },
                rightItem: { EmptyView() },
                underLine: underLine
            )
        )
    }
}
#endif
