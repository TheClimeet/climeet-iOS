import SwiftUI

struct FirstAppearModifer: ViewModifier {

    private let action: () async -> Void
    @State private var hasAppeared = false
    
    init(_ action: @escaping () async -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .task {
                guard !hasAppeared else { return }
                hasAppeared = true
                await action()
            }
    }
}
