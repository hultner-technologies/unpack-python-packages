## Create RECORD
Get file paths
On all files
```sh
tree -s -i -f <dir>
```

```sh
shasum -a 256
```
Convert hashes
hex reverse
```sh
xxd -r -p | base64
```

```sh
shasum -a256 */** | cut -f1 -d' '
```

```sh
shasum -a256 */** |  while read hex; do printf $hex,sha256=; echo $hex | awk '{print $1}' |  xxd -r -p | base64;  done | awk '{print $2}'
```
```sh
shasum -a256 */** |  while read hex; do printf $(printf $hex|awk '{print $2}'),sha256=; printf $hex | awk '{print $1}' |  xxd -r -p | base64 | sed 's/.$//'|tr -d '\n'; echo ,$(printf $hex | awk '{print $2}'| xargs cat | wc -c| awk '{print $1}'); done
```



```sh
unzip -l
```

Size
```sh
cat <file> | wc-c
```

## Explain file-name format
...



