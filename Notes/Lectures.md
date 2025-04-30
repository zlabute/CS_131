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
    - Dynamic Chain (Linked List) 
        - stack pointer and base pointer
        - at bottom of frame next to base pointer need to store the caller's base pointer
        - each frame specifies the base pointer of its caller (Linked List)
    - SOLUTION: Static Chain (Linked List)
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






