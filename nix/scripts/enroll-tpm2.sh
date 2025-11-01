#!/usr/bin/env bash

echo "TPM2 Enrollment Script for LUKS"
echo "================================"
echo ""
echo "This will enroll your TPM2 chip to automatically unlock your LUKS encrypted disk."
echo "You'll need your LUKS password for this process."
echo ""

DEVICE="/dev/nvme1n1p2"

echo "Checking TPM2 availability..."
if ! systemd-cryptenroll --tpm2-device=list | grep -q "/dev/tpm"; then
    echo "ERROR: No TPM2 device found!"
    exit 1
fi

echo "Current tokens enrolled on $DEVICE:"
sudo systemd-cryptenroll --list-tokens $DEVICE || true

echo ""
echo "Enrolling TPM2 (this will bind to PCR 7 - Secure Boot state)..."
echo "You will be asked for your LUKS password:"

sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 $DEVICE

echo ""
echo "Enrollment complete! Your system should now unlock automatically on boot."
echo "Note: If you change Secure Boot settings or UEFI firmware, you may need to re-enroll."