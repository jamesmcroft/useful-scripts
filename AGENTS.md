# AGENTS.md - Useful Scripts (Codex Agent Guide)

> **Purpose**
> This file is the single source of truth for how OpenAI Codex-powered agents should read, modify, generate, and review code in this repository.

---

## 0) Repo Orientation (Read Me First)

- **Global Scripts**: Core script loading is handled in `./UsefulScripts/UsefulScripts.psd1`.
- **Module Structure**: Scripts are categorized into domain specific folders under `./<domain>/*.psm1`, each containing `README.md` files for guidance.
  - `./azure/` - Scripts for interacting with Azure, with folders for specific services (e.g. `kubernetes`, etc.).
  - `./build/` - Scripts to support building solutions, usually included as part of CI/CD pipelines.
  - `./docker/` - Scripts for working with Docker containers and images.
  - `./dotnet/` - Scripts for .NET related tasks.
  - `./git/` - Scripts for simplifying complex Git operations.
  - `./json/` - Scripts for working with JSON files.
  - `./python/` - Scripts for Python related tasks.
  - **Note**: New domains should be created as needed to keep scripts organized.
- **Documentation**: Each domain has a `README.md` file that provides an overview and usage instructions for the scripts within that domain. The root `README.md` provides general information about the repository.

## 1) Best Practices

**Golden rules for all changes**

1. **Security-first** following OWASP Top 10 guidelines.
2. **Domain-Driven Design** and SOLID principles.
3. **Idempotency**: Scripts should be safe to run multiple times without causing unintended side effects.
4. **Modularity**: Scripts should be modular and reusable, avoiding duplication of code.

## 2) PowerShell Standards

In general, all PowerShell scripts should adhere to the following standards:

- **Naming Conventions**: Use PascalCase for function names and camelCase for variable names.
- **Approved Verbs**: PowerShell modules should use a verb-noun pair for naming functions, following the [PowerShell Approved Verbs](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-7.5). You can also find a list of common verbs listed in section 3.
- **Commenting**: Include comments for complex logic and use XML documentation comments for functions.
- **Aliasing**: Aliases should be leveraged to simplify common tasks, but avoid overuse that could reduce readability.
- **Error Handling**: Implement robust error handling using `try/catch` blocks and provide meaningful error messages.

## 3) Approved PowerShell Verbs

- **Add** - Adds a resource to a container or attaches an item to another item.
- **Build** - Creates an artifact out of some set of input files.
- **Clear** - Removes all the resources from a container but doesn't delete the container.
- **Close** - Changes the state of a resource to make it inaccessible, unavailable, or unusable.
- **Convert** - Changes the data from one representation to another.
- **Copy** - Copies a resource to another name or to another container.
- **Deploy** - Sends a resource to a remote target in such a way that a consumer of that can access it after the deployment is complete.
- **Edit** - Modifies existing data by adding or removing content.
- **Enter** - Specifies an action that allows the user to move into a resource.
- **Exit** - Sets the current environment or context to the most recently used context.
- **Export** - Encapsulates the primary input into a persistent data store.
- **Find** - Looks for an object in a container that's unknown, implied, optional, or specified.
- **Format** - Arranges objects in a specified format for display.
- **Get** - Specifies an action that retrieves a resource.
- **Import** - Retrieves data from a persistent data store and makes it available in the current session.
- **Install** - Places a resource in a location, and optionally initializes it for use.
- **Invoke** - Executes a specific action or method on a resource.
- **Join** - Combines resources into one resource.
- **Merge** - Creates a single resource from multiple resources.
- **Move** - Moves a resource from one location to another.
- **New** - Creates a new resource.
- **Open** - Changes the state of a resource to make it accessible, available, or usable.
- **Pop** - removes an item from the top of a stack.
- **Push** - Adds an item to the top of a stack.
- **Read** - Acquires information from a source.
- **Remove** - Deletes a resource from a container.
- **Rename** - Changes the name of a resource.
- **Reset** - Restores a resource to its original state.
- **Resize** - Changes the size of a resource.
- **Restart** - Stops an operation and then starts it again.
- **Resume** - Starts an operation that has been suspended.
- **Save** - Preserves data to avoid loss.
- **Send** - Delivers a resource to a destination.
- **Set** - Replaces data on an existing resource or creates a resource that contains some data.
- **Split** - Separates parts of a resource.
- **Start** - Initiates an operation or makes a resource active.
- **Stop** - Halts an operation or makes a resource inactive.
- **Suspend** - Pauses an operation without losing state information.
- **Uninstall** - Removes a resource from a location and optionally cleans up associated data.
- **Update** - Brings a resource up-to-date to maintain its state, accuracy, or compliance.
- **Write** - Adds information to a target.

## 4) How to Plan a Change (Step-by-Step)

1. **Understand the codebase**: review existing code and documentation to understand architecture and patterns.
2. **Identify domains**: locate appropriate domain folders for your change. If introducing a new domain, propose one with a minimal slice.
3. **Implement code** with adherence to best practices and PowerShell standards.
4. **Security review** your diff: explicitly call out mitigations for risks in documentation.
5. **Run local checks**: ensure code passes linting and tests.
6. **Modify documentation**: update relevant `README.md` files to reflect changes, if required, including usage examples.
