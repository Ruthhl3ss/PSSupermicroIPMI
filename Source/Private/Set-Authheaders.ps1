function Set-AuthHeaders {
  <#
    .SYNOPSIS
    Sets the authentication headers for IPMI requests.
    .DESCRIPTION
    This function accepts an IP address and a PSCredential object and sets the necessary
    Basic Auth headers for subsequent Redfish API requests. The password is held as a
    SecureString and converted to plain text only at the moment of encoding, then
    immediately cleared from memory.
    .PARAMETER IPAddress
    The IP address of the IPMI interface.
    .PARAMETER Credential
    A PSCredential object containing the username and password. Use Get-Credential to
    create one interactively, or New-Object PSCredential for automation.
    .EXAMPLE
    Set-AuthHeaders -IPAddress "192.168.1.100" -Credential (Get-Credential)
    .NOTES
    The plain text password is only materialized in memory for the duration of the
    Base64 encoding operation and is immediately nulled afterward. Credentials are
    stored as a Basic Auth header in a script-scoped variable.
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, HelpMessage = "Please provide the IP address of the IPMI interface.")]
    [string]$IPAddress,

    [Parameter(Mandatory = $true, HelpMessage = "Provide credentials via Get-Credential.")]
    [PSCredential]$Credential
  )

  Process {
    Write-Verbose "Setting credentials for IPMI requests to $IPAddress with username $($Credential.UserName)"

    $script:baseUrl = "https://$IPAddress"
    $script:credential = $Credential

    Write-Verbose "Credentials stored successfully for $IPAddress."
  }
}
