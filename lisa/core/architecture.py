"""
    ELF architecture detection module.
"""

import logging.config

from lisa.config import logging_config

logging.config.dictConfig(logging_config)
log = logging.getLogger()


e_machine = {
    2: 'sparc',
    3: 'i386', 
    4: 'm68k',
    8: 'mips', 
    18: 'sparc32plus',
    20: 'ppc', 
    21: 'ppc64',
    22: 's390x',
    40: 'arm',
    41: 'alpha',
    42: 'sh4',
    43: 'sparc64',
    62: 'x86_64',
    183: 'aarch64' 
}


def get_architecture(file_path, script_arch=None):
    """Gets architecture and endianness information - needed
    for starting guest machine and choosing proper image.

    :param file_path: Path to file.
    :returns: Tuple (arch, bit, endian)
    """
    arch = None
    bit = None
    endian = None

    if script_arch is not None:
        if script_arch == 0:
            arch = 'x86_64'
            bit = '64'
            endian = 'little'
        elif script_arch == 1:
            arch = 'arm'
            bit = '32'
            endian = 'little'
        elif script_arch == 2:
            arch = 'mips'
            bit = '32'
            endian = 'big'
        elif script_arch == 3:
            arch = 'x86_64_perl'
            bit = '64'
            endian = 'little'
        else:
            arch = 'ppc'
            bit = '32'
            endian = 'little'
    else: 
        with open(file_path, 'rb') as f:
            header = f.read(32)

            # check ELF header 7xELF
            if header[:4] != b'\x7fELF':
                log.critical('Analyzed file has invalid ELF header.')
                return (None, None, None)

            # 32 vs 64 bit
            if header[4] == 1:
                bit = '32'
            elif header[4] == 2:
                bit = '64'

            # endianess
            if header[5] == 1:
                endian = 'little'
            elif header[5] == 2:
                endian = 'big'

            # processor architecture
            byte_arch = bytearray(header[18:20])
            byte_arch_code = int.from_bytes(byte_arch, endian)
            if byte_arch_code in e_machine:
                arch = e_machine[byte_arch_code]
    
    log.info(str(arch) + str(bit) + str(endian)+" ------------------------------------------------------")
    return (arch, bit, endian)
