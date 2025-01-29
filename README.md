# ChuPikaPi (Cpp) - A trainer's manual to understanding Pikachu

Welcome trainer, are you looking to learn how you can train your Pikachu to execute your programs? Look no further, this guide will teach you all you need to know to communicate with your Pikachu and make it execute any program you want.

This manual will teach you the basics of the Pikachu language, ChuPikaPi, and how you can use it to talk to your Pikachu.

### Concepts:
In Cpp, the program is executed by your Pikachu. Obviously, since you are not a Pikachu yourself (probably), you first need to send your Pikachu out of the PokéBall. This is done by saying "Go, Pikachu!" or "Pikachu, I choose you!". Then, after the program is done, you need to return your Pikachu to the PokéBall by saying "Well done, Pikachu!" or "Pikachu, return!".

Now, to give your Pikachu a program to execute, since Pikachus don't understand (as far as we know) human languages and those funny symbols we use to write math such as = and +, you will need to speak their language instead.

Note that Pikachus don't care too much about whitespace, so you are free to use as much or as little as you like, to improve (or not) readability.

### Variables:
Just like in most programming languages, you can use PikaVariables in your PikaProgram. To do so, you first need to tell your Pikachu that you want it to remember a value for you. You do this by using a lowercase PikaWord (that is, a word in the Pikachu language) that has no other meaning in ChuPikaPi.

Specifically, any word that matches the regex:
```regex
pi(ka(pika)*(pi|ch(u)+)?)?
```
Examples to get you started in learning the Pikachu language:
```
pi
pika
pikachu
pikapika
pikapikapika
pikapikapi
pikapikachu
pikapikachuuuuuu
```
Once you tell Pikachu about your new variable, it will immediately contain the value 25, you can guess why Pikachu likes this one in particular.

In addition to the variables you define, there is a special one, `PIKACHU`, which is a special PikaVariable that Pikachu already knows about, and holds the value 1 (because your Pikachu is only one, after all).

### Expressions:
Now that you have told Pikachu about your PikaVariables, let's see what you can do with them. Since most Pikachus don't usually use math in their daily lives, they only know how to do a few basic things with numbers. They know how to add and subtract, and they know how to compare two numbers to see if one is less than the other. After all, you don't need any more math to live a comfortable life as a Pikachu.

To add two variables, the word used in the Pikachu language is `PI`, and to subtract, the word is `KA`. To compare two variables, the word is `PIKACH`.

For example:
```
PIKACHU PI PIKACHU
```
will return 2, because 1 + 1 = 2.
Other example:
```
PIKACHU PIKACH PIKACHU
```
will return 0, because 1 is not less than 1.

### Data Flow:
An important concept to understand how Pikachus think, is that they are good at running straight ahead, but also good at quickly changing direction (think of how sometimes during Volt Tackle they can zig zag to dodge attacks). You can use their aptness at changing direction to explain to them how you want your numbers to flow.
For example, if you want to add 1 to a variable, you can either tell Pikachu that you want <variable> + 1 to go into the variable, or you can say that you want <variable> to get <variable> + 1 as new value. You can express this in their language by changing the intonation of your voice:
```
pika PI PIKACHU! pika
```
This means that `pika+1` will go into pika, you can visualise this as `pika+1 -> pika`.

Alternatively, you can obtain the same result like this:
```
pika? pika PI PIKACHU
```
You can imagine this as `pika <- pika+1`, or by thinking "what's the new value of `pika`?" and the answer is `pika+1`.

While this concept is explained with variables now, it is a more general concept in Pikachu language, and will be important later on.

### Control Structures:
You can affect the way your commands are executed in two main ways: using conditionals and loops.

First, let's see how you can tell pikachu to do something if something else is true.

The grammar to say this in ChuPikaPi is:
```
PI... <PikaExpression> <PikaStatements> ...KA... <PikaStatements> ...CHU
```
The first `PI...` tells Pikachu that you want to start a conditional block. Then, you will say a PikaExpression. If Pikachu recognises that this expression results into the value 0, then the first sequence of PikaStatements will be executed. You then separate the two blocks with `...KA...`. If the expression results into a value different from 0, then the second sequence of PikaStatements will be executed. Finally, you end the sentence with `...CHU` (which can contain any number of `U`) to tell your Pikachu that the rest of what you say is not inside this conditional.

Next, if you want your Pikachu to repeat something until a condition is met, you can use the following grammar:
```
PIKAPIKAPIKA... <PikaExpression> <PikaStatements> ...CHU
```
The first `PIKAPIKAPIKA...` tells Pikachu that you want to start a loop. Pikachu will check the value of the PikaExpression, and if it results into 0, Pikachu will stop the loop. Otherwise, the PikaStatements will be executed, and then the PikaExpression will be evaluated again. This will continue until the PikaExpression results into 0.

### Moves:
The last concept you need to train your Pikachu is moves. You can tell Pikachu to remember a sequence of commands and then call it later.

Move names are just like PikaVariable names, except they start with a capital letter:
```regex
Pi(ka(pika)*(pi|ch(u)+)?)?
```

To teach Pikachu a new move, you first tell its name, then if you want the move to take any arguments, you tell your Pikachu their names. To do so, think of the move as something that your variables are going to flow into. This means that you will say:
```
Pi? pika? pi
```
to say that you want a move named `Pi` with two arguments, `pika` and `pi`.

Moves can either return a value or not. To say that you want a value to be returned, think that the data will flow out of the move, so you will say:
```
Pi? pika? pi!
```

To tell Pikachu what the move does, you will then say the command that needs to be executed. You can only use one command per move, so if you want to give Pikachu a sequence of instructions, you will need to use a PikaBlock.

PikaBlocks are defined with the following grammar:
```
PIKA... <PikaStatements> ...CHU
```
Where in the first `PIKA...` you can have as many number of `A` as you want, and in the last `...CHU` you can have as many number of `U` as you want. This has no meaning for Pikachu, but it can be helpful if you are not bilingual yet, to make sense of the sentences.

To return a value then you simply put it as the last statement of the move.

#### Example:
Say that you want to teach Pikachu a new move that adds 1 to a variable and returns it. You can do this by saying:
```
Pi? pika!
PIKA...
    pika? pika PI PIKACHU
    pika
...CHU
```

Remember that in ChuPikaPi whitespace and new lines don't matter, so you can also write this as:
```
Pi? pika! PIKA... pika? pika PI PIKACHU pika ...CHU
```

#### Using Moves
Once you taught Pikachu a move, you can then use it in the program.
To do so, the input values should flow in, and the output will flow out.
For example, to use the move we just taught Pikachu, you can say:
```
PIKACHU! Pi! PIKACHU
```
This will set the value of `PIKACHU` to 2. Think of this as `(PIKACHU -> Pi) -> PIKACHU`.

If you have multiple parameters you chain them together and they will flow in order:
```
pi! pika! Pika! pikachuuu
```
This tells Pikachu to use a move `Pika` with 2 parameters, `pi` and `pika`, and set the variable `pikachuuu` to the result.

The main move is `Pikachu`, you should always teach this move to your Pikachu, and that's where the program will start executing.

Lastly, Pikachu already knows a move without you teaching it: `PIKA`. This is a special move that will make Pikachu say the value of the variable that flows into it. For example, if you say:
```
PIKA? PIKACHU
```
your Pikachu will say `1`.

## Conclusion
You should be now ready to train your Pikachu to execute any program you want. Have fun together and remember to not overwork your Pikachu, they need rest too!

## Future editions
In the future, we plan to write other guides, such as:
- All about CHARmander - A guide on stringing PokeWords together
- Train your Porygon! - Use Tri Attack to draw 3D shapes on your screen

## Technical details
Made with Ocaml, Menhir, Ocamllex, LLVM, and built with Dune.

### Syntax:
```
Pikaprogram ::= Pikaintro Pikafunction* Pikaoutro

Pikaintro ::= "Go, Pikachu!" | "Pikachu, I choose you!"
Pikaoutro ::= "Well done, Pikachu!" | "Pikachu, return!"

Pikafunction ::= PikafuncIdent ("?" PikavarIdent)* "!"? Pikastatement

Pikastatement ::=
    | Pikablock
    | Pikaexpression
    | "PI..." Pikaexpression Pikastatement* "...KA..." Pikastatement* PikablockEnd
    | "PIKAPIKAPIKA..." Pikaexpression Pikastatement* PikablockEnd

Pikablock ::= PikablockStart Pikastatement* PikablockEnd
PikablockStart ::= "PIK" "A"+ "..."
PikablockEnd ::= "...CH" "U"+

Pikaexpression ::=
    | Pikaexpression "!" Pikalexpr
    | Pikalexpr "?" Pikaexpression
    | Pikaexpression Pikabinop Pikaexpression

Pikalexpr ::= 
    | PikavarIdent
    | PikafuncIdent

Pikabinop ::= "PI" | "KA" | "PIKACH"
```