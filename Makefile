.RECIPEPREFIX = >

html: index.md
> pandoc index.md -o slides.html -t revealjs -s -V theme=white -V center=false
