$service = Get-WmiObject Win32_Service -Filter 'Name="wuauserv"' -ComputerName "." -Ea 0
if ($service) {
  if ($service.StartMode -ne "Disabled") {
    $result = $service.ChangeStartMode("Disabled").ReturnValue
    if($result) {
      "Failed to disable the 'wuauserv' service. The return value was $result."
    } else {
      "Success to disable the 'wuauserv' service"
    }

    if ($service.State -eq "Running") {
      $result = $service.StopService().ReturnValue
      if ($result) {
        "Failed to stop the 'wuauserv' service. The return value was $result."
      } else {
        "Success to stop the 'wuauserv' service."
      }
    }
  } else {
    "The 'wuauserv' service is already disabled."
  }
} else {
  "Failed to retrieve the service 'wuauserv'."
}
