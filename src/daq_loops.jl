function oneHz_data_file()
    # Write data to file
    ts = now()     # Generate current time stamp

    oneHz_df = DataFrame(
        Timestamp = ts, 
        Unixtime = datetime2unix(ts),
        Int64time = Dates.value(ts),
        LapseTime = @sprintf("%.3f",main_elapsed_time.value),
        state = stateTE1.value,
        T1 = parse_box("TE1ReadT1", missing),
        T2 = parse_box("TE1ReadT2", missing),
        V = currentV.value,
        TSet = get_gtk_property(gui["set_temp1"],:value, Float64)
    )

    oneHz_df |> CSV.write(path*"/"*outfile1, append=true)
end

function oneHz_generic_loop()
    t = main_elapsed_time.value
    set_gtk_property!(gui["Timer"],:text,Dates.format(now(), "HH:MM:SS"))
    
    set_gtk_property!(gui["meanV0"],:text,parse_missing1(mean(AIN0.value)*1000))
    set_gtk_property!(gui["meanV1"],:text,parse_missing1(mean(AIN1.value)))
   
    x = collect(range(0.0, stop=100.0, length=length(AIN0.value)))
    addseries!(x,AIN0.value[:],plotStream,gplotStream,1,true,true)
    #addseries!(x,AIN1.value[:],plotStream,gplotStream,2,true,true)

end    

function stream_loop()    
    data = map(_->labjackStream(HANDLE, caliInfo),1:40)
    Vx = vcat(data...)
    push!(currentV, mean(Vx))
    push!(theV,Vx[1:1000])

    ts = now()     # Generate current time stamp
    df = DataFrame(
        Timestamp = ts, 
        Unixtime = datetime2unix(ts),
        Int64time = Dates.value(ts),
        LapseTime = @sprintf("%.3f",main_elapsed_time.value),
        V = [theV.value],
    )
    #df |> CSV.write(path*"/"*outfile2, append=true)
end

function parse_box(s::String, default::Float64)
	x = get_gtk_property(gui[s], :text, String)
	y = try parse(Float64,x) catch; y = default end
end

# parse_box functions read a text box and returns the formatted result
function parse_box(s::String, default::Missing)
	x = get_gtk_property(gui[s], :text, String)
	y = try parse(Float64,x) catch; y = missing end
end

function parse_box(s::String)
	x = get_gtk_property(gui[s], :active_id, String)
	y = Symbol(x)
end

function parse_missing(N)
    str = try
        @sprintf("%.1f",N)
    catch
        "missing"
    end

    return str
end

function parse_missing1(N)
    str = try
        @sprintf("%.4f",N)
    catch
        "missing"
    end

    return str
end
