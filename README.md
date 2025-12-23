# LLM-SA-IMODE

## Overview

LLM-SA-IMODE (Large Language Model Enhanced Self-Adaptive Improved Multi-Operator Differential Evolution) is a MATLAB-based evolutionary optimization algorithm that combines differential evolution with machine learning techniques for solving large-scale single-objective optimization problems.

## Features

- **Multi-operator differential evolution** with 5 different mutation operators
- **Machine learning integration** using KNN classifier for solution quality prediction
- **Self-adaptive parameter control** using quantum-inspired and relativistic mechanisms
- **Incremental learning** for continuous model improvement
- **Eigencoordinate system** for improved search space exploration
- **Archive-based evolution** for maintaining solution diversity

## Algorithm Description

The LLM-SA-IMODE algorithm extends the traditional IMODE (Improved Multi-Operator Differential Evolution) by incorporating:

1. **LLM-Enhanced Parameter Adaptation**:
   - `LLM_MCR`: Quantum superposition weighting with relativistic momentum adaptation for crossover rate
   - `LLM_MF`: Robust statistical estimation with moment-constrained weighting for mutation factor
   - `LLM_OAM`: Adaptive operator probability adjustment using weighted harmonic mean

2. **Machine Learning Components**:
   - KNN-based classifier to predict solution quality before evaluation
   - Incremental learning to improve model accuracy over time
   - Training set construction from population history

3. **Five Mutation Operators**:
   - OP1: `x + F*(xp1 - x + xr1 - xr2)`
   - OP2: `x + F*(xp1 - x + xr1 - xr3)`
   - OP3: `F*(xr1 + xp2 - xr3)`
   - OP4: `x + F*B*R*B'*(xp1 - x + xr1 - xr3)` (eigencoordinate system)
   - OP5: `F*B*R*B'*(xr1 + xp2 - xr3)` (eigencoordinate system)

## Requirements

- MATLAB R2018a or later
- Python 3.x with scikit-learn and numpy (for KNN classifier)
- MATLAB Python interface configured (`pyenv`)

## File Structure

```
LLM-SA-IMODE/
├── ALGORITHM.m          # Base algorithm class (from PlatEMO framework)
├── LLM_SA_IMODE.m      # Main algorithm implementation
├── platemo.m           # PlatEMO framework entry point
├── refine_evo.m        # Solution refinement function
├── run.m               # Experiment runner script
└── Problems/
    ├── PROBLEM.m       # Base problem class
    ├── SOLUTION.m      # Solution representation class
    ├── UserProblem.m   # Custom problem definition interface
    ├── F1-F7/          # CEC2013 benchmark functions
    │   ├── F1.m        # Shifted elliptic function
    │   ├── F2.m        # Benchmark function 2
    │   ├── F3.m        # Benchmark function 3
    │   ├── F4.m        # Benchmark function 4
    │   ├── F5.m        # Benchmark function 5
    │   ├── F6.m        # Benchmark function 6
    │   └── F7.m        # Benchmark function 7
    └── YLL/            # Additional problem set
```

## Installation

1. Clone the repository:
```bash
git clone https://github.com/whbuaa/LLM-SA-IMODE.git
cd LLM-SA-IMODE
```

2. Install Python dependencies:
```bash
pip install numpy scikit-learn
```

3. Configure MATLAB Python interface:
```matlab
% In MATLAB, check Python environment
pyenv

% If needed, set Python version
pyenv('Version', '/path/to/python')
```

4. Add the repository to MATLAB path:
```matlab
addpath(genpath('/path/to/LLM-SA-IMODE'))
```

## Usage

### Basic Usage

Run the algorithm on benchmark problems using `run.m`:

```matlab
% Edit run.m to configure:
run_N = 20;                        % Number of independent runs
algorithms_name = {@LLM_SA_IMODE}; % Algorithm to test
problem_name = {@F1,@F2,@F3,@F4,@F5,@F6,@F7}; % Problems to solve
D_N = {50};                        % Problem dimensions

% Run the experiments
run
```

### Using PlatEMO Interface

You can also use the algorithm through the PlatEMO framework:

```matlab
% Run LLM-SA-IMODE on problem F1 with 50 variables
[Dec, Obj, Con] = platemo('algorithm', @LLM_SA_IMODE, ...
                          'problem', @F1, ...
                          'N', 5, ...           % Population size
                          'M', 1, ...           % Number of objectives
                          'D', 50, ...          % Number of variables
                          'maxFE', 1000);       % Max function evaluations
```

### Algorithm Parameters

- **minN**: Minimum population size (default: 4)
- **aRate**: Ratio of archive size to population size (default: 5, recommended: 2.6)

Example with custom parameters:

```matlab
% Use recommended parameter values
Algorithm = LLM_SA_IMODE('parameter', {4, 2.6});
```

## Output

The `run.m` script generates `.mat` files containing:

- **sign_res**: Raw results for significance testing
- **med_res**: Median and IQR (Interquartile Range) values
- **avg_res**: Mean and standard deviation values
- **avg_time**: Average runtime and standard deviation

Results are organized with:
- **Rows**: Different problems and dimensions
- **Columns**: Algorithm results (2 columns per algorithm: value + statistical measure)

## Implementation Details

### Parameter Adaptation

- **MCR (Crossover Rate)**: Uses quantum-inspired adaptation with relativistic momentum and topological persistence scaling
- **MF (Mutation Factor)**: Employs robust statistical estimation with adaptive moment-constrained weighting
- **MOP (Operator Probabilities)**: Dynamically adjusted based on operator effectiveness using weighted harmonic mean

### Machine Learning Integration

The algorithm uses a KNN classifier (k=3) to predict whether an offspring will be better than its parent. This reduces unnecessary function evaluations by:
1. Training on historical population data
2. Predicting offspring quality before evaluation
3. Only evaluating promising candidates
4. Incrementally updating the model with incorrect predictions

### Eigencoordinate System

For operators 4 and 5, the algorithm computes an eigencoordinate system from the top solutions to better explore the search space along principal component directions.

## References

Based on:
- K. M. Sallam, S. M. Elsayed, R. K. Chakrabortty, and M. J. Ryan, "Improved multi-operator differential evolution algorithm for solving unconstrained problems," Proceedings of the IEEE Congress on Evolutionary Computation, 2020.
- Benchmark functions from CEC2013 special session on large-scale global optimization

Uses the PlatEMO framework:
- Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, "PlatEMO: A MATLAB platform for evolutionary multi-objective optimization," IEEE Computational Intelligence Magazine, 2017, 12(4): 73-87.

## License

This project uses the PlatEMO framework. For research purposes, please acknowledge the use of PlatEMO and cite the relevant papers.

## Contributing

Contributions are welcome! Please ensure any modifications maintain compatibility with the PlatEMO framework structure.

## Contact

For questions and issues, please open an issue on the GitHub repository.
