import SwiftUI
import SwiftUICharts

struct DenemeViewController: View {
    var body: some View{
        VStack{
            Spacer()
            
            BarChartView(
            data: ChartData(values: [
                ("den1",12),
                ("den1",7),
                ("den1",3),
                ("den1",22),
                ("den1",15)
            ]), title: "Deneme")
            Spacer()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View{
        DenemeViewController()
    }
}
