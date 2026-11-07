---
name: go-patterns
description: A guide of best practices and principles when writing, reviewing, and auditing Golang code. Use this when editing and reviewing Golang code.
---

This is a set of principles and best practices that you use when writing, reviewing, and auditing Go code.

# Core Principles
Go as a language is designed to be 
- simple
- readable
- maintainable
## Shorter is Better
Try to find the shortest name that is self explanatory. (i.e. Prefer MarshalIndent to MarshalWithIndentation.)

Don't forget that the package name will appear before the identifier you chose
- In package encoding/json we find the type Encoder, not JSONEncoder
- It is referred to as `json.Encoder()`

# Handle Errors First 
```go
// BAD: This will create nesting that will make the code harder to read for the reader
result, err := someFunc()

if err == nil {
    err := doTask()
    if err == nil {
        doNextTask()
    }
}

// GOOD: This reduces the load on the reader
result, err := someFunc()
if err != nil {
    ...
}

err = doTask()
if err != nil {
    ...
}
```
# doc.go 
Packages with more than one file always has (by convention) a `doc.go` file. 

# Use Interfaces for APIs 
```go
// BAD: Couples the WriteToFile to a specific object (*os.File). Bad for testing
func (g *Gopher) WriteToFile(f *os.File) (int64, error) { ... }

// GOOD: Use an interface instead
func (g *Gopher) WriteToWriter(f io.Writer) (int64, error) { ... }
```

Only use the methods you need. If you only need to write, don't use `io.ReadWriter`

# Concurrency Practices
## Use goroutines to manage state 
Use a chan or a struct with a chan to communicate with a goroutine
```go
type Server struct{ quit chan bool }

func NewServer() *Server {
    s := &Server{make(chan bool)}
    go s.run()
    return s
}

func (s *Server) run() {
    for {
        select {
        case <-s.quit:
            fmt.Println("finishing task")
            time.Sleep(time.Second)
            fmt.Println("task done")
            s.quit <- true
            return
        case <-time.After(time.Second):
            fmt.Println("running task")
        }
    }
}

func (s *Server) Stop() {
    fmt.Println("server stopping")
    s.quit <- true
    <-s.quit
    fmt.Println("server stopped")
}

func main() {
    s := NewServer()
    time.Sleep(2 * time.Second)
    s.Stop()
}
```
## Use buffered channels to avoid leaks 
```go
// BAD: errc can cause leaks
errc := make(chan error)

// GOOD: having a maximum length prevents the channel from blocking the program 
errc := make(chan error, len(addrs))

// GOOD: If you can't predict the channel's length, opt to use either a quit chan or a ctx.Done() channel 
func worker(ctx context.Context, errc <- chan error) {
    select {
        case err := <-errc:
            process(err)
        case <-ctx.Done():
            return
    }
}

// Alternatively, you can use a quit chan
func worker(errc <- chan error, quit <- chan struct{}) {
    select {
        case err := <-errc:
            process(err)
        case <-quit:
            return
    }
}
```