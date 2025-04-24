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

## How is a name bound
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





