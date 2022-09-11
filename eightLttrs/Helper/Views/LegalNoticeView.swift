//
//  LegalNoticeView.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 11.09.22.
//

import SwiftUI

struct LegalNoticeView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        VStack(alignment: .leading) {
          Text("Angaben gemäß §5 TMG")
            .font(.title2)
            .fontWeight(.semibold)

          Text("Marvin Lee Kobert")
          Text("Schulstraße 19")
          Text("37434 Gieboldehausen")
        }

        VStack(alignment: .leading) {
          Text("Kontakt")
            .font(.title2)
            .fontWeight(.semibold)

          Text("marvin.kobert (at) posteo.de")
        }

        VStack(alignment: .leading) {
          Text("Haftung für Links")
            .font(.title2)
            .fontWeight(.semibold)

          Text("Diese App enthält Links zu externen Websites Dritter, auf deren Inhalte wir keinen Einfluss haben. Deshalb können wir für diese fremden Inhalte auch keine Gewähr übernehmen. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich. Die verlinkten Seiten wurden zum Zeitpunkt der Verlinkung, soweit möglich, auf mögliche Rechtsverstöße überprüft. Rechtswidrige Inhalte waren zum Zeitpunkt der Verlinkung nicht erkennbar. Eine permanente inhaltliche Kontrolle der verlinkten Seiten ist jedoch ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Links umgehend entfernen.")
        }

        VStack(alignment: .leading) {
          Text("Quelle")
            .font(.title2)
            .fontWeight(.semibold)

          Link("e-recht24.de", destination: URL(string: "https://www.e-recht24.de/impressum-generator.html")!)
        }

        Spacer()

        Text("Because this is only required by German law, this is only available in German.")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .padding(.horizontal)
    }
    .navigationTitle(L10n.LegalNoticeView.title)
  }
}

struct LegalNoticeView_Previews: PreviewProvider {
  static var previews: some View {
    LegalNoticeView()
  }
}
