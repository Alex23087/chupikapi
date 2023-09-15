(lang dune 3.10)

(name chupikapi)

(generate_opam_files true)

(source
	(github Alex23087/chupikapi))

(authors "Alessandro Scala")

(maintainers "Alessandro Scala")

(license ISC)

(using menhir 2.1)

(documentation https://url/to/documentation)

(package
	(name chupikapi)
	(synopsis "ChuPikaPi (CPP) programming language")
	(description "A programming language that electric mice can understand")
	(depends ocaml dune menhir ppx_deriving llvm)
	(tags
		(topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
