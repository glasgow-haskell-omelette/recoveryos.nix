{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btop
    helix

    efibootmgr
    gdu

    ripgrep
    fd
    sd

    killall
    unzip
    file
    sbctl
    ethtool
    ldns

    zfs
    bcachefs-tools
    btrfs-progs
  ];

}
