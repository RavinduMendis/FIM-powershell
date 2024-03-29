# File Integrity Monitoring Tool

The File Integrity Monitoring (FIM) tool is a PowerShell script designed to monitor and track changes within a specified directory, ensuring the integrity and security of files. The tool provides the ability to create a baseline of file hashes and subsequently monitor these files for any modifications, additions, or deletions.
# Functionality
## •	Hashing Function:
The tool utilizes a hashing function to generate unique checksums for each file in the specified directory. The default hashing algorithm is SHA-512, but users have the flexibility to choose a different algorithm.

![image](https://github.com/RavinduMendis/FIM-powershell/assets/53220147/5f184fb7-1f4c-4ef6-86e8-9c7357e281a8)

## •	Baseline Deletion:
Before creating a new baseline, the tool checks if an existing baseline file ('baseline.txt') exists. If it does, the script deletes the old baseline to ensure a fresh start.

![image](https://github.com/RavinduMendis/FIM-powershell/assets/53220147/60747928-4736-493a-862b-0ffe93044bf2)


## •	Logging Function:
The script includes a logging function to report file changes with timestamps. Messages are displayed in different colors based on the type of change - green for creations, yellow for modifications, and red for deletions.

![image](https://github.com/RavinduMendis/FIM-powershell/assets/53220147/a59308c3-833e-4947-8a63-926f6c9925b0)


# Usage
•	Initialization: Upon execution, the user is prompted to choose between two options:
•	A: Collect a new baseline.
•	B: Begin monitoring files with the saved baseline.
•	Baseline Collection (Option A):
•	The tool recursively scans all files in the specified directory, computes their hash values, and appends the file path and hash to 'baseline.txt'.
•	The selected hashing algorithm and a summary of the algorithm used are displayed.
•	File Monitoring (Option B):
•	The tool continuously monitors the specified directory for file changes.
•	It reads the baseline from 'baseline.txt' and creates a dictionary with file paths as keys and corresponding hash values as values.
•	If a file is created, modified, or deleted, a log message is displayed.
# Workflow:
## •	Baseline Creation:
1.	The user selects option A.
2.	The tool deletes the old baseline (if it exists).
3.	File hashes for all files in the specified directory are computed and appended to 'baseline.txt'.
4.	The user receives a confirmation message with the chosen hashing algorithm and a summary.
## •	File Monitoring:
1.	The user selects option B.
2.	The tool reads the baseline from 'baseline.txt' and creates a dictionary.
3.	It continuously monitors the directory for any changes, reporting creations, modifications, or deletions.
4.	The monitoring loop continues until manually interrupted (CTRL + C).

# File Changes Reporting
## •	Creation Detection:
During the file monitoring phase (Option B), the script iterates through all files in the specified directory.
For each file, it computes the hash using the defined hashing function (hashing).
If the file path is not present in the baseline dictionary, it signifies a new file creation.
A log message is generated and displayed indicating the newly created file.

![image](https://github.com/RavinduMendis/FIM-powershell/assets/53220147/23ea093f-3ba0-4cee-bb05-2c3a824bd414)

## •	Modification Detection:
For files that exist in both the baseline and the current directory, the script compares the computed hash with the stored hash in the baseline dictionary.

![image](https://github.com/RavinduMendis/FIM-powershell/assets/53220147/b5a40a6d-3bba-433d-a4ca-bb0e2b9dace5)

If the hashes differ, it indicates a file modification.
A log message is generated and displayed indicating the modified file.

## •	Deletion Detection:
After checking for creations and modifications, the script examines the baseline dictionary to identify files that were present in the baseline but are no longer in the current directory.
If a file from the baseline is not found in the current directory, it indicates a file deletion.
A log message is generated and displayed indicating the deleted file.

![image](https://github.com/RavinduMendis/FIM-powershell/assets/53220147/12b228aa-4f64-4fd8-99aa-00f3d57a2e38)

# Conclusion
The File Integrity Monitoring tool provides a simple yet effective solution for tracking changes in a specified directory. It enables users to establish a baseline of file hashes and subsequently monitor these files for any unauthorized modifications, ensuring the integrity and security of critical files. The tool's flexibility in choosing hashing algorithms and real-time monitoring makes it a valuable asset for maintaining file integrity in various scenarios.

