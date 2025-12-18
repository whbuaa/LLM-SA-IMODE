# Copilot Instructions for LLM-SA-IMODE

This document provides guidance to GitHub Copilot for working with the LLM-SA-IMODE codebase.

## Project Overview

LLM-SA-IMODE is a MATLAB-based implementation of a surrogate-assisted evolutionary algorithm that uses Large Language Models for automatic algorithm design in expensive optimization problems.

## Code Structure and Conventions

### Language and Style
- **Language**: MATLAB (R2018a or later)
- **File Extension**: `.m` for MATLAB scripts and classes
- **Class Definition**: Use classdef syntax for classes
- **Comments**: Use `%` for single-line comments, `%{...%}` for multi-line comments

### Project Architecture

1. **Main Algorithm** (`LLM_SA_IMODE.m`)
   - Implements the core optimization algorithm
   - Inherits from `ALGORITHM` base class
   - Uses differential evolution with multiple operators
   - Includes surrogate model training and incremental learning

2. **Problem Definitions** (`Problems/`)
   - Each problem is a MATLAB class inheriting from `PROBLEM`
   - Problems define objective functions and constraints
   - Two main problem sets: F1-F7 (standard) and SOP_F1-F13 (extended)

3. **Framework Integration** (`platemo.m`)
   - Entry point for running optimizations
   - Handles parameter parsing and algorithm execution
   - Compatible with PlatEMO framework conventions

### Naming Conventions

- **Classes**: PascalCase (e.g., `LLM_SA_IMODE`, `ALGORITHM`)
- **Functions**: camelCase (e.g., `ParameterSet`, `Initialization`)
- **Variables**: camelCase for local variables (e.g., `Population`, `Archive`)
- **Constants**: UPPER_CASE for algorithm parameters (e.g., `MCR`, `MF`, `MOP`)
- **Problem Functions**: Use descriptive names (e.g., `F1`, `F2`, `SOP_F1`)

### Code Patterns

#### Algorithm Structure
```matlab
classdef AlgorithmName < ALGORITHM
    methods
        function main(Algorithm, Problem)
            % Parameter setting
            [param1, param2] = Algorithm.ParameterSet(default1, default2);
            
            % Generate initial population
            Population = Problem.Initialization();
            
            % Optimization loop
            while Algorithm.NotTerminated(Population)
                % Algorithm logic here
            end
        end
    end
end
```

#### Problem Definition
```matlab
classdef ProblemName < PROBLEM
    methods
        function Setting(obj)
            % Define problem properties
            obj.M = 1;  % Number of objectives
            obj.D = 50; % Number of decision variables
        end
        
        function PopObj = CalObj(obj, PopDec)
            % Calculate objective values
            PopObj = ...;  % Objective function computation
        end
    end
end
```

### Important Functions and Methods

- `Algorithm.ParameterSet(...)`: Get algorithm parameters with defaults
- `Problem.Initialization()`: Generate initial population
- `Algorithm.NotTerminated(Population)`: Check termination conditions
- `FitnessSingle(Population)`: Calculate fitness for single-objective optimization
- `Problem.FE`: Current number of function evaluations
- `Problem.maxFE`: Maximum allowed function evaluations

### Data Structures

- **Population**: Array of `SOLUTION` objects containing decision variables and objectives
- **Archive**: Historical solutions for reference
- **train_data**: Cell array storing training data for surrogate models
- **MCR/MF**: Arrays storing crossover rate and mutation factor memory

### Mathematical Operations

- Use MATLAB's built-in vectorized operations when possible
- `sort()`, `min()`, `max()` for finding best solutions
- `randperm()` for random permutations
- `rand()`, `randn()` for random number generation

### File I/O

- Use `save()` to save results to `.mat` files
- Use `load()` to load data from `.mat` files
- Results typically saved in current directory or specified path

### Debugging and Testing

- Use `disp()` or `fprintf()` for console output
- Use `tic` and `toc` for timing code execution
- Test with small population sizes (N=5-10) and few iterations for quick validation

## Common Tasks

### Adding a New Optimization Problem

1. Create a new `.m` file in appropriate `Problems/` subdirectory
2. Define class inheriting from `PROBLEM`
3. Implement `Setting()` method to define problem dimensions
4. Implement `CalObj()` method with objective function
5. Add problem to test suite in `run.m` if needed

### Modifying Algorithm Parameters

1. Update default values in `ParameterSet()` call
2. Document parameter meaning in class header comments
3. Test with various parameter values to ensure robustness

### Adding New Operators

1. Define operator logic within the main optimization loop
2. Update `MOP` (operator probability) array if needed
3. Ensure operator maintains population structure consistency

## Best Practices

1. **Vectorization**: Prefer vectorized operations over loops for efficiency
2. **Memory Pre-allocation**: Pre-allocate arrays when size is known
3. **Comments**: Include meaningful comments explaining algorithm steps
4. **Parameter Documentation**: Document all parameters in class header
5. **Error Handling**: Check for invalid inputs and edge cases
6. **Reproducibility**: Use fixed random seeds when needed for debugging

## References and Dependencies

- PlatEMO framework conventions
- IEEE CEC benchmark function definitions
- IMODE algorithm from Sallam et al. (2020)

## Testing

- Run small-scale tests with `N=5`, `maxFE=100` for quick validation
- Use `run.m` for comprehensive batch testing
- Verify output file generation and format
- Check convergence curves and final solution quality

## Performance Considerations

- MATLAB is 1-indexed (arrays start at index 1, not 0)
- Avoid growing arrays dynamically inside loops
- Use built-in functions like `min()`, `max()`, `sort()` for efficiency
- Profile code with MATLAB profiler to identify bottlenecks

## Common Pitfalls

- Don't forget to update both `Population` and `Archive` when modifying algorithm
- Ensure population size doesn't drop below `minN`
- Check that all operators produce valid solutions within problem bounds
- Remember to increment function evaluation counter appropriately
