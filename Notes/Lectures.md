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

##### Common Implementations
- `List<T>` (interface)  
- `LinkedList<T>` (class)  

##### Java Generics

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

- FIRST SUCCESFUL CODING LANGUAGE (FORTRAN):
    - ran without a stack
    - Pros and Cons:
        - \+simple 
        - \- wasted memory/too small 
        - \- lacks flexibility
        - \- recursion does not work (leads to undefined behavior)
    - generally lack of stack is called a failure 
        

     




