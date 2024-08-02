using System;
using System.Drawing;
using ScottPlot;
using FuMEsWrapper;

namespace FuMEsWrapperCall
{
    class Program
    {
        static void Main()
        {
            var inputs = FuMEsInputsSample.New();

            var model = new FuMEsModel(inputs);

            PlotResults("sample.png", model.Outputs);

            Console.ReadLine();
        }

        static void PlotResults(string saveAs, FuMEsOutputs outputs)
        {
            var p0 = new Plot(300, 250);
            var p1 = new Plot(300, 250);
            var p2 = new Plot(300, 250);
            var p3 = new Plot(300, 250);
            var p4 = new Plot(300, 250);
            var p5 = new Plot(300, 250);

            p0.Title("Dew point");
            // TODO add SP
            p0.AddScatter(outputs.tk, outputs.x0, markerShape: MarkerShape.none, lineWidth: 2, label: "PV");
            p0.Legend(location: Alignment.LowerRight);

            p1.Title("Hydrogen content");
            // TODO add limits
            p1.AddScatter(outputs.tk, outputs.x1, markerShape: MarkerShape.none, lineWidth: 2, label: "PV");
            p1.Legend(location: Alignment.LowerRight);

            p2.Title("Carbon monoxide content");
            // TODO add limit max
            p2.AddScatter(outputs.tk, outputs.x2, markerShape: MarkerShape.none, lineWidth: 2, label: "PV");
            p2.Legend(location: Alignment.LowerRight);

            p3.Title("Steam controls");
            p3.AddScatter(outputs.tk, outputs.vk, markerShape: MarkerShape.none, lineWidth: 2, label: "SP");
            p3.AddScatter(outputs.tk, outputs.uk, markerShape: MarkerShape.none, lineWidth: 2, label: "PV");
            p3.Legend(location: Alignment.LowerRight);

            p4.Title("Flow contribution");
            p4.AddScatter(outputs.tk, outputs.rk, markerShape: MarkerShape.none, lineWidth: 2, label: "SP");
            p4.Legend(location: Alignment.LowerRight);

            p5.Title("Total flow");
            p5.AddScatter(outputs.tk, outputs.qk, markerShape: MarkerShape.none, lineWidth: 2, label: "SP");
            p5.Legend(location: Alignment.LowerRight);

            Bitmap bmp0 = p0.Render();
            Bitmap bmp1 = p1.Render();
            Bitmap bmp2 = p2.Render();
            Bitmap bmp3 = p3.Render();
            Bitmap bmp4 = p4.Render();
            Bitmap bmp5 = p5.Render();

            using (var bmp = new Bitmap(900, 500))
            using (var gfx = Graphics.FromImage(bmp))
            {
                gfx.DrawImage(bmp0,   0,   0);
                gfx.DrawImage(bmp1, 300,   0);
                gfx.DrawImage(bmp2, 600,   0);
                gfx.DrawImage(bmp3,   0, 250);
                gfx.DrawImage(bmp4, 300, 250);
                gfx.DrawImage(bmp5, 600, 250);
                bmp.Save(saveAs);
            }
        }
    }
}
