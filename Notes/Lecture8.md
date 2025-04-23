# Types and Polymorphism

## Types
- `Object`  
- `Integer`  
- `String`  
- `Thread`

## Polymorphism

### Parametric Polymorphism
- A list type that can hold any element type  
- Syntax: `List<T>`

#### Common Implementations
- `List<T>` (interface)  
- `LinkedList<T>` (class)  

## Java Generics

### Without Generics
- Relies on **dynamic** type checking at runtime  
- Less safe (risk of `ClassCastException`)

### With Generics
- Defines type parameters at compile-time  
- **Makes code safer** by catching type errors early  

```Java

List l = new LinkedList(),
l.add(new Integer(0)),

```

