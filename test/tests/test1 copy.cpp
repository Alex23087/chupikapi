Go, Pikachu! / Pikachu! I choose you! Pika!	// Initial, necessary phrase

Pikachu!									// Main function
PIKA...                 					// Start block
	PIKAAA...           					// Start another block
		PIKACHU								// Constant value = 1
		pikapikachuuuu						// Variable declaration (initialized to 25)
		PIKA! pikapikachuuuu				// Put function output into variable
		PIKA? pikapikachuuuu				// Pass variable into function
											// Note: PIKA is a builtin function to input/output integers
		// Pikachu?! pikapikachuuuu			// Pass variable into function and put return value into the same variable

		pikapi								// Other variable declaration
		pikapikachuuuu PI pikapi			// Sum
		pikapikachuuuu KA pikapi			// Difference

		pikapikachuuuu KA pikapi! pikapi	// pikapi = pikapikachuuuu - pikapi
		pikapi PI PIKACHU! pikapi			// Increment pikapi
		pikapi? pikapi PI PIKACHU			// Same as above

		pikapikachuuuu? pikapi				// Copy pikapi into pikapikachuuuu

		pikapi PIKACH pikapikachuuuu		// 0 if pikapi < pikapikachuuuu, 1 otherwise

		
		PI... pikapi						// IF pikapi = 0
			// ...							// THEN
		...KA...
			// ...							// ELSE
		...CHU

		PIKAPIKAPIKA... pikapi				// WHILE

		...CHU								// DONE

	...CHUUU								// End inner block
	PIKACHU KA PIKACHU						// Return 0
...CHU										// End outer block


Pikapikachu? pika? pi!							// Function with two input parameters and an output parameter
PIKA...
	pika KA pi								// Last statement is return (in this case, pika - pi)
...CHU

Well done, Pikachu!
// Regex for identifiers: /^pi(?:ka(?:pika)*(?:(?:pi)|(?:ch(?:u)+))?)?$/gm