//
//  Banner.swift
//  Climeet-iOS
//
//  Created by 권승용 on 9/24/24.
//

import SwiftUI

struct Banner: View {
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .aspectRatio(2.08, contentMode: .fit)
    }
}

#Preview {
    Banner()
}
