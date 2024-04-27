import random
import math 

def is_valid_string(point:str):
    dimensions = point.strip().split(',')
    if dimensions[0].replace('.','').replace('-','').isdigit() & dimensions[1].replace('.','').replace('-','').isdigit() and dimensions[2].replace('.','').replace('-','').isdigit():
        return True
    return False

def generate_random_point():
    x = random.uniform(-10, 10)
    y = random.uniform(-10, 10)
    z = random.uniform(-10, 10)
    return Point(x, y, z)


def calculate_distance(point1, point2, distance_metric):
     if distance_metric == 'euclidean':
         return math.sqrt(sum((p1 - p2) ** 2 for p1, p2 in zip(point1.coordinates, point2.coordinates)))
     elif distance_metric == 'manhattan':
         return sum(abs(p1 - p2) for p1, p2 in zip(point1.coordinates, point2.coordinates))

class Point:
    def __init__(self, x,y,z):
        self.x = x
        self.y= y
        self.z= z
    
    def __str__(self):
        return f"({self.x}, {self.y}, {self.z})"
    



number_of_cluster=int(input("Enter number of cluster: "))
distance_metric=input("Choose distance metric : euclidean or manhattan : ").lower()

data = []
input_file_path="D:\\Nazemi\\Learn\\Daneshkar\\Python\\LocalProject\\FirstP\\points.txt"
with open(input_file_path,"r") as inputfile:
    lines=inputfile.readlines()
    for line in lines:
        if is_valid_string(line):
            x, y, z = map(float, line.strip().split(','))
            point = Point(x, y, z)
            data.append(point)
            # row = [float(x) for x in line.strip().split(',')] 
            # data.append(row)


# Create instances of the Point
# point_instances = [Point(coordinates) for coordinates in data]
random_centroids = [Point(generate_random_point()) for _ in range(number_of_cluster)]



while True:
    # Assign each data point to the nearest centroid
    # clusters = [[] for _ in range(number_of_cluster)]
    clusters = []
    for point in point_instances:
        distances = [calculate_distance(point, centroid, distance_metric) for centroid in random_centroids]
        # print(distances)
        # nearest_centroid_index = distances.index(min(distances))
        
        # clusters[nearest_centroid_index].append(point)
        nearest_centroid_index = min(range(len(distances)), key=distances.__getitem__)
        # print(nearest_centroid_index)
        clusters.append(nearest_centroid_index)
        # print(clusters)
    
    # Step 8: Update centroids
    new_centroids = []
    centroids= new_centroids
    for cluster in clusters:

        if cluster:
            # Extract coordinates of points in the cluster
            cluster_coordinates = [point.coordinates for point in cluster]
            # Calculate the mean of each dimension separately
            new_centroid_coordinates = [sum(coord[i] for coord in cluster_coordinates) / len(cluster) for i in range(3)]
            new_centroids.append(new_centroid_coordinates)
        else:
            new_centroids.append(generate_random_point())

    # Step 9: Check for convergence
    if all(all(math.isclose(x, y, rel_tol=1e-9) for x, y in zip(centroid, new_centroid)) for centroid, new_centroid in zip(centroids, new_centroids)):
        break

    centroids = new_centroids
    
# Step 10: Display the final cluster centroids
print("Final cluster centroids:")
for centroid in centroids:
    print(centroid)
