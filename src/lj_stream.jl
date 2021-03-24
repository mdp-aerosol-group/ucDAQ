using PyCall, DataStructures

AIN1 = Signal(CircularBuffer{Float64}(1000))
AIN0 = Signal(CircularBuffer{Float64}(1000))
done = false
 

function stream_run(d)
    sys = pyimport("sys")
    traceback = pyimport("traceback")
    
    MAX_REQUESTS = 4
    SCAN_FREQUENCY = 10000
    
    d.getCalibrationData()
    d.streamConfig(NumChannels=2, ChannelNumbers=(0, 1), ChannelOptions=(0, 0), SettlingFactor=1, ResolutionIndex=1, ScanFrequency=SCAN_FREQUENCY)
    d.streamStart()
    for r in d.streamData()
        append!(AIN0.value,r["AIN0"])
        append!(AIN1.value,r["AIN1"])
        sleep(0.001)
    end
end

