
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
