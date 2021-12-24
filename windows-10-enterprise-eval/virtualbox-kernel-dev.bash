#!/bin/bash

# VirtialBox folder, change as needed
VBFolder="/storage/VirtualBox/"

# Windows 10 ISO file path
isoPath=/storage/ISO/Windows_10/19043.928.210409-1212.21h1_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso

# Set the VM name
VM="Win10-KernelDev"

# Create a new VM of type Windows 10 x64
VBoxManage createvm --name $VM --ostype "Windows10_64" --register

# Create a new Disk
VBoxManage createhd --filename $VBFolder/$VM/$VM.vdi --size 100000

# Create the SATA Controller
VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI

# Attach the drive
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VBFolder/$VM/$VM.vdi

# Create an IDE controller for the CD-ROM
VBoxManage storagectl $VM --name "IDE Controller" --add ide

# Mount the OS ISO file
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$isoPath"

# Turn IOAPIC On
VBoxManage modifyvm $VM --ioapic on

# Set boot order
VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none

# Change the video card
VBoxManage modifyvm $VM --graphicscontroller vboxsvga

# Set RAM and VRAM
VBoxManage modifyvm $VM --memory 4096 --vram 128

# Unattended install settings
# Key from http://technet.microsoft.com/en-us/library/jj612867.aspx
VBoxManage unattended install $VM --iso=$isoPath --user=admin-user --full-user-name="admin-user" --password password --install-additions --time-zone=UTC --key="NPPR9-FWDCX-D2C8J-H872K-2YT43" --country=US --script-template="./Autounattend.xml"

# Add a network share to the scripts
VBoxManage sharedfolder add $VM -name "scripts" -hostpath "$PWD/scripts"

# VBoxManage startvm $VM --type headless
VBoxManage startvm $VM
