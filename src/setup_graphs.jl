
function graph2(yaxis)
	plot = InspectDR.transientplot(yaxis, title="")
	InspectDR.overwritefont!(plot.layout, fontname="Arial", fontscale=1.0)
	plot.layout[:enable_legend] = true
	plot.layout[:enable_timestamp] = true
	plot.layout[:length_tickmajor] = 10
	plot.layout[:length_tickminor] = 6
	plot.layout[:format_xtick] = InspectDR.TickLabelStyle(UEXPONENT)
	plot.layout[:frame_data] =  InspectDR.AreaAttributes(
         line=InspectDR.line(style=:solid, color=black, width=0.5))
	plot.layout[:line_gridmajor] = InspectDR.LineStyle(:solid, Float64(0.75), 
													   RGBA(0, 0, 0, 1))

	plot.xext = InspectDR.PExtents1D()
	plot.xext_full = InspectDR.PExtents1D(0, 1000)

	a = plot.annotation
	a.xlabel = "Time (ms)"
	a.ylabels = ["Amplitude (V)"]

	return plot
end

style = :solid
plotStream = graph2(:lin)
plotStream.layout[:halloc_legend] = 110
mpStream,gplotStream = push_plot_to_gui!(plotStream, gui["StreamGraph"], wnd)
wfrm = add(plotStream, [0.0], [0.0], id="Vsig")
wfrm.line = line(color=black, width=2, style=style)
# wfrm = add(plotStream, [0.0], [0.0], id="Vamp")
# wfrm.line = line(color=red, width=2, style=style)
