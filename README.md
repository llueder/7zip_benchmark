# How the repo was created

```
wget https://www.7-zip.org/a/7z2301-src.tar.xz
tar -xvf 7z2301-src.tar.xz
git add .
git commit -m "initial commit, original 7zip version"
```

# Run

With nix:
`nix-shell -p python3 gcc13`
In the shell:
`PATH=/nix/store/s8lgmmia377k56vmpmhhk9q9ngyjngnk-gcc-13.2.0:$PATH python3 ./runall.py`
