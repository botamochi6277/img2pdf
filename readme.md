# img2pdf
Wrapper of [ImageMagick convert](https://www.imagemagick.org/script/convert.php) command to convert images to pdf files.

img2pdf.sh converts all images in inputed folders to a pdf file or pdf files.

### Usage
```bash
# Images in directory convert into directory.pdf
./img2pdf.sh directory
# Images in directory convert into mybook.pdf
./img2pdf.sh directory -o mybook.pdf
# Export with jpeg compression in 80 quality
./img2pdf.sh directory -j 80
# Images in directory1 and directory2 merge into mybook.pdf
./img2pdf.sh directory1 directory2 -o mybook.pdf
# Images in directory1 and directory2 convert into directory1.pdf and directory2.pdf, respectively
./img2pdf.sh directory1 directory2 -s
# Print help messages
./img2pdf.sh -h
```
