const _Gtk = Gtk.ShortNames
const black = RGBA(0, 0, 0, 1)
const red = RGBA(0.55, 0.0, 0, 1)
const mblue = RGBA(0.31, 0.58, 0.8, 1)
const mgrey = RGBA(0.4, 0.4, 0.4, 1)
const lpm = 1.666666e-5

const rampTE1 = Reactive.Signal(false)
const stateTE1 = Reactive.Signal(:Manual)
const currentV = Reactive.Signal(1.0)
const theV = Reactive.Signal(rand(100))
const bufferlength = 1200

const datestr = Dates.format(now(), "yyyymmdd") 
const path = datestr
const outfile1 = "RS232_"*datestr*".csv"
const outfile2 = "LJSTREAM_"*datestr*".csv"