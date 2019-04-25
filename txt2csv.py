import csv
import sys

if __name__ == "__main__":
    marta_data = sys.argv[1]
    file_name = marta_data[:-4]

    with open(marta_data, 'r') as txt_file, open(file_name + ".csv", 'w') as fout:
        for line in txt_file:
            fout.write(line)
