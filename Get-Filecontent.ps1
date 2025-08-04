Function Get-FileContent() {
    <#
    .SYNOPSIS
    This function retrieves the content of a specified file and returns it as an array of strings.

    .DESCRIPTION
    This function retrieves the content of a specified file and returns it as an array of strings.
    It retrieves the content of a specified file and returns it as an array of strings.
    It will throw an error if the specified path is a directory or if the file does not exist.

    .PARAMETER Path
    The path to the file whose content is to be read. It must be a valid file path
    and not a directory, otherwise an error will be thrown.

    .EXAMPLE
    Shows an example of how to use the function with sample input and expected output.
    Get-FileContent -Path "C:\example\file.txt"
    .EXAMPLE
    Shows another example of how to use the function with different parameters.
    $fileContent = Get-FileContent -Path "C:\example\file.txt"
    Write-Output $fileContent

    .NOTES
    Author: PowershellAdministrator
    Version: 1.0.2
    Changes: Added Begin, Process and End blocks to the function.

    #>
    [CmdletBinding()]
    [OutputType([String[]])]
    Param (
        [Parameter(Mandatory=$true)][ValidateScript({
                Try
                {
                    $File = Get-Item $_ -ErrorAction Stop
                }
                Catch [System.Management.Automation.ItemNotFoundException]
                {
                    # Can add a more customised error message after ${_}
                    Throw [System.Management.Automation.ItemNotFoundException] "${_}"
                }
                If ($File.PSIsContainer)
                {
                    Throw [System.Management.Automation.ValidationMetadataException] "'${_}' is not a file, but a folder. Please enter a filename."
                }
                Else
                {
                    $True
                }
            })][string]$Path
    )

    Begin {
        Write-Verbose "Get-FileContent: Begin processing"
    }
    Process {
        Write-Verbose "Get-FileContent: Processing file '$Path'."
        $FileContent = [System.IO.File]::ReadAllLines($Path)
        Return $FileContent
    }
    End {
        Write-Verbose "Get-FileContent: Finished processing"
    }
}
