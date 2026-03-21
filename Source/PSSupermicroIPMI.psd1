@{
  RootModule        = 'PSSupermicroIPMI.psm1'
  ModuleVersion     = '1.0.2'
  GUID              = 'a4df2184-a450-41c2-8778-0437fe50a8a1'
  Author            = 'Niels Kok'
  CompanyName       = ''
  Description       = 'PowerShell module for Supermicro IPMI management'
  PowerShellVersion = '7.0'
  FunctionsToExport = @(
    'Get-SupermicroIPMIinfo',
    'Invoke-SupermicroIPMIAction'
  )
  CmdletsToExport   = @()
  VariablesToExport = @()
  AliasesToExport   = @()
  PrivateData       = @{
    PSData = @{
      Tags       = @('Supermicro', 'IPMI')
      ProjectUri = 'https://github.com/Ruthhl3ss/PSSupermicroIPMI'
      LicenseUri = ''
    }
  }
}