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

### Binding Time
- when does the binding occur
- options
    - during execution



