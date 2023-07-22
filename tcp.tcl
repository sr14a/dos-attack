set ns [new Simulator]

set tracefile [open tcp.tr w]
$ns trace-all $tracefile

set namfile [open tcp.nam w]
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

set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n1 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink

$ns connect $tcp $sink

set ftpstable [new Application/FTP]
$ftpstable attach-agent $tcp
$ftpstable set type_ FTP
$ftpstable set packet_size_ 1000
$ftpstable set rate_ 1mb

$ns at 0.1 "$ftpstable start"
$ns at 4.5 "$ftpstable stop"

$ns at 5.0 "finish"

$ns run
