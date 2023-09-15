.DEFAULT_GOAL := build
EXE=pikac

ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

.PHONY: build
build: ## Build the project, including non installable libraries and executables
	opam exec -- dune build --root .

.PHONY: exec
exec: build ## Run the produced executable
	opam exec -- dune exec --root . bin/$(EXE).exe $(ARGS)
	 
.PHONY: clean-comp
clean-comp: ## Clean microc compilation byproducts
	rm a.bc output.bc output.o runtime.bc

.PHONY: clean
clean: ## Clean build artifacts and other generated files
	opam exec -- dune clean --root .

.PHONY: watch
watch: ## Watch for the filesystem and rebuild on every change
	opam exec -- dune build --root . --watch

.PHONY: test
test: build ## Build and run test
	opam exec -- dune exec --root . _build/default/test/pikatest.exe

.PHONY: fmt
fmt: ## Format the codebase with ocamlformat
	opam exec -- dune build --root . --auto-promote @fmt

.PHONY: compile
compile: exec ## Compile executable and link runtime libraries
	/usr/lib/llvm14/bin/clang -emit-llvm -c "bin/runtime.c"
	llvm-link runtime.bc a.bc -o output.bc
	llc -filetype=obj output.bc
	/usr/lib/llvm14/bin/clang output.o -o a.out
	make clean-comp

.PHONY: run
run: compile ## Compile, link and run program
	./a.out
	rm a.out