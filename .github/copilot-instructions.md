# GitHub Copilot Instructions for LLM-SA-IMODE

This document provides context and coding guidelines for GitHub Copilot when working with the LLM-SA-IMODE codebase.

## Project Context

LLM-SA-IMODE is a MATLAB-based evolutionary optimization algorithm that combines:
- Differential Evolution (DE) with multiple mutation operators
- Machine Learning (KNN classifier via Python integration)
- Self-adaptive parameter control mechanisms
- PlatEMO framework architecture

## Coding Conventions

### MATLAB Style

1. **Class Definitions**:
   - All algorithms extend `ALGORITHM` base class
   - All problems extend `PROBLEM` base class
   - Use `classdef ClassName < ParentClass` syntax

2. **Method Structure**:
   - Main algorithm logic goes in `main(Algorithm, Problem)` method
   - Use `Setting(obj)` for problem initialization
   - Use `CalObj(obj, PopDec)` for objective function calculation

3. **Naming Conventions**:
   - CamelCase for class names (e.g., `LLM_SA_IMODE`)
   - CamelCase for method names (e.g., `CalObj`, `ParameterSet`)
   - Descriptive variable names in lowercase with underscores (e.g., `train_data`, `best_off`)
   - Capital letters for matrices/vectors (e.g., `Population`, `Archive`, `MCR`, `MF`)

4. **Comments**:
   - Use `%` for single-line comments
   - Chinese comments are present in original code for clarity to original authors
   - English comments preferred for new code
   - Include references in header comments

### Algorithm-Specific Patterns

1. **Population Handling**:
   ```matlab
   % Access population decisions
   PopDec = Population.decs
   
   % Access population objectives
   PopObj = Population.objs
   
   % Create new solutions
   Offspring = SOLUTION(OffDec)
   ```

2. **Parameter Adaptation**:
   - MCR (crossover rate): Must be in range [0, 1]
   - MF (mutation factor): Must be in range [0, 1]
   - MOP (operator probabilities): Must sum to 1
   - Always normalize probabilities after updates

3. **Machine Learning Integration**:
   ```matlab
   % Python sklearn interface
   clf = py.sklearn.neighbors.KNeighborsClassifier(int16(k))
   clf.fit(py.numpy.array(Xtr), py.numpy.array(Y_lable))
   predictions = clf.predict(py.numpy.array(Xte))
   
   % Convert Python results to MATLAB
   matlab_array = double(predictions)'
   ```

4. **Fitness Evaluation**:
   - Use `FitnessSingle(Population)` for single-objective optimization
   - Always check termination with `Algorithm.NotTerminated(Population)`
   - Track function evaluations via `Problem.FE`

### PlatEMO Framework Integration

1. **Required Methods**:
   - Every algorithm must implement `main(Algorithm, Problem)`
   - Use `Algorithm.ParameterSet(default1, default2, ...)` to get parameters
   - Use `Problem.Initialization()` to generate initial population

2. **Framework Globals**:
   ```matlab
   global run_inter  % Iteration counter
   global record     % Objective value history
   ```

3. **Termination Handling**:
   - Use `while Algorithm.NotTerminated(Population)` loop
   - Framework automatically tracks function evaluations
   - Custom termination conditions can check convergence

### Data Structures

1. **Population Arrays**:
   - `Population.decs`: Decision variables (N × D matrix)
   - `Population.objs`: Objective values (N × M matrix)
   - `Population.cons`: Constraint violations (N × C matrix)
   - `Population.best`: Best solution in population

2. **Archive**:
   - Store replaced solutions for diversity
   - Maintain size: `Archive(randperm(end, min(end, ceil(aRate*N))))`

3. **Training Data**:
   - `train_data`: Cell array storing historical solutions
   - `Incre_learning`: Matrix for incremental learning samples
   - Always maintain unique solutions in training set

## Common Patterns

### Differential Evolution Operators

When implementing new DE operators:
```matlab
% Standard DE mutation patterns
OffDec = PopDec + F.*(Xp1 - PopDec + Xr1 - Xr2)  % current-to-pbest
OffDec = F.*(Xr1 + Xp2 - Xr3)                     % weighted difference

% Eigencoordinate system mutation
OffDec = PopDec + F*B*R*B'.*(Xp1 - PopDec + Xr1 - Xr3)
```

### Crossover

```matlab
if rand < 0.4
    % Binomial crossover
    Site = rand(size(CR)) > CR
    OffDec(Site) = PopDec(Site)
else
    % Exponential crossover
    p1 = randi(Problem.D, N, 1)
    p2 = arrayfun(@(S)find([rand(1,Problem.D),2]>CR(S,1),1), 1:N)
    % Apply crossover logic
end
```

### Selection

```matlab
% Calculate fitness improvement
delta = FitnessSingle(Population) - FitnessSingle(Offspring)
replace = delta > 0

% Update population and archive
Archive = [Archive, Population(replace)]
Population(replace) = Offspring(replace)
```

## Important Constraints

1. **Memory Management**:
   - Use `clearvars` to free large temporary variables
   - Limit training set size to prevent memory issues
   - Clear loop variables after intensive computations

2. **Numerical Stability**:
   - Add small epsilon to denominators: `denominator + eps`
   - Clip values to valid ranges: `max(lower, min(upper, value))`
   - Use robust statistics (median, MAD) instead of mean/std when appropriate

3. **Python-MATLAB Interface**:
   - Always convert data types explicitly: `int16()`, `double()`
   - Convert Python arrays to MATLAB: `double(predictions)'`
   - Ensure numpy arrays are properly formatted

## Testing Patterns

When testing the algorithm:
```matlab
% Test on a single problem
[Dec, Obj, Con] = platemo('algorithm', @LLM_SA_IMODE, ...
                          'problem', @F1, ...
                          'N', 5, 'M', 1, 'D', 50, 'maxFE', 1000)

% Check convergence
fprintf('Best objective: %.4e\n', min(Obj))
```

## Performance Considerations

1. **Vectorization**: Always prefer vectorized operations over loops
2. **Preallocate**: Preallocate arrays when size is known
3. **Avoid Deep Copies**: Use indexing instead of copying large arrays
4. **Sparse Operations**: Consider sparse matrices for large-scale problems

## Security Notes

- Never commit credentials or sensitive data
- Validate all user inputs for custom problems
- Be cautious with `eval()` or dynamic code execution
- Ensure file paths are properly validated in `run.m`

## Additional Resources

- PlatEMO documentation: Focus on ALGORITHM and PROBLEM base classes
- MATLAB OOP: Understand handle classes and inheritance
- Python-MATLAB Interface: Review `pyenv` and type conversion
- Differential Evolution: Familiarize with DE mutation and crossover schemes
