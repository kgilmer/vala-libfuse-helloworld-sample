/* main.vala
 *
 * Copyright 2019 Ken Gilmer
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE X CONSORTIUM BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * Except as contained in this notice, the name(s) of the above copyright
 * holders shall not be used in advertising or otherwise to promote the sale,
 * use or other dealings in this Software without prior written
 * authorization.
 */


using GLib;
using Fuse;
using Posix;

const string filename = "hello";
const string contents = "Hello World!\n";

/*
 * This is a simplified Vala translation of the libfuse helloworld 
 * example: https://github.com/libfuse/libfuse/blob/master/example/hello.c 
 */
int main (string[] args)
{
    Fuse.Operations oper = Fuse.Operations() {
        getattr = GetAttr,
        readdir = ReadDir,
        open = Open,
        read = Read
    };
    
    Fuse.main(args, oper, null);
    
	return 0;
}

int GetAttr (string path, Posix.Stat* stbuf) {
        int res = 0;
        
        if (path == "/") {
                stbuf->st_mode = S_IFDIR | 0755;
                stbuf->st_nlink = 2;
        } else if (filename == path.substring(1)) {
                stbuf->st_mode = S_IFREG | 0444;
                stbuf->st_nlink = 1;
                stbuf->st_size = contents.length;
        } else {
                res = -ENOENT;
                }
        return res;
}

int ReadDir (string path, void* buf, FillDir filler, off_t offset, ref FileInfo fi) {
    if (path != "/") {
        return -ENOENT;
    }
    
    filler(buf, ".", null, 0);
    filler(buf, "..", null, 0);
    filler(buf, filename, null, 0);
    
    return 0;
}

int Open (string path, ref FileInfo fi) {
    if (filename != path.substring(1))
            return -ENOENT;
            
    if ((fi.flags & O_ACCMODE) != O_RDONLY)
            return -EACCES;
    
    return 0;
}

int Read (string path, char* buf, size_t size, off_t offset, ref FileInfo fi) {
    size_t len;

    if (filename != path.substring(1)) {
            return -ENOENT;
    }
    
    len = contents.length;
    if (offset < len) {
        if (offset + size > len) {
            size = len - offset;
        }
        
        memcpy(buf, contents.substring((int) offset), size);
    } else {
        size = 0;
    }
            
    return (int) size;
}
