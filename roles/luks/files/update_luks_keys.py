#!/usr/bin/env python3
import os
import sys
from subprocess import run

key_files = [os.path.join(sys.argv[1], path) for path in os.listdir(sys.argv[1])]
NUMBER_SLOTS = 8
slot_keys = {}
missing_keys = []
dummy_slot = None

def test_keys():
    slots = set(range(0, NUMBER_SLOTS))
    for key_file in key_files:
        for slot in slots:
            result = run(f'cryptsetup open --key-slot={slot} --test-passphrase /dev/disk/by-label/encrypted --key-file={key_file}', shell=True, capture_output=True)
            if result.returncode == 0:
                slot_keys[slot] = key_file
                if os.path.basename(key_file) != 'dummy':
                    slots.remove(slot)
                break
        else:
            if os.path.basename(key_file) != 'dummy':
                missing_keys.append(key_file)
    return slots

slots = test_keys()
working_key = list(slot_keys.values())[0]

if len(missing_keys) == 0 and len(slots) == (len(key_files) - 1):
    sys.exit(0)

# add keys that aren't already in the system
print(f'Adding {len(missing_keys)} keys...')
for key_file in missing_keys:
    run(f'cryptsetup luksAddKey /dev/disk/by-label/encrypted {key_file} --key-file={working_key}', shell=True, capture_output=True)

# remove now redundant keys
slots = test_keys()
if len(slots) < 8:
    print(f'Ensuring {len(slots)} slots are cleared')
    for slot in slots:
        run(f'cryptsetup luksKillSlot -q /dev/disk/by-label/encrypted {slot}', shell=True, capture_output=True)
