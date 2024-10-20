import SwiftUI

public struct TooltipView<Content: View>: View {
    let alignment: Edge
    @Binding var isVisible: Bool
    let arrowOffset: CGFloat = 4
    var xPadding: CGFloat = 0
    var yPadding: CGFloat = 0
    
    let content: () -> Content
    
    public init(alignment: Edge, isVisible: Binding<Bool>, xPadding: CGFloat, yPadding: CGFloat, content: @escaping () -> Content) {
        self.alignment = alignment
        self._isVisible = isVisible
        self.xPadding = xPadding
        self.yPadding = yPadding
        self.content = content
    }

    private var oppositeAlignment: Alignment {
        let result: Alignment
        switch alignment {
        case .top: result = .bottom
        case .bottom: result = .top
        case .leading: result = .trailing
        case .trailing: result = .leading
        }
        return result
    }

    private var theHint: some View {
        content()
            .padding(9.2)
            .background(.white)
            .foregroundColor(.white)
            .cornerRadius(8)
            .background(alignment: oppositeAlignment) {
                Rectangle()
                    .fill(.white)
                    .frame(width: 22, height: 22)
                    .rotationEffect(.degrees(45))
                    .offset(x: alignment == .leading ? arrowOffset : 0)
                    .offset(x: alignment == .trailing ? -arrowOffset : 0)
                    .offset(y: alignment == .top ? arrowOffset : 0)
                    .offset(y: alignment == .bottom ? -arrowOffset : 0)
            }
            .padding(9.2)
            .fixedSize()
    }

    public var body: some View {
        if isVisible {
            GeometryReader { proxy1 in
                theHint
                    .hidden()
                    .overlay {
                        GeometryReader { proxy2 in
                            theHint
                                .drawingGroup()
                                .offset(
                                    x: -(proxy2.size.width / 2 - xPadding) + (proxy1.size.width / 2),
                                    y: -(proxy2.size.height / 2 - yPadding) + (proxy1.size.height / 2)
                                )
                                .offset(x: alignment == .leading ? (-proxy2.size.width / 2) - (proxy1.size.width / 2) : 0)
                                .offset(x: alignment == .trailing ? (proxy2.size.width / 2) + (proxy1.size.width / 2) : 0)
                                .offset(y: alignment == .top ? (-proxy2.size.height / 2) - (proxy1.size.height / 2) : 0)
                                .offset(y: alignment == .bottom ? (proxy2.size.height / 2) + (proxy1.size.height / 2) : 0)
                        }
                    }
            }
            .onTapGesture {
                withAnimation {
                    isVisible.toggle()
                }
            }
        }
    }
}
