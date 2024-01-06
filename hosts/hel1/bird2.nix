{ ... }: {
  services.bird2 = {
    enable = true;
    config = ''
      router id 10.77.1.1;

      protocol kernel {
        metric 0;
        import none;
        learn;
        export all;
      }

      protocol device {
      }

      protocol direct {
      }

      protocol bgp hel1-vyos {
        local as 65077;
        neighbor 10.99.3.1 as 65099;
        import all;
        export all;
      }
    '';
  };
}
