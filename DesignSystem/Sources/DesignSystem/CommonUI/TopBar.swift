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
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            TopBar(
                title: self.title,
                titleFont: self.titleFont,
                titleColor: self.titleColor,
                backgroundColor: self.backgroundColor,
                padding: self.padding,
                leftItem: self.leftItem,
                rightItem: self.rightItem
            )
            .zIndex(999)
            content
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarHidden(true)
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
    
    var body: some View {
        HStack {
            self.leftItem?()
            Spacer()
            self.rightItem?()
        }
        .overlay(
            Text(self.title)
                .font(titleFont)
                .foregroundColor(self.titleColor)
                .frame(minWidth: 140, minHeight: 44)
        )
        .padding(padding.0, padding.1)
        .frame(height: 44)
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
        padding: (Edge.Set, CGFloat?) = (.horizontal, 18),
        @ViewBuilder leftItem: @escaping () -> Left,
        @ViewBuilder rightItem: @escaping () -> Right
    ) -> some View {
        modifier(
            TopBarModifier(
                title: title,
                titleFont: titleFont,
                titleColor: titleColor,
                backgroundColor: backgroundColor,
                padding: padding,
                leftItem: leftItem,
                rightItem: rightItem
            )
        )
    }
    
    public func backTopBar(
        title: String,
        backAction: @escaping () -> Void
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
                rightItem: { EmptyView() }
            )
        )
    }
}
#endif
