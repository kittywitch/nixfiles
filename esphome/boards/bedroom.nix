{ config, target, ... }: {
  esphome = {
    platform = "esp8266";
    board = "d1_mini";
  };
  i2c = {
    sda = "D2";
    scl = "D1";
    scan = true;
  };
  sensor = [
    {
      platform = "dht";
      model = "DHT22";
      update_interval = "60s";
      pin = "D0";
      temperature = {
        name = "Bedroom Temperature";
        id = "bedtemp";
      };
      humidity = {
        name = "Bedroom Humidity";
        id = "bedhum";
      };
    }
    {
      platform = "ccs811";
      update_interval = "60s";
      address = "0x5A";
      temperature = "bedtemp";
      humidity = "bedhum";
      baseline = "0x2BBB";
      eco2 = {
        name = "Bedroom eCO2";
      };
      tvoc = {
        name = "Bedroom TVOC";
      };
    }
  ];
}
