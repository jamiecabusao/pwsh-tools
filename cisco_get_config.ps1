# This script's purpose is to output a Cisco Catalyst device's running configuration into the command line.

param(
    
)

$Credential = Get-Credential
$SSHSession = New-SSHSession -ComputerName 10.1.4.253 -Port 22 -Credential $Credential -AcceptKey
$SSHStream = $SSHSession.Session.CreateShellStream("dumb", 0, 0,0, 0, 10000) #increased the buffer size to handle long returns from sh run/start

$SSHStream.Read() | Out-Null
# Retrieve the hostname of the device. Needed if using IP instead of host name to connect
$SSHStream.Write("terminal Length 0`n"); # remove pagination prompts
Sleep -Milliseconds 100
$SSHStream.Read() | Out-Null
$SSHStream.Write("show running-config" + "`n")
Sleep 10
$ResultRaw = $SSHStream.Read()

$ResultRaw
Remove-SSHSession -SSHSession $SSHSession
