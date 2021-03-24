using Gtk
using InspectDR
using Reactive
using Colors
using DataFrames    
using Printf
using Dates
using CSV
using FileIO    
using LibSerialPort
using Interpolations
using Statistics
using PyCall
using NumericIO

(@isdefined wnd) && destroy(wnd)
gui = GtkBuilder(filename=pwd()*"/gui.glade")  # Load GUI
wnd = gui["mainWindow"]

include("constants.jl")               # Reactive Signals and global constants
include("gtk_graphs.jl")              # push graphs to the UI#
include("setup_graphs.jl")            # Initialize graphs 
include("daq_loops.jl")               # Contains DAQ loops               
include("lj_stream.jl")               # Contains DAQ loops               
include("ni_stream.jl")               # Contains DAQ loops               

Gtk.showall(wnd)                      # Show GUI

# Generate signals
oneHz = fps(1.0*1.0015272)            # 1  Hz time
imLp  = every(0.1)                    # 1  Hz time

main_elapsed_time = foldp(+, 0.0, oneHz)  # Main timer

# Instantiate parallel  1 Hz Loops and start 10 Hz loop
function main()
    @async oneHz_generic_loop()      # Generic 1 Hz DAQ (TE)
end

task = open_task()

fBox = gui["fBox"]
aBox = gui["aBox"]
bBox = gui["bBox"]

SignalFrequency = get_gtk_property(fBox,"value",Float64)
Amplitude = get_gtk_property(aBox,"value",Float64)
Bias = get_gtk_property(bBox,"value",Float64)

signal_connect(fBox, "changed") do widget, others...
    SignalFrequency = get_gtk_property(fBox,"value",Float64)
    Amplitude = get_gtk_property(aBox,"value",Float64)
    Bias = get_gtk_property(bBox,"value",Float64)
    gen_wave(task, SignalFrequency, Amplitude/1000.0, Bias/1000.0)
end

signal_connect(aBox, "changed") do widget, others...
    SignalFrequency = get_gtk_property(fBox,"value",Float64)
    Amplitude = get_gtk_property(aBox,"value",Float64)
    Bias = get_gtk_property(bBox,"value",Float64)
    gen_wave(task, SignalFrequency, Amplitude/1000.0, Bias/1000.0)
end

signal_connect(bBox, "changed") do widget, others...
    SignalFrequency = get_gtk_property(fBox,"value",Float64)
    Amplitude = get_gtk_property(aBox,"value",Float64)
    Bias = get_gtk_property(bBox,"value",Float64)
    gen_wave(task, SignalFrequency, Amplitude/1000.0, Bias/1000.0)
end

gen_wave(task, SignalFrequency, Amplitude/1000.0, Bias/1000.0)

#close(task)

MainLoop = map(_ -> main(), oneHz)                   # Run Master Loop

u6 = pyimport("u6")
d = u6.U6()
d.streamStop()

@async stream_run(d)


:DONE		