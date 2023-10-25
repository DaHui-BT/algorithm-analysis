.RECIPEPREFIX = >

.PHONY: html clean

html: index.md
> pandoc index.md -o index.html -t revealjs -s -V theme=white -V center=false

clean:
> rm ./*.html
