import random
import math

def load_data_from_file(file_path):
    data = []
    with open(file_path, 'r') as inputfile:
        for line in inputfile:
            if is_valid_string(line):
                x, y, z = map(float, line.strip().split(','))
                point = Point(x, y, z)
                data.append(point)
    return data

def get_k():
    while True:
        try:
            k = int(input("Enter the number of clusters (K): "))
            if k > 0:
                return k
            else:
                print("Please enter a positive integer for the number of clusters.")
        except ValueError:
            print("Please enter a valid integer for the number of clusters.")

def get_distance_metric():
    while True:
        try:
            distance_metric = input("Enter the distance metric (Euclidean or Manhattan): ").strip().lower()
            if distance_metric in ['euclidean', 'manhattan']:
                return distance_metric
            else:
                print("Please enter 'Euclidean' or 'Manhattan' for the distance metric.")
        except ValueError:
            print("Please enter a valid distance metric.")

def is_valid_string(point:str):
    dimensions = point.strip().split(',')
    if dimensions[0].replace('.','').replace('-','').isdigit() & dimensions[1].replace('.','').replace('-','').isdigit() and dimensions[2].replace('.','').replace('-','').isdigit():
        return True
    return False

def generate_random_point():
    x = round(random.uniform(-10, 10),2)
    y = round(random.uniform(-10, 10),2)
    z = round(random.uniform(-10, 10),2)
    return Point(x, y, z)

def calculate_mean_point(cluster):
    if not cluster:
        return None 
    dimensions = 3  
    mean_coordinates = [0] * dimensions
    num_points = len(cluster)
    for point in cluster:
        mean_coordinates[0] += point.x
        mean_coordinates[1] += point.y
        mean_coordinates[2] += point.z
    mean_coordinates = [round(coord / num_points,2) for coord in mean_coordinates]
    return Point(*mean_coordinates)

class Point:
    def __init__(self, x,y,z):
        self.x = x
        self.y= y
        self.z= z
    
    def __str__(self):
        return f"({self.x}, {self.y}, {self.z})"
    
    def calculate_distance(self, other_point, distance_metric):
            if distance_metric == 'euclidean':
                return math.sqrt((self.x - other_point.x) ** 2 + (self.y - other_point.y) ** 2 + (self.z - other_point.z) ** 2)
            elif distance_metric == 'manhattan':
                return abs(self.x - other_point.x) + abs(self.y - other_point.y) + abs(self.z - other_point.z)


# Load data from file
input_file_path = 'D:\\Nazemi\\Learn\\Daneshkar\\Python\\Projects\\K-means\\points.txt'
data = load_data_from_file(input_file_path)  

# Get the number of clusters (K) from the user
number_of_cluster = get_k()

# Get the distance metric from the user
distance_metric = get_distance_metric()

# Initialize centroids randomly
random_centroids = [generate_random_point() for _ in range(number_of_cluster)]  

# Perform k-means clustering
while True:
    clusters = [[] for _ in range(number_of_cluster)]
    for point in data:
        distances = [point.calculate_distance(centroid, distance_metric) for centroid in random_centroids]
        nearest_centroid_index = distances.index(min(distances))
        clusters[nearest_centroid_index].append(point)

    new_centroids = [calculate_mean_point(cluster) for cluster in clusters]

    if all(new_cen.x == random_cen.x and new_cen.y == random_cen.y and new_cen.z == random_cen.z for new_cen, random_cen in zip(new_centroids, random_centroids)) or None in new_centroids:
        break
    
    random_centroids = new_centroids
    
# Display the final cluster centroids
print("Final cluster centroids:")
for centroid in random_centroids:
    print(centroid)
