{
  networking.interfaces.enp10s0.wakeOnLan = {
    enable = true;
    policy = [
      "magic"
    ];
  };
}
