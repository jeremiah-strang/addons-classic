import os
import re
import shutil
import stat
from zipfile import ZipFile


# Used to delete stubborn git files
def del_rw(action, name, exc):
    os.chmod(name, stat.S_IWRITE)
    os.remove(name)


# Change to the top level of the addon
os.chdir('..')

# Get new version number
with open(r'Tools\version', 'r') as version_file_handle:
    old_version = str(version_file_handle.read()).strip()
new_version = input('Previous version number: ' + old_version + '\nNew version number: ')
with open(r'Tools\version', 'w') as version_file_handle:
    version_file_handle.write(new_version)

# Open the toc file and replace the version
print("Replacing version in .toc file")
with open(r'WeaponSwingTimer.toc', 'r') as toc_file_handle:
    all_toc_lines = toc_file_handle.read()
new_all_toc_lines = re.sub('## Version: .*', '## Version: ' + new_version, all_toc_lines)
with open(r'WeaponSwingTimer.toc', 'w') as toc_file_handle:
    toc_file_handle.write(new_all_toc_lines)

# Open the core and replace the version
print("Replacing version in core file")
with open(r'WeaponSwingTimer_Core.lua', 'r') as core_file_handle:
    all_core_lines = core_file_handle.read()
new_all_core_lines = re.sub('Version.*by', 'Version ' + new_version + ' by', all_core_lines)
with open(r'WeaponSwingTimer_Core.lua', 'w') as core_file_handle:
    core_file_handle.write(new_all_core_lines)

# Create a copy of the development environment
print("Copying development environment for release")
release_dir_path = os.path.abspath(os.path.join("..", "..", "WeaponSwingTimer"))
shutil.copytree(os.getcwd(), release_dir_path)

# Remove the Tools dir from the release
print("Removing Tools directory from release")
shutil.rmtree(release_dir_path + "\Tools")

# Remove all git related items
print("Removing Git related items from release")
shutil.rmtree(release_dir_path + "\.git", onerror=del_rw)
os.remove(release_dir_path + "\.gitignore")

# Remove the Gimp files from Images
print("Removing Gimp files from release")
# TODO: When we actually have a gimp file in there

# Add everything to a .zip file
print("Creating .zip file")
zip_file_path = os.path.join("..", "..", "WeaponSwingTimer_V" + new_version + ".zip")
with ZipFile(zip_file_path, 'w') as zip:
    for dir_path, dirs, files in os.walk(release_dir_path):
        for file in files:
            zip.write(os.path.join(dir_path, file), os.path.join(dir_path[dir_path.find("WeaponSwingTimer"):], file))

# Move the zip file
shutil.move(zip_file_path, zip_file_path[3:])

# Remove the release dir
print("Cleaning up")
shutil.rmtree(release_dir_path)
