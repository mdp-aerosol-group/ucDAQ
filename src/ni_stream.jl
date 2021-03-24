using PyCall

nidaqmx = pyimport("nidaqmx") 
nidaqmx.stream_writers = pyimport("nidaqmx.stream_writers")
np = pyimport("numpy")

function gen_wave(task, SignalFrequency, Amplitude, Bias)
    SamplesPerSignal = 500
    NumberOfCycles = 100000000
    Sample = collect(range(0.0,stop=SamplesPerSignal,length=SamplesPerSignal))
    w=2.0*π*SamplesPerSignal
    Signal= sin.(Sample.*w).*Amplitude .+ Bias
        
    task.timing.cfg_samp_clk_timing(
        rate=SignalFrequency*SamplesPerSignal,
        sample_mode=nidaqmx.constants.AcquisitionType.CONTINUOUS,
        samps_per_chan=SamplesPerSignal*NumberOfCycles)
    SignalStreamer = nidaqmx.stream_writers.AnalogSingleChannelWriter(
        task.out_stream, 
        auto_start=true
    )
    SignalStreamer.write_many_sample(Signal)
    return nothing
end

function open_task()
    task = nidaqmx.Task()
    task.ao_channels.add_ao_voltage_chan("cDAQ1Mod1/ao0")
    #task.out_stream.regen_mode = nidaqmx.constants.RegenerationMode.DONT_ALLOW_REGENERATION
    return task
end

function close(task)
    task.stop()
    task.close()
end