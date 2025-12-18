# GitHub Copilot Instructions for LLM-SA-IMODE

This document provides context and guidelines for GitHub Copilot when working with the LLM-SA-IMODE codebase.

## Project Context

LLM-SA-IMODE is a MATLAB-based implementation of a surrogate-assisted evolutionary algorithm that uses large language models for expensive optimization problems. The codebase follows the PlatEMO framework structure.

## Language and Framework

- **Primary Language**: MATLAB
- **Framework**: PlatEMO (Platform for Evolutionary Multi-objective Optimization)
- **Paradigm**: Object-oriented MATLAB with class hierarchies

## Code Structure and Conventions

### Class Hierarchy

1. **ALGORITHM** - Base class for all algorithms
   - Properties: `parameter`, `save`, `outputFcn`, `pro`, `result`, `metric`
   - Main method: `main(Algorithm, Problem)` - implements algorithm logic
   - Helper method: `NotTerminated(Population)` - checks termination criteria
   
2. **PROBLEM** - Base class for optimization problems
   - Defines problem properties: dimensions, objectives, constraints
   
3. **SOLUTION** - Represents individual solutions
   - Contains decision variables (`decs`), objective values (`objs`), constraints (`cons`)

### Naming Conventions

- **Classes**: PascalCase (e.g., `LLM_SA_IMODE`, `ALGORITHM`, `PROBLEM`)
- **Variables**: camelCase or snake_case
  - Population variables: `Population`, `Archive`
  - Parameters: `MCR`, `MF`, `MOP`
  - Counters: `i`, `j`, `k`, `cycle`
- **Functions**: camelCase (e.g., `refine_evo`, `platemo`)
- **Files**: Match class names or function names

### Common Patterns

#### Algorithm Implementation

```matlab
classdef MyAlgorithm < ALGORITHM
    methods
        function main(Algorithm, Problem)
            %% Parameter setting
            [param1, param2] = Algorithm.ParameterSet(default1, default2);
            
            %% Generate random population
            Population = Problem.Initialization();
            
            %% Optimization
            while Algorithm.NotTerminated(Population)
                % Evolution logic here
            end
        end
    end
end
```

#### Population Operations

- `Population(indices)` - Select subset of population
- `FitnessSingle(Population)` - Calculate fitness values
- `[~, rank] = sort(FitnessSingle(Population))` - Rank solutions
- `Population.decs` - Access decision variables
- `Population.objs` - Access objective values

#### Problem Interface

```matlab
% Run algorithm on problem
[Dec, Obj, Con] = platemo('algorithm', @AlgName, 'problem', @ProbName, ...
                          'N', popSize, 'M', numObj, 'D', numVar, 'maxFE', maxEvals);
```

### Algorithm Components

#### Key Variables

- `N` - Current population size
- `D` - Problem dimension (number of decision variables)
- `M` - Number of objectives
- `maxFE` - Maximum function evaluations
- `MCR` - Memory for crossover rate
- `MF` - Memory for scaling factor
- `MOP` - Multi-operator probabilities
- `Archive` - Archive of good solutions
- `Population` - Current population

#### Common Operations

- **Selection**: Use ranking and sorting
- **Mutation**: Differential evolution operators (rand/1, best/1, current-to-best/1)
- **Crossover**: Binomial or exponential crossover
- **Surrogate Models**: Train on `train_data`, use for prediction
- **Dimensionality Reduction**: Project to lower-dimensional space using PCA or eigencoordinate systems

## File-Specific Guidelines

### run.m

- Main execution script
- Configure experiment parameters here
- Update `cd` path (line 34) to correct result directory
- Results saved as `.mat` files

### LLM_SA_IMODE.m

- Main algorithm implementation
- Inherits from `ALGORITHM` base class
- Implements surrogate-assisted DE with incremental learning
- Uses multiple mutation operators
- Maintains archive of solutions

### refine_evo.m

- Performs evolution in reduced dimensional space
- Takes current population and evolves it
- Returns best offspring after evolution
- Uses eigencoordinate system for dimensionality reduction

### platemo.m

- Framework interface function
- Handles parameter parsing
- Runs algorithm on problem
- Returns decision variables, objectives, and constraints

## MATLAB-Specific Guidelines

### Array Indexing

- MATLAB uses 1-based indexing (not 0-based)
- Use `end` for last element
- Use `:` for all elements (e.g., `array(:, 1)` for first column)

### Matrix Operations

- Use `.` prefix for element-wise operations (`.*, ./, .^`)
- Use matrix multiplication without dot (`*`)
- Transpose with `'` or `.'` (non-conjugate)

### Common Functions

- `zeros()`, `ones()` - Create arrays
- `rand()`, `randn()` - Random number generation
- `sort()`, `sortrows()` - Sorting
- `size()`, `length()` - Get dimensions
- `find()` - Find indices
- `orth()` - Orthonormal basis
- `cov()` - Covariance matrix
- `prctile()` - Percentile calculation

### Function Handles

- Use `@` to create function handles (e.g., `@LLM_SA_IMODE`, `@F1`)
- Pass as parameters to other functions

## Comments

- Chinese comments are present in some files (legacy code)
- When adding new code, use English comments
- Follow existing comment style
- Document complex algorithms with section headers (`%%`)

## Testing and Validation

- No formal unit test framework in place
- Validation done by running experiments and comparing results
- Check algorithm convergence and solution quality
- Compare with baseline algorithms on standard test problems (F1-F7)

## Performance Considerations

- MATLAB is optimized for vectorized operations
- Avoid loops when possible, use array operations
- Pre-allocate arrays for better performance
- Function evaluations are expensive - minimize `Problem.Evaluation()` calls

## Common Pitfalls

1. **Path issues**: Update hardcoded paths in `run.m` (look for `cd` command with absolute path that needs to point to your result directory)
2. **Dimension mismatch**: Ensure array dimensions match for operations
3. **Class methods**: Must have `obj` or class name as first parameter
4. **Global state**: Be careful with persistent variables and global state in MATLAB

## When Suggesting Changes

1. **Maintain compatibility** with PlatEMO framework
2. **Follow existing patterns** for algorithm implementation
3. **Document parameters** with default values
4. **Test on standard problems** (F1-F7) before deployment
5. **Consider computational cost** - avoid unnecessary function evaluations
6. **Preserve class inheritance** structure

## Useful References

- PlatEMO documentation: Framework for evolutionary algorithms
- IEEE CEC test functions: Standard benchmark problems
- Differential Evolution: DE/rand/1/bin, DE/best/1/bin, etc.

## Getting Started

When working with this codebase:
1. Understand the algorithm flow in `LLM_SA_IMODE.m`
2. Check parameter settings in `run.m`
3. Look at test problems in `Problems/F1-F7/`
4. Follow the ALGORITHM base class interface
5. Use `platemo()` function for running experiments
