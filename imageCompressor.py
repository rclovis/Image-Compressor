#!/usr/bin/env python3
from PIL import Image
import sys
import os
import time

BINARY = "./imageCompressor"

def error_handling():
    if len(sys.argv) == 2 and sys.argv[1] == "-h":
        print("Usage: ./imageCompressor.py [image_name] [k] [n]")
        exit()
    if len(sys.argv) != 4:
        print("Usage: ./imageCompressor.py [image_name] [k] [n]")
        exit()
    if not os.path.isfile(BINARY):
        print("No binary")
        exit()
    image_path_old = "images/" + sys.argv[1]
    if not os.path.isfile(image_path_old):
        print("No image")
        exit()

def parse_centroids(centroids):
    centroids = centroids.replace("(", "")
    centroids = centroids.replace(")", "")
    centroids = centroids.split(",")
    for i in range(len(centroids)):
        centroids[i] = int(centroids[i])
    return centroids

def parse_pixels(pixel):
    pixel = pixel.replace("(", "")
    pixel = pixel.replace(")", "")
    pixel = pixel.replace(" ", ",")
    pixel = pixel.split(",")
    for i in range(len(pixel)):
        pixel[i] = int(pixel[i])
    return pixel

def main ():
    error_handling()

    image_tmp = "images/image.txt"
    image_path_old = "images/" + sys.argv[1]
    image_path_new = "images/" + sys.argv[2] + "_" + sys.argv[3] + sys.argv[1]

    img = Image.open(image_path_old)
    pixels = img.load()

    f = open(image_tmp, "w")
    for x in range(img.size[0]):
        for y in range(img.size[1]):
            f.write(f'({y},{x}) ({pixels[x, y][0]},{pixels[x, y][1]},{pixels[x, y][2]})\n')

    print("Image saved to image.txt")

    flags = ["-f", "-n", "-l"]
    command = f'{BINARY} {flags[0]} {image_tmp} {flags[1]} {sys.argv[2]} {flags[2]} {sys.argv[3]}'
    elapsed_time = time.time()
    result = os.popen(command).read()
    elapsed_time = time.time() - elapsed_time
    print(f"Time elapsed: {elapsed_time} seconds")

    current_centroids = []
    pixel_list = []
    lines = result.splitlines()
    for i in range (len(lines)):
        if lines[i] == "--":
            continue
        if lines[i] == "-":
            continue
        if lines[i].find(" ") == -1:
            current_centroids = parse_centroids(lines[i])
        else:
            tmp = parse_pixels(lines[i])
            tmp[2] = current_centroids[0]
            tmp[3] = current_centroids[1]
            tmp[4] = current_centroids[2]
            pixel_list.append(tmp)

    img = Image.new('RGB', (img.size[0], img.size[1]))
    pixels = img.load()
    for i in range(len(pixel_list)):
        pixels[pixel_list[i][1], pixel_list[i][0]] = (pixel_list[i][2], pixel_list[i][3], pixel_list[i][4])

    img.save(image_path_new)
main()