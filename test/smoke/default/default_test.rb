# # encoding: utf-8
# inspired by https://community.spiceworks.com/topic/1994651-check-for-missing-wannacry-patches-with-powershell

control 'WannaCry Vulnerability Check' do
  impact 1.0 
  title 'Tests for WannaCry Ransomware vulnerability.'
  desc '
   Checks Windows systems for hotfixes that patch against the WannaCry exploit.
   If this test fails, you should run Windows update ASAP.
  '

  script = <<-EOH
  $hotfixes = "KB4012212", "KB4012217", "KB4015551", "KB4019216", "KB4012216", "KB4015550", "KB4019215", "KB4013429", "KB4019472", "KB4015217", "KB4015438", "KB4016635"
  
  $computer = $ENV:COMPUTERNAME
      
  $hotfix = Get-HotFix -ComputerName $computer | 
      Where-Object {$hotfixes -contains $_.HotfixID} | 
      Select-Object -property "HotFixID"
  
  if($hotfix) {
      Write-Output "System OK. $computer has hotfix $hotfix installed."
      exit 0
  } else {
      Write-Output "***************************************************"
      Write-Output "* You are vulnerable to the WannaCry Exploit.     *"
      Write-Output "* Please run Windows Update to patch this system. *"
      Write-Output "***************************************************"
      exit 1
  }
  EOH
  
  describe powershell(script) do
    its('exit_status') { should eq 0 }
  end
end

control "SMB1 Protocol Check" do
  title "Control 'Microsoft network server: Set SMB1' to 'Disabled'"
  desc "Disable this policy setting to prevent the very out-of-date and insecure SMB1 protocol"
  impact 1.0
  describe registry_key("HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanmanServer\\Parameters") do
    it { should have_property "SMB1" }
  end
  describe registry_key("HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanmanServer\\Parameters") do
    its("SMB1") { should cmp == 0 }
  end
end
