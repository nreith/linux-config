#!/bin/bash

#
# This script is for Xubuntu 19.10 Eoan Ermine to download and install XRDP+XORGXRDP via
# source.
#
# Adapted from https://github.com/microsoft/linux-vm-tools/blob/master/ubuntu/18.04/install.sh
#
# Major thanks to: http://c-nergy.be/blog/?p=11336 for the tips.
#

###############################################################################
# Use HWE kernel packages
#
HWE=""
#HWE="-hwe-19.10"

###############################################################################
# Update our machine to the latest code if we need to.
#

if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run with root privileges' >&2
    exit 1
fi

apt update && apt upgrade -y

if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required in order to proceed with the install." >&2
    echo "Please reboot and re-run this script to finish the install." >&2
    exit 1
fi

###############################################################################
# XRDP
#

# Install hv_kvp utils
apt install -y linux-tools-virtual${HWE}
apt install -y linux-cloud-tools-virtual${HWE}

# Install the xrdp service so we have the auto start behavior
apt install -y xrdp

systemctl stop xrdp
systemctl stop xrdp-sesman

# Configure the installed XRDP ini files.
# use vsock transport.
sed -i_orig -e 's/use_vsock=false/use_vsock=true/g' /etc/xrdp/xrdp.ini
# use rdp security.
sed -i_orig -e 's/security_layer=negotiate/security_layer=rdp/g' /etc/xrdp/xrdp.ini
# remove encryption validation.
sed -i_orig -e 's/crypt_level=high/crypt_level=none/g' /etc/xrdp/xrdp.ini
# disable bitmap compression since its local its much faster
sed -i_orig -e 's/bitmap_compression=true/bitmap_compression=false/g' /etc/xrdp/xrdp.ini

# Add script to setup the ubuntu session properly
if [ ! -e /etc/xrdp/startxubuntu.sh ]; then
cat >> /etc/xrdp/startxubuntu.sh << EOF
#!/bin/sh
export GNOME_SHELL_SESSION_MODE=xubuntu
export XDG_CURRENT_DESKTOP=XFCE
exec /etc/xrdp/startwm.sh
EOF
chmod a+x /etc/xrdp/startxubuntu.sh
fi

# use the script to setup the ubuntu session
sed -i_orig -e 's/startwm/startxubuntu/g' /etc/xrdp/sesman.ini

# rename the redirected drives to 'shared-drives'
sed -i -e 's/FuseMountName=thinclient_drives/FuseMountName=shared-drives/g' /etc/xrdp/sesman.ini

# Changed the allowed_users
sed -i_orig -e 's/allowed_users=console/allowed_users=anybody/g' /etc/X11/Xwrapper.config

# Blacklist the vmw module
if [ ! -e /etc/modprobe.d/blacklist_vmw_vsock_vmci_transport.conf ]; then
cat >> /etc/modprobe.d/blacklist_vmw_vsock_vmci_transport.conf <<EOF
blacklist vmw_vsock_vmci_transport
EOF
fi

#Ensure hv_sock gets loaded
if [ ! -e /etc/modules-load.d/hv_sock.conf ]; then
echo "hv_sock" > /etc/modules-load.d/hv_sock.conf
fi

# Configure the policy xrdp session
cat > /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla <<EOF
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF

# reconfigure the service
systemctl daemon-reload
systemctl start xrdp

# Setup hyperv services
cat >> /etc/initramfs-tools/modules <<EOF
hv_vmbus
hv_storvsc
hv_blkvsc
hv_netvsc
EOF

update-initramfs -u


#
# End XRDP
###############################################################################

echo "Install is complete."
echo ""
echo "Next step... IMPORTANT!"
echo ""
echo "1. Open Windows PowerShell as Administrator and run:"
echo "    Set-VM -VMName <your_vm_name> -EnhancedSessionTransportType HvSocket"
echo "2. Go to Hyper-V Manager and set hyper-v settings like so:"
echo "    - Hyper-V Settings --> Enhanced Session Mode Policy --> Allow enhanced session mode"
echo "    - Virtual Switch Manager --> Create External Network"
echo "    - VM --> Settings --> Security --> Secure Boot disabled"
echo "    - VM --> Settings --> Integration Services --> guest services"
echo "    - VM --> Settings --> Network Adapter + --> Advanced Features --> MAC Address Static"

echo "Reboot this Hyper-V VM to begin using XRDP."

