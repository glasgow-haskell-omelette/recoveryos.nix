{
  pkgs,
  modulesPath,
  lib,
  config,
  ...
}:
{
  imports = [
    # ./gui.nix
    ./tools.nix
    (modulesPath + "/profiles/perlless.nix")
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
  ];
  system.forbiddenDependenciesRegexes = lib.mkForce [ ];

  users.users.live = {
    isNormalUser = true;
    password = "live";
    linger = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  networking.timeServers = [ "nts.netnod.se" ];
  networking.nameservers = [
    "76.76.2.11#p0.freedns.controld.com"
    "8.8.8.8#dns.google"
  ];

  services.resolved = {
    enable = true;
    llmnr = "false";
    dnsovertls = "true";
    domains = [ "~." ];
  };

  networking.networkmanager = {
    enable = true;
    ethernet.macAddress = "stable";
    dns = "systemd-resolved";

    wifi.macAddress = "stable-ssid";
    wifi.backend = "iwd";
    wifi.powersave = true;

    settings.connectivity.enabled = false;
    connectionConfig = {
      "ipv6.dhcp-duid" = "stable-uuid";
      "ipv6.addr-gen-mode" = "stable-privacy";
      "ipv4.dhcp-send-hostname" = false;
      "ipv6.dhcp-send-hostname" = false;
    };
  };

  networking.wireless.iwd = {
    enable = true;
    settings.General.AddressRandomization = "network";
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_6_17;
    supportedFilesystems = [
      "zfs"
      "bcachefs"
      "btrfs"
    ];
  };

  isoImage = {
    makeEfiBootable = true;
    makeUsbBootable = true;
  };

  services.kmscon = {
    enable = true;
    useXkbConfig = true;
    autologinUser = "live";
    fonts = [
      {
        name = "JetBrains Mono";
        package = pkgs.jetbrains-mono;
      }
    ];
  };

  services.xserver.xkb = {
    layout = "us(workman),ru";
    options = "grp:caps_toggle";
  };

  swapDevices = lib.mkImageMediaOverride [ ];
  fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;
  boot.initrd.luks.devices = lib.mkImageMediaOverride { };

  networking.hostId = "bf640240";
  services.dbus.implementation = "broker";

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.cpu.amd.updateMicrocode = true;

  services.logrotate.enable = false;
  boot.swraid.enable = true;

  system.stateVersion = lib.mkDefault lib.trivial.release;
}
