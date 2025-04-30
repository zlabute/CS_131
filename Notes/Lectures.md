# Lecture 8

## Types and Polymorphism

### Types
- `Object`  
- `Integer`  
- `String`  
- `Thread`

### Polymorphism

#### Parametric Polymorphism
- A list type that can hold any element type  
- Syntax: `List<T>`
- Generics is the implementation of parametric polymorphism in Java
- Templates is the implementation of parametric polymorphism in C++

##### Common Implementations
- `List<T>` (interface)  
- `LinkedList<T>` (class)  

##### Java Generics
* C does not have generics but has templates instead

###### Without Generics
- Relies on **dynamic** type checking at runtime  
- Less safe (risk of `ClassCastException`)

###### With Generics
- Defines type parameters at compile-time  
- **Makes code safer** by catching type errors early  

```Java

List l = new LinkedList();
l.add(new Integer(0));

```

##### Wildcard in Java
- does not care what type is
```Java

void printAll(List<?> l)
{
    for (Object o.l)
        System.out.println(o);
}

```

- bounded wildcard (accounts for supertypes)

``` Java
List<? super T> s;
```

### Dynamic Type Checking
- Alternate school of thought
- maybe static type checking is too complex and better to dynamically check

#### Pros and Cons
- \- Safety
- \- performance
- \+ simplicity
- \+ flexibility

#### Duck Typing
- Checks if the behaviors of the objects are the same
- If they are just assumes they are the same 


## Names and Bindings
- Names are called identifiers, tags
- Issues like (what can be in a name, are they case sensitive)
- an association between a name and a value
- context: names -> values (mapping)
    - bind is the process by which this mapping is made
- bindings occur 

### How is a name bound
- Bound to the value
- Could be bound to the address
- PIE - Position Independent Executable
    - Is helpful in avoiding hacking
    - prevents hackers form knowing where you are accessing

### Binding Time
- when does the binding occur
- depends on the language
- options:
    - during execution 
    - at compile time 
    - at link time
        - determined by linker
    - at load time
    - at function entry time
    - at object allocation time
- aspects of the language that are key to understanding how your program will operate

### Issues with Binding

#### Dynamic vs. Static Binding
- static binding
    - when executing a variable go look at what is stored
- dynamic binding
    - to determine which nonlocal var you want, look at the caller, then at caller's caller, and .etc

#### Explicit vs Implicit Binding
- Explicit:
    - Written in program
- Implicit: 
    - declares the name if not already explicitly declared based upon context of program or what initialized to
    - Derived from program
        - Perl
        - FORTRAN 
            - variables begin with letter of type

### Namespaces
- primitive nameaspaces
```c++
int f()
{
    struct f{int f;} f;
    enum f {g, h}; // breaks rules here because could be referring to parent's namespace if replace g with f
    #include {f};
    #define f g;
    f: gets f;
}
```
- labeled namespace
    - naming namespaces
    ```python
    import math
    f = math.sqrt(4)
    ```
- information hiding & namespaces
    ```c++
    class c{
        int m(){ };
        int n(){ };
        private int o() { } // hiddent
    }
    ```




# Lecture 9 

## Scope
- Namespaces

## Memory
- Module&Packages 

## Hierarchy
- WE HAVE 2 HIERARCHIES: one for runtime behavior and one for code maintenance. Responsible for different things, so we must have both. 

- Class hierarchy: (inheritance - runtime compatibility and behavior)
	Object
String 		Thread

- Package Hierarchy: (developer’s responsibility / code maintenance) Compilation unit

## Information Handeling 

### In Java

- some identifiers should be private/”secret”, so that other parts of the application don’t depend on the specific implementation (can change the implementation later and it won’t affect other code)
    -> primary motivation: improves the modularity of your code
    -> secondary motivation: to keep competitors “out”
    How to do this (from most to least restrictive): 
    Private keyword (not visible outside the class)
    (default) no keyword (visible to all classes in the same package)
    Protected keyword (visible to all classes in the same package + subclasses)
    Public keyword (visible to anybody who can see the classe)

- Java Keywords: private, public, default, protected

### In Ocaml (namespace control)

- finer grained control over namespaces:
```OCaml
    module M = 
        struct
        type a enque
        ...
        end
```
- To accomplish modularization in Ocaml you can use:
```Ocaml
    module Q =
    sig
        type `a queue
        enqueue, a queue -> `a -> un
    end
```
- Ocaml also has functors: complete function from structers to structors 
- Must follow scope rules of language to master it

## Issue: Seperate Compilation
- Interface with pieces: A, B, C, D
    - How much information is shared inbetween pieces
    - need to allow each part to compile seperately
    - has to have the ability to link later
- Size of Compilation is often `O(N^2)`
- Size of Linking is `O(NlogN)`
- therefore more effect to link smaller files 

## Memory - Persistent State (files/databases/etc.)
- Difficult to write a language that maintains state through shutdowns
- Forms of Memory:
    - DRAM - larger
    - Cache - intermediate
    - registers - small and fast
- What to store (Programmer's perspective)
    - Variables of the program
    - Instruction Pointer
    - Instructions
    - [ where the variables are (stack pointer) (SOLUTION: Temporary values) ] - recursive
        - recursion: needs to keep track of where it is 
    - Issue: return f(x) + g(x)
        - f(x) -> rax
        - g(x) -> rax
        - there is a collision here and there needs to be a store of temporary values
    - I/O Buffers (for performance reasons)
        - idle buffers pulls data in meantime
- To simplify how to store there are classes of memory
    - **CACHE**: ignore the cache as it should be an invisble performance enhancer 
    - **REGISTERS** : difficult because it is not addressable:
        - ```c++
          nt n;
          Int *p = &n; /* n can’t be in a register */ ```
    - **DRAM**: 
        - Low Address: statically Allocated variables
            - Heap
        - High Address: LIFO, fast (grows upwards ^)
        - Need extra space for reliable crashes and space in case needed


### Stored on DRAM (Allocation)

#### FIRST SUCCESFUL CODING LANGUAGE (FORTRAN) STATIC ALLOCATION :
- ran without a stack
- static allocation
- Pros and Cons:
    - \+simple 
    - \+ no "memory exhausted"
    - \- wasted memory/too small 
    - \- lacks flexibility
    - \- recursion does not work (leads to undefined behavior)
- generally lack of stack is called a failure for FORTRAN

#### Stack Allocation: 
- \+ almost as simple
- \+ more flexible than static 
- \+ good performance if stack is small
- (local vars+ temps+ return address+) - are all stored in a frame per function call
    - frames are stored with program on the stack
- PROBLEM: fixed layout doesn't work in the case of functions with objects of unknown size at compile time
    - i.e.
        - code sample : 
        ```c++
            int f(int n){
                int m = g(n){
                    double a[m];
                    int x;
                }
            }
        ```
    - solution: subtract 8 * m from stack pointer and then restore after program runs
        - 8: size of double
        - m number of doubles in unknown array size (this is unknown and reason it is dynamic)
        - runtime checking to ensure m is not so large it exceeds stack size: AKA STACK OVERFLOW
        - some languages allow for you to make mistakes in low level with stack size
        - method to detect stack overflow:
            - add guard pages without read or write privileges 
                - if stack overflowing program will crash instead of behaving undefined

#### Nested Functions
- PROBLEM: nested functions (ASSUMING STATIC SCOPING) (C++/C don't allow for nested functions)
    - a nested function has access to variables above it so it needs to access the frame of the program above it
    - Dynamic Chain (Linked List) - THIS IS DYNAMIC SCOPING
        - stack pointer and base pointer
        - at bottom of frame next to base pointer need to store the caller's base pointer
        - each frame specifies the base pointer of its caller (Linked List)
    - SOLUTION: Static Chain (Linked List) - THIS IS STATIC SCOPING
        - points to its definer base pointer
        - if defined at base level: null pointer
        - static chain link is typically shorter
    - combined these give context to where the function is and how to find information from definer via static chain
    - compiler knows where variables are in relationship to different frames 

- In OCaml nested functions is essential because of currying:
    - fun x y -> x - y
    - fun x -> (fun y -> x - y)

- Once you have nested functions and you allow function to return other functions much more complicated
    - even when a function is returned may be unable to reclaim frame until no longer needed
        - could be needed by sub defined functions 
    - without you can just use an instruction pointer
    - with nested functions you need:
        - instruction pointer 
        - evironment pointer
    - Two ways to keep frames around:
        - If a function has a nested function with a value that can escape you can place the frame on the heap
        - Or you can place used frame on the heap 

#### Ways of managing frame size for stack
1. fixed-sized frames
2. arrays size not known until allocation
3. Array size varies at runtime
    a. only one per frame - easier to manage by subtracting and adding to frame pointer 
    b. indirection - store a header and then go once known 

# Tips and Tricks for Midterm

## IMPORTANT TO KNOW:
- Java Packets
- Java Subtypes (ESPECIALLY)

## Grammar
- Ambiguity in a grammar means that there exists an expression that can generate more than on possible parse tree

## Typing 
- **Dynamic Typing** : at runtime i.e. Python
- **Static Typing** : at compule time i.e. Java C++/C

- Statically typed languages

    - A language is statically typed if the type of a variable is known at compile time. For some languages this means that you as the programmer must specify what type each variable is; other languages (e.g.: Java, C, C++) offer some form of type inference, the capability of the type system to deduce the type of a variable (e.g.: OCaml, Haskell, Scala, Kotlin).

    - The main advantage here is that all kinds of checking can be done by the compiler, and therefore a lot of trivial bugs are caught at a very early stage.

    - Examples: C, C++, Java, Rust, Go, Scala

- Dynamically typed languages

    - A language is dynamically typed if the type is associated with run-time values, and not named variables/fields/etc. This means that you as a programmer can write a little quicker because you do not have to specify types every time (unless using a statically-typed language with type inference).

    - Examples: Perl, Ruby, Python, PHP, JavaScript, Erlang

    - Most scripting languages have this feature as there is no compiler to do static type-checking anyway, but you may find yourself searching for a bug that is due to the interpreter misinterpreting the type of a variable. Luckily, scripts tend to be small so bugs have not so many places to hide.

    - Most dynamically typed languages do allow you to provide type information, but do not require it. One language that is currently being developed, Rascal, takes a hybrid approach allowing dynamic typing within functions but enforcing static typing for the function signature.

## Scoping
- **Dynamic Scoping**: is mainly old languages 
    - non local variables found via callers
    
- **Static Scoping**: mainly used by every language now:
    - non local variables found via definitons static chain

## Binding
- **Dynamic Binding**: happens at runtime and needs the context of the language
    - to do OOP and Subtype Polymorphism you need dynamic binding
- **Static Bindings**: 
    - for things that are known at compile time


## Java Subtypes
- In the case of Java subtype relationships they are transitive:
    - i.e. if A is a subtype of B and B is a subtype of C; **A is a subtype of C**
- The inheritance graph of Java subtypes is fundamentally a tree since a class can only extend
one parent class; it still has the capability of having many templates though 
- Java type invariance even though String is a subtype of Object List<String> is not a subtype of List<Object>

## Polymorphism
### Ad hoc Polymorphism (Overloading)
- Defining multiple functions with the same name but different types allowed
### Sub type polymorphism (Inheritance or Interfaces)
- Subtypes of a class can use functions of the parent class but parent class cannot use subtype's functions
### Parametric Polymorphism
- Explicitly written functions with things such as generics and templates to allow for multiple types of polymorphism
- i.e. generic code
- key points: always uses the same implementation regardless of type
- for Statically typed language:
    - you know at compile time you need static binding and static scoping
- for dynamically typed language:
    - you don't need static binding since you 

### Compared
| Aspect                      | Parametric Polymorphism                  | Ad Hoc Polymorphism                            | Subtype Polymorphism                       |
|----------------------------|------------------------------------------|------------------------------------------------|--------------------------------------------|
| Definition                 | Code works for **any type** generically  | Code works for **specific types**, each with custom logic | Code works with **subtypes of a parent**   |
| Type relation              | **Unrelated types**                      | **Unrelated types**                            | **Related types** via inheritance/interface |
| Behavior                   | **Same behavior** for all types          | **Type-specific behavior**                     | **Shared interface**, overridden behavior  |
| Resolution                 | **Compile-time**                         | **Compile-time or runtime** (depends on language) | **Runtime dispatch** (dynamic binding)     |
| Mechanism                  | Type parameters (e.g. `'a`, `T`)         | Overloading, type classes, duck typing         | Inheritance, interfaces, virtual methods   |

## Ocaml Grammar
- the type of a function is defined as the types of the input combined by arrows pointing to a final type which is the output
- note: 'a represents a generic type in Ocaml for polymorphism purposes
- For instance the following function definition:
```Ocaml
let merge_sorted lt a b (* lt compares to ints and returns true if the first element is less a and b are lists *)
```
- would be defined as ``` ('a -> 'a -> bool) -> 'a list -> 'a list -> 'a list ```
    - in this case the 'a represents generic typing
    - bool does not have a 'a because it is a singular known type where as the other lists are of generic types

### Tail Recursion
- In Ocaml tail recursive means that the last call in a function is the recursion meaning that the Ocaml compiler can
optomize it to be similar to a loop and optomize with new stack frames
- two implementations of merge sorted function
    - recurisve:
        ```Ocaml
        (* Not tail recursive *)
        let rec merge_sorted comp a b =
            match a, b with
            | [], b -> b
            | a, [] -> a
            | ah::at, bh::bt ->
            (* Recursive call happens within append making it not the last call *)
                if (comp ah bh) then ah :: (merge_sorted comp at b)
                else bh :: (merge_sorted comp a bt) 
        (* Tail recursive *)
        let merge_sorted comp a b =
            let rec helper comp acc a b =
                match a, b with
                | [], b -> acc @ b
                | a, [] -> acc @ a
                | ah :: at, bh :: bt ->
                if (comp ah bh) then helper comp (acc @ [ah]) at b
                else helper comp (acc @ [bh]) a bt (*append happens within recursion making it the last call *)
            in helper comp [] a b
        ```
    - The key here is that the recursive call being last makes it so the compiler can optimize the function due
    to there being no deffered computation and then stack frames do not have to be retained

## 📘 EBNF vs BNF – Syntax Grammar Comparison

### 🔹 What is BNF (Backus–Naur Form)?

BNF is a **simple and strict** formal notation used to describe the syntax of programming languages using production rules.

#### 📌 Syntax Rules:
- `::=` for definitions
- `<...>` for nonterminals
- `|` for alternatives (not in BNF but can be used for exam )
- No support for shorthand like `?`, `{}`, or `[]`

#### ✅ Example (BNF)
```bnf
<expr> ::= <term> | <term> "+" <expr>
<term> ::= <factor> | <factor> "*" <term>
<factor> ::= "(" <expr> ")" | <number>
<number> ::= "0" | "1" | ... | "9"
```

#### 🧠 Characteristics:
- Verbose
- Requires recursion to express repetition or optionality
- Limited in shorthand expressions

---


## 📁 Understanding Left-Hand Side (LHS) and Right-Hand Side (RHS) in Grammars

### 📄 What is a Production Rule?

A production rule defines how a **nonterminal** symbol can be replaced or expanded into a sequence of **terminals and/or nonterminals**.

#### General Form:
```
<nonterminal> ::= expression
```

---

### 🔹 Left-Hand Side (LHS)
- The **symbol being defined**
- Always a **nonterminal**
- Appears on the **left** of `::=`

#### Example:
```bnf
<expr> ::= <term> "+" <expr> | <term>
```
Here, `<expr>` is the **LHS**.

---

### 🔸 Right-Hand Side (RHS)
- The **definition** or **expansion** of the LHS
- Can include terminals, nonterminals, and EBNF operators
- Appears on the **right** of `::=`

#### Same Example:
```bnf
<expr> ::= <term> "+" <expr> | <term>
```
Here, `<term> "+" <expr> | <term>` is the **RHS**.

---

### 🧠 Analogy: Assignment Statement
You can think of a rule like:
```
<lhs> ::= <rhs>
```
as:
```
thing = definition
```
The **LHS** names the thing being defined, the **RHS** shows how it is constructed.

---

### ✅ Summary

| Part         | Name            | Description                                  |
|--------------|------------------|----------------------------------------------|
| Left-hand side (LHS) | Nonterminal | The symbol being defined                     |
| Right-hand side (RHS) | Expression   | How the LHS can be composed using terminals and nonterminals |

> **LHS and RHS** are central concepts in grammar rules: think of them like variable names and their definitions.

