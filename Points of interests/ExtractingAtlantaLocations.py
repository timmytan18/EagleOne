import xml.etree.ElementTree as ET 
import csv
tree = ET.parse("AtlantaLocationsRevised.xml")
folders = tree.findall("Folder")

placemark_names = []
for folder in folders:
	placemark_names.append(folder.find("name").text)

grocery_store_names = []
grocery = folders[0]
for store in grocery:
	for item in store.findall("name"):
		grocery_store_names.append(item.text)

school_names = []
schools = folders[1]
for school in schools:
	for item in school.findall("name"):
		school_names.append(item.text)
	
hospital_names = []
hospitals = folders[2]
for hospital in hospitals:
	for item in hospital.findall("name"):
		hospital_names.append(item.text)

grocery_store_coordinates = []
school_coordinates = []
hospital_coordinates = []
for folder in folders:
	if folder.find("name").text == "Grocery Stores":
		for placemark in folder.findall("Placemark"):
			if placemark.find("Point"):
				grocery_store_coordinates.append(placemark.find("Point").find("coordinates").text.strip())
	elif folder.find("name").text == "Schools":
		for placemark in folder.findall("Placemark"):
			if placemark.find("Point"):
				school_coordinates.append(placemark.find("Point").find("coordinates").text.strip())
	else:
		for placemark in folder.findall("Placemark"):
			if placemark.find("Point"):
				hospital_coordinates.append(placemark.find("Point").find("coordinates").text.strip())



grocery_store_listdict = []
for number in range(len(grocery_store_names)):
	coord = grocery_store_coordinates[number]
	x, y, z = coord.split(',')
	grocery_store_listdict.append({"Type of Location": "Grocery Store", "Location Name": grocery_store_names[number], "X Coord": x, "Y Coord": y})
schools_listdict = []
for number in range(len(school_names)):
	coord = school_coordinates[number]
	x, y, z = coord.split(',')
	schools_listdict.append({"Type of Location": "School", "Location Name": school_names[number], "X Coord": x, "Y Coord": y})
hospitals_listdict = []
for number in range(len(hospital_names)):
	coord = hospital_coordinates[number]
	x, y, z = coord.split(',')
	hospitals_listdict.append({"Type of Location": "Hospital", "Location Name": hospital_names[number], "X Coord": x, "Y Coord": y})

locations_listdict = []
for data in grocery_store_listdict:
 	locations_listdict.append(data)
for data in schools_listdict:
	locations_listdict.append(data)
for data in hospitals_listdict:
	locations_listdict.append(data)


with open("locationsdata.csv", "w") as file:
	writer = csv.DictWriter(file, fieldnames= ['Type of Location', 'Location Name', 'X Coord', 'Y Coord'])
	writer.writeheader()
	writer.writerows(locations_listdict)
