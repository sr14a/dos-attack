set ns [new Simulator]

set tracefile [open stable.tr w]
$ns trace-all $tracefile

set namfile [open stable.nam w]
$ns namtrace-all $namfile

proc finish {} {
global ns tracefile namfile
$ns flush-trace
close $tracefile
close $namfile
exec nam stable.nam &
exit 0
}

set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n1 $n2 5Mb 2ms DropTail

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

set null [new Agent/Null]
$ns attach-agent $n2 $null

$ns connect $udp $null

set cbrstable [new Application/Traffic/CBR]
$cbrstable attach-agent $udp

$ns at 0.1 "$cbrstable start"
$ns at 4.5 "$cbrstable stop"

$ns at 5.0 "finish"

$ns run
