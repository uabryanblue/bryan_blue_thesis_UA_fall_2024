"""Library to read MAX31855 via SPI

# Diego Herranz
# July 2013

"""

#from __future__ import division
import struct

class max31855():

    def __init__(self, spi_device):
        self.spi_device = spi_device

    def read_temperature(self):
        """Returns thermocouple temperature in Celsius degrees"""
        data = self.read_data()
        if data['fault']:
            raise Exception('Thermo-couple fault', 'Short-circuit to VCC: {0}'.format(data['short_circuit_vcc']),
                            'Short-circuit to GND: {0}'.format(data['short_circuit_gnd']), 'Open-circuit: {0}'.format(data['open_circuit']))  
        else:
            return data['temperature']


    def read_data(self):
        """Returns a dictionary with all the data that can be read from Max31855:
            - 'temperature': thermocouple temperature in Celsius degrees
            - 'fault'
            - 'internal_temperature': internal temperature in Celsius degrees
            - 'short_circuit_vcc': whether the thermocouple is short-circuited to VCC or not
            - 'short_circuit_gnd': whether the thermocouple is short-circuited to GND or not
            - 'open_circuit': whether the thermocouple is open-circuited or not"""

        
        # with open(self.spi_device, 'rb') as spi_fd:
            # data = spi_fd.read(4) # 32 bits.
        data = bytearray(4)
        self.spi_device.readinto(data)
        print("raw data")
        print(data)
        # print(data[0:2]) # 1st 2 bytes
        # print(data[3:4]) # 2nd 2 bytes
        # print(data[1])

        # print("unpacking")
        # print(struct.unpack(">h", data[0:2]))
        # print(struct.unpack(">h", data[0:2])[0])
        
                     
        #Thermo-couple temperature
        temperature = struct.unpack(">h", data[0:2])[0] >> 2;  # >h = signed short, big endian. 14 leftmost bits are data.    
        temperature = temperature / (2**2)  # Two binary decimal places

        #Internal temperature
        internal_temperature = struct.unpack(">h", data[2:4])[0] >> 4;  # >h = signed short, big endian. 12 leftmost bits are data.  
        internal_temperature = internal_temperature / (2**4)  # Four binary decimal places

        print(internal_temperature)

        #Fault        
        fault = struct.unpack("B", data[1:3])[0] & 0x01
        
        print(fault)

        #Short circuit VCC
        short_circuit_vcc = bool(struct.unpack("B", data[1:3])[0] & 0x04)

        #Short circuit GND
        short_circuit_gnd = bool(struct.unpack("B", data[1:3])[0] & 0x02)

        #Open circuit
        open_circuit = bool(struct.unpack("B", data[1:3])[0] & 0x01)            

        AllValues = {'temperature': temperature, 'fault': fault, 'internal_temperature': internal_temperature, 'short_circuit_vcc': short_circuit_vcc,
                'short_circuit_gnd': short_circuit_gnd, 'open_circuit': open_circuit}

        print(AllValues)

        return AllValues

        # return {'temperature': temperature, 'fault': fault, 'internal_temperature': internal_temperature, 'short_circuit_vcc': short_circuit_vcc,
            # 'short_circuit_gnd': short_circuit_gnd, 'open_circuit': open_circuit}
