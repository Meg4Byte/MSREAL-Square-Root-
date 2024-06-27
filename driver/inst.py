import sys
import subprocess

module_name = "sqrt3"
insmod_command = "sudo insmod sqrt3.ko"
chmod_command = "sudo chmod 777 /dev/sqrt3"

if len(sys.argv) != 1:
    print("Usage: python script.py")
    sys.exit(1)

# Load the kernel module

try:
    subprocess.run(insmod_command, shell=True, check=True)
    print("Loaded sqrt3.ko successfully")

except subprocess.CalledProcessError as e:
    print(f"Error loading {module_name}.ko: {e}")
    sys.exit(1)

# Set permissions on /dev/argument

try:
    subprocess.run(chmod_command, shell=True, check=True)
    print(f"Changed permissions on /dev/{module_name} successfully")

except subprocess.CalledProcessError as e:
    print(f"Error changing permissions on /dev/{module_name}: {e}")
    sys.exit(1)

