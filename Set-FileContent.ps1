Function Set-FileContent() {
    <#
    .SYNOPSIS
    This function sets the content of a specified file with the provided content.

    .DESCRIPTION
    This function sets the content of a specified file with the provided content.
    It will write the content to the file, and if the file already exists,
    it will overwrite the existing content unless the Append switch is specified.
    It will throw an error if the specified path is a directory or if the file does not exist.

    .PARAMETER Path
    The path to the file whose content is to be set. It must be a valid file path
    and not a directory, otherwise an error will be thrown.
    .PARAMETER FileContent
    The content to be written to the file. It must be an array of strings.
    .PARAMETER Append
    A switch parameter that indicates whether to append the content to the file.
    If this switch is not specified, the file will be overwritten with the new content.

    .EXAMPLE
    Shows an example of how to use the function with sample input and expected output.
    Set-FileContent -Path "C:\example\file.txt" -FileContent @("Line 1", "Line 2") -Append
    .EXAMPLE
    Shows another example of how to use the function with different parameters.
    $fileContent = @("Line 1", "Line 2")
    Set-FileContent -Path "C:\example\file.txt" -FileContent $fileContent

    .NOTES
    Author: PowershellAdministrator
    Version: 1.0.3
    Changes: Added Begin, Process and End blocks to the function.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory=$true)][ValidateScript({
                $File = Get-Item $_ -ErrorAction SilentlyContinue
                If ($File.PSIsContainer)
                {
                    Throw [System.Management.Automation.ValidationMetadataException] "'${_}' is not a file, but a folder. Please enter a filename."
                }
                Else
                {
                    $True
                }
            })][string]$Path,
        #Warning: cannot be empty.
        [Parameter(Mandatory=$true)][string[]]$FileContent,
        [switch]$Append
    )

    Begin {
        Write-Verbose "Set-FileContent: Begin processing"
    }
    Process {
        Write-Verbose "Set-FileContent: Processing file '$Path'."
        If ($Append.IsPresent)
        {
            If ($PSCmdlet.ShouldProcess($Path, "Append"))
            {
                [System.IO.File]::AppendAllLines($Path, $FileContent)
            }
        }
        Else
        {
            If ($PSCmdlet.ShouldProcess($Path, "Create"))
            {
                #This will overwrite the file if it exists.
                [System.IO.File]::WriteAllLines($Path, $FileContent)
            }
        }
    }
    End {
        Write-Verbose "Set-FileContent: Finished processing"
    }
}
