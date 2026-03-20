function New-AuthHeader {
  <#
    .SYNOPSIS
    Builds a Basic Auth header hashtable from the stored script-scoped credential.
    .DESCRIPTION
    Extracts the plain text password from the stored PSCredential only for the duration
    of the Base64 encoding operation, then immediately nulls it. The resulting header
    hashtable is returned to the caller and the plain text never persists in any
    script-scoped variable.
    .NOTES
    This is an internal helper. Call it inline when constructing each API request.
  #>
  [CmdletBinding()]
  [OutputType([hashtable])]
  param()

  if (-not $script:credential) {
    throw "No credentials set. Call Set-AuthHeaders first."
  }

  $plainPassword = $script:credential.GetNetworkCredential().Password
  $encoded = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($script:credential.UserName):$plainPassword"))
  $plainPassword = $null

  return @{ Authorization = "Basic $encoded" }
}
