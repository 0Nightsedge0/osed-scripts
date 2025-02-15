function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($isAdmin) {
        Write-Output "[+] The script is running with administrative privileges."
    } else {
        Write-Output "[!] Error: The script is not running with administrative privileges."
        exit
    }
}

function Get-CurrentUserName {
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $userName = $currentUser.Name.Split("\")[-1]
    return $userName
}

# Call the function to get the current username
$currentUserName = Get-CurrentUserName

Test-Admin

Set-ExecutionPolicy bypass -Force

$share_path = "\\tsclient\pykd_share"
$install_dir = "C:\Users\$($currentUserName)\Desktop\pykd_share\"
$pykd_whl = "pykd-0.3.4.15-cp39-none-win32.whl"

# create folders and copy the windbg extension to there
Write-Output "[+] Creating folders"
mkdir "C:\Plugins"
mkdir "$($install_dir)"
Write-Output "[+] copy pykd.dll"
copy "$($share_path)\pykd.dll" "C:\Plugins\pykd.dll"

# install whl
Write-Output "[+] installing pykd whl"
copy $share_path\$pykd_whl $install_dir
pip install $install_dir\$pykd_whl

# set env for windbg extension path
Write-Output "[+] set env for windbg extension path"
[environment]::SetEnvironmentVariable("_NT_DEBUGGER_EXTENSION_PATH", "C:\Plugins", "Machine")

Write-Output "[!] All done =]"