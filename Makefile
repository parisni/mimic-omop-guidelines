merge:
	cat 01-introduction.md 02-method.md 03-result.md 04-discussion.md 05-conclusion.md > merged.md
doc:
	pandoc merged.md -o merged.doc
tex: 
	pandoc merged.md -o merged.tex
clean:
	rm merged.*
