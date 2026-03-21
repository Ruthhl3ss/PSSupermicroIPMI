Function Invoke-SupermicroIPMIAction {
  <#
  .SYNOPSIS
  Performs an action on a Supermicro system via the IPMI Redfish interface.
  .DESCRIPTION
  This function performs a specified action on a Supermicro system by sending a Reset action via the Redfish API.
  By default it sends ResetType 'On' to start a powered-off system. Optionally a different
  ResetType can be specified (e.g. ForceRestart, GracefulRestart).
  Authentication headers must be set prior to calling this function, or the user will be prompted for credentials.
  .PARAMETER ResetType
  The type of reset/power action to perform. Valid values are:
    On              - Powers on the system (default)
    ForceRestart    - Immediately resets the system
    GracefulRestart - Requests the OS to perform a graceful restart
    ForceOff        - Immediately powers off the system
    GracefulShutdown - Requests the OS to shut down gracefully
  .EXAMPLE
  Invoke-SupermicroIPMIAction
  Powers on the system using the default ResetType 'On'.
  .EXAMPLE
  Invoke-SupermicroIPMIAction -ResetType GracefulRestart
  Requests the system to perform a graceful restart.
  .NOTES
  This function relies on the Set-AuthHeaders function to set the necessary authentication headers
  for IPMI requests. The Redfish endpoint used is POST /redfish/v1/Systems/1/Actions/ComputerSystem.Reset.
  #>

  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory = $false)]
    [ValidateSet("On", "ForceRestart", "GracefulRestart", "ForceOff", "GracefulShutdown")]
    [string]$ResetType = "On"
  )

  begin {
    if (-not $script:credential) {
      Write-Verbose "Authentication headers not set. Prompting for credentials."
      $ipAddress = Read-Host "Enter the IP address of the IPMI interface"
      $credential = Get-Credential -Message "Enter IPMI credentials" -UserName "ADMIN"
      try {
        Set-AuthHeaders -IPAddress $ipAddress -Credential $credential
        Write-Verbose "Authentication headers set successfully."
      }
      catch {
        throw "Failed to set authentication headers: $_"
      }
    }
    else {
      Write-Verbose "Authentication headers already set. Using existing headers."
    }
  }

  Process {
    Write-Verbose "Sending ResetType '$ResetType' to system at $($script:baseUrl)."

    $body = @{
      ResetType = $ResetType
    } | ConvertTo-Json

    if ($PSCmdlet.ShouldProcess($script:baseUrl, "Perform system action '$ResetType'")) {
      try {
        Invoke-RestMethod -Uri "$script:baseUrl/redfish/v1/Systems/1/Actions/ComputerSystem.Reset" `
          -Method Post `
          -Headers (New-AuthHeader) `
          -Body $body `
          -ContentType "application/json" `
          -SkipCertificateCheck `
          -ErrorAction Stop
        Write-Verbose "System action '$ResetType' sent successfully."
      }
      catch {
        throw "Failed to perform system action '$ResetType': $_"
      }
    }
  }
}
