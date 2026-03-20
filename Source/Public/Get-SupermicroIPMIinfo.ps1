Function Get-SupermicroIPMIinfo {
  <#
  .SYNOPSIS
  Retrieves system information from a Supermicro IPMI interface.
  .DESCRIPTION
  This function checks if authentication headers are set and prompts the user for credentials if they are not. It then makes a REST API call to the IPMI interface to retrieve system information.
  .PARAMETER None
  .EXAMPLE
  Get-SupermicroIPMIinfo
  .NOTES
  This function relies on the Set-AuthHeaders function to set the necessary authentication headers for IPMI requests. If the headers are not set, it will prompt the user for the IP address, username, and password. The retrieved system information is returned as a PowerShell object. Caution! The password is handled in memory and should be managed securely. Always ensure that the password is not exposed in logs or memory dumps.
  #>

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
    Write-Verbose "Retrieving system information from IPMI interface at $($script:baseUrl)."

    try {
      Invoke-RestMethod -Uri "$script:baseUrl/redfish/v1/Systems/1" `
        -Headers (New-AuthHeader) `
        -SkipCertificateCheck
    }
    catch {
      throw "Failed to retrieve system information: $_"
    }

  }
}
