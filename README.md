# Image Compressor

This project is about coding an image compressor in Haskell based on K-Means algorithm

# Usage:
## Compiling:

This project is based on stack, but uses makefile to compile the program.

To compile the program, run the following command:

```bash
make
```
## Running:
To run the program, run the following command with the desired parameters:

```bash
./imageCompressor [image_name] [k] [n]
```
- **image_name**: The name of the image you want to compress
- **k**: The number of colors you want to compress the image to
- **n**: The precision of the compression (the lower the number, the more precise the compression)

> [!warning]
> Your image must be in the images folder and must be in .jpg format

# Examples:

```bash
./imageCompressor.py mona-lisa.jpg 5 0.1
```
## Original image
![images](images/mona-lisa.jpg)

## Compressed image
![images](images/5_0.1mona-lisa.jpg)

```bash
./imageCompressor.py velocity-design-comfort.jpg 10 5
```

## Original image
![images](images/velocity-design-comfort.jpg)

## Compressed image
![images](images/10_5velocity-design-comfort.jpg)
