function size = am1_filesize_jpg_or1_filesize_png(filepath)
    image=dir(filepath);
    size=image.bytes;
end