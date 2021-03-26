using GRUtils

Aup = 6000
Adown = 3000

Bias = 0

SamplesPerSignal = 500
NumberOfCycles = 100000000
Sample = range(0.0,stop=SamplesPerSignal,length=SamplesPerSignal) |> collect
w=2.0*π*SamplesPerSignal

left = SamplesPerSignal/((Aup + Adown)/Adown) |> floor |> Int
right = SamplesPerSignal - left

function gen_signal(Sample)
	if Sample <= left
		return sin(Sample*pi/left)*Aup + Bias
	else
		return -sin((Sample-left)*pi/right)*Adown + Bias
	end
end

Signal = map(gen_signal, Sample)

using NumericalIntegration
integrate(Sample, Signal) |> println

plot(Sample, Signal, xlog = false)

