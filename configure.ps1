# Reverse Windows RDP for GitHub Actions by PANCHO7532
# Based on the work of @nelsonjchen
# This script is executed when GitHub actions is initialized.
Write-Output "[INFO] Script started!"

# Download PageKite
Invoke-WebRequest -Uri https://pagekite.net/pk/pagekite.py -OutFile pagekite.py

# Enabling RDP Access
Write-Output "[INFO] Enabling RDP access..."
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0

# Authorize RDP Service from firewall
Write-Output "[INFO] Enabling firewall rules for RDP..."
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Change password to the one set in RDP_PASSWORD on repo settings
Write-Output "[INFO] Changing RDP password..."
Set-LocalUser -Name "runneradmin" -Password (ConvertTo-SecureString -AsPlainText "$env:RDP_PASSWORD" -Force)

# Start PageKite tunnel
Write-Output "[INFO] Starting PageKite tunnel..."
python pagekite.py 3389 rdp.freerdp.pagekite.me $env:PAGEKITE_SECRET

# Note: Replace 'rdp.freerdp.pagekite.me' with your actual registered subdomain.
Write-Output "[INFO] RDP tunnel is now active. You can connect using the provided PageKite URL."
