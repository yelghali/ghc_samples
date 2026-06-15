param(
    [Parameter(Mandatory = $true)]
    [string] $TemplateFile,

    [string] $ResourceGroupName,

    [string] $ParametersFile
)

$ErrorActionPreference = 'Stop'

az bicep decompile --file $TemplateFile --force

$bicepFile = [System.IO.Path]::ChangeExtension($TemplateFile, '.bicep')
az bicep build --file $bicepFile

if ($ResourceGroupName) {
    $whatIfArgs = @('deployment', 'group', 'what-if', '--resource-group', $ResourceGroupName, '--template-file', $bicepFile)
    if ($ParametersFile) {
        $whatIfArgs += @('--parameters', "@$ParametersFile")
    }
    az @whatIfArgs
}
