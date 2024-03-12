# How the repo was created

```
wget https://www.7-zip.org/a/7z2301-src.tar.xz
tar -xvf 7z2301-src.tar.xz
git add .
git commit -m "initial commit, original 7zip version"
```

# Run

You need make and gcc or clang. There's a nix.shell to get your dependencies.
Build with `./build.sh THREADS MARCH MTUNE OPT_LVL cmpl_CC.mak`, e.g. `./build.sh 4 native native 2 cmpl_clang.mak`.
The script will make required settings in the makefiles and also in source code.

Run with `./run.sh /tmp/7zip` and you have compression and decompression rates at `/tmp/7zip_compress.txt` and `/tmp/7zip_decompress.txt`.
