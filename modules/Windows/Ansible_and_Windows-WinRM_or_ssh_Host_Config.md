# Ansible Windows WinRM or ssh Host Configuration Guide

## Part A: ### Option 1: WinRM Configuration
**Official guide** → https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html

#### Enable WinRM & Firewall Rules
Run this PowerShell script as Administrator to configure WinRM for Ansible:

```powershell
# Set execution policy for this session
Set-ExecutionPolicy Bypass -Scope Process -Force

# Enable TLS 1.2 for secure downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Download and execute the official Ansible WinRM configuration script
$scriptUrl = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$tempPath = "$env:TEMP\ConfigureRemotingForAnsible.ps1"

try {
    Write-Host "Downloading WinRM configuration script..." -ForegroundColor Green
    Invoke-WebRequest -Uri $scriptUrl -OutFile $tempPath -UseBasicParsing
    
    Write-Host "Executing WinRM configuration..." -ForegroundColor Green
    & $tempPath -Verbose
    
    Write-Host "WinRM configuration completed successfully!" -ForegroundColor Green
} catch {
    Write-Error "Failed to configure WinRM: $($_.Exception.Message)"
    exit 1
} finally {
    # Clean up the temporary script file
    if (Test-Path $tempPath) {
        Remove-Item $tempPath -Force
    }
}

# Optional: Configure additional WinRM settings for enhanced security
Write-Host "Configuring additional WinRM settings..." -ForegroundColor Yellow

# Set max memory per shell (in MB) - adjust as needed
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="512"}'

# Set max concurrent operations per user
winrm set winrm/config/service '@{MaxConcurrentOperationsPerUser="100"}'

# Enable credential delegation (use with caution in production)
# winrm set winrm/config/service/auth '@{CredSSP="true"}'

Write-Host "WinRM setup complete! You can now test connectivity with:" -ForegroundColor Cyan
Write-Host "winrm enumerate winrm/config/Listener" -ForegroundColor White
```

#### Alternative: Manual WinRM Configuration
If you prefer manual configuration or need custom settings:

```powershell
# Enable WinRM service
Enable-PSRemoting -Force

# Configure WinRM for basic authentication (less secure, use HTTPS in production)
Set-Item WSMan:\localhost\Service\Auth\Basic -Value $true
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $true

# Create HTTPS listener (recommended for production)
$cert = New-SelfSignedCertificate -DnsName $env:COMPUTERNAME -CertStoreLocation Cert:\LocalMachine\My
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"$env:COMPUTERNAME`";CertificateThumbprint=`"$($cert.Thumbprint)`"}"

# Configure firewall rules
New-NetFirewallRule -DisplayName "WinRM-HTTP" -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow
New-NetFirewallRule -DisplayName "WinRM-HTTPS" -Direction Inbound -Protocol TCP -LocalPort 5986 -Action Allow
```mation Platform) Setup

### 3. Automate Additional Tasks
- Deploy Private Automation Hub
- Configure Kerberos for Windows integration
- Backup or restore AAP components
- Install on RHEL or OpenShift

## Part B: Windows Host Setup
Windows machines can be managed by Ansible over WinRM (default) or SSH (Windows 10+ / Server 2019+).

### Option 1: WinRM Configuration
Official guide → https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html

Enable WinRM & Firewall Rules
```
Set-ExecutionPolicy Bypass -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$script = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
Invoke-WebRequest -Uri $script -OutFile "$env:TEMP\ConfigureRemotingForAnsible.ps1"
. "$env:TEMP\ConfigureRemotingForAnsible.ps1"
```

#### Create an Ansible Admin User
Create a dedicated user account for Ansible automation:

```powershell
# Create Ansible service account
$username = "ansible"
$password = "YourSecurePassword123!" # Change this to a strong password
$fullname = "Ansible Automation User"

# Convert password to secure string
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

try {
    # Create the user account
    New-LocalUser -Name $username -Password $securePassword -FullName $fullname -Description "Service account for Ansible automation" -PasswordNeverExpires
    
    # Add user to Administrators group
    Add-LocalGroupMember -Group "Administrators" -Member $username
    
    Write-Host "User '$username' created successfully and added to Administrators group" -ForegroundColor Green
    
    # Optional: Add to Remote Management Users group
    Add-LocalGroupMember -Group "Remote Management Users" -Member $username -ErrorAction SilentlyContinue
    
} catch {
    Write-Error "Failed to create user: $($_.Exception.Message)"
}
```

**Security Recommendations:**
- Use a strong, unique password
- Consider using a managed service account in domain environments
- Regularly rotate passwords
- Monitor account usage and access logs

#### Verify WinRM Configuration
Test your WinRM setup with these commands:

```cmd
# Check WinRM service status
sc query winrm

# List all WinRM listeners
winrm enumerate winrm/config/Listener

# Test WinRM connectivity locally
winrm identify -r:http://localhost:5985/wsman

# Check WinRM configuration
winrm get winrm/config

# Test authentication (replace with your ansible user)
winrm invoke test -r:http://localhost:5985/wsman -a:basic -u:ansible -p:YourPassword
```

#### Troubleshooting Common Issues

```powershell
# If WinRM service won't start
Get-Service WinRM | Restart-Service -Force

# Check Windows Firewall rules
Get-NetFirewallRule | Where-Object {$_.DisplayName -like "*WinRM*"} | Select-Object DisplayName, Enabled

# Verify certificate for HTTPS listener
Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -like "*$env:COMPUTERNAME*"}

# Reset WinRM configuration if needed (use with caution)
# winrm delete winrm/config/Listener?Address=*+Transport=HTTP
# winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
```

### Define Inventory Variables
```ini
[windows]
winhost ansible_host=192.168.1.100

[windows:vars]
ansible_connection=winrm
ansible_winrm_transport=basic
ansible_winrm_server_cert_validation=ignore
ansible_user=ansible
ansible_password=YourPassword
```

### Option 2: SSH Configuration
Guide → https://docs.ansible.com/ansible/latest/os_guide/windows_ssh.html

1. Install OpenSSH Server feature on Windows
2. Add your public key to `C:\Users\<user>\.ssh\authorized_keys`
3. Enable and start the sshd service

Use this inventory snippet:
```ini
[windows_ssh]
winhost ansible_host=192.168.1.100

[windows_ssh:vars]
ansible_connection=ssh
ansible_user=ansible
ansible_ssh_private_key_file=~/.ssh/id_rsa
```

## Part C: Managing Windows Hosts

Use the following Ansible modules once connectivity is established:

| Module | Description |
|--------|-------------|
| `win_ping` | Verify reachability |
| `win_service` | Start, stop, or query services |
| `win_package` | Install or remove software |
| `win_file` | Create/delete files or folders |
| `win_copy` | Copy files to Windows hosts |
| `win_shell` | Run PowerShell commands/scripts |
| `win_command` | Run simple commands (no shell) |

## Further Reading
- [Intro to Windows automation](https://docs.ansible.com/ansible/latest/os_guide/intro_windows.html)
- [Windows Authentication and Security](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#authentication-options)
- [Red Hat Ansible and Windows Server](https://www.redhat.com/en/blog/easy-automation-microsoft-windows-server-and-azure-ansible-automation-platform)