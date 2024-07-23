# How to make a new release of themeltspice

## Checklist

1. Update the `version` variable at the top of the script
1. Generate a PDF version of the README.md
1.  Commit & Push
1. Tag the version, e.g.  
    ```
    git tag v2.0.3 -m "v2.0.3"
1. Push the tag, e.g.  
    ```
    git push origin v2.0.3
    ```
1. Copy the README.* to the `johan162.github.io/themeltspice`
1. Commit & Push
1. Create a new release in github
1. Download the tar-ball and check its `sha256sum` checksum and make a copy of it
1. Update the checksum in the `homebrew-themeltspice` repo's Ruby file
1. Commit & Push the Ruby file 


