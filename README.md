# LLM-SA-IMODE

A surrogate-assisted evolutionary algorithm automatic design approach for expensive optimization via large language models.

## Overview

This project implements LLM-SA-IMODE (LLM-Surrogate Assisted Improved Multi-Operator Differential Evolution), an advanced optimization algorithm that combines:

- **Improved Multi-Operator Differential Evolution (IMODE)**: A robust evolutionary algorithm for optimization
- **Surrogate-Assisted Learning**: Reduces computational cost for expensive optimization problems
- **Large Language Model Integration**: Leverages LLM for intelligent algorithm design

## Features

- Multiple differential evolution operators for diverse search strategies
- Dynamic population size adjustment for efficient convergence
- Incremental learning with surrogate models
- Support for various benchmark optimization problems (F1-F7, SOP_F1-F13)
- Flexible parameter configuration

## Requirements

- MATLAB R2018a or later
- PlatEMO framework (included functionality)

## Project Structure

```
LLM-SA-IMODE/
├── LLM_SA_IMODE.m      # Main algorithm implementation
├── ALGORITHM.m          # Base algorithm class
├── platemo.m            # PlatEMO framework entry point
├── run.m                # Batch experiment runner
├── refine_evo.m         # Evolution refinement utilities
└── Problems/            # Optimization problem definitions
    ├── F1-F7/          # Standard benchmark functions (F1-F7)
    └── YLL/            # Extended benchmark functions (SOP_F1-F13)
```

## Usage

### Running a Single Optimization

```matlab
% Run LLM-SA-IMODE on a specific problem
[Dec, Obj, Con] = platemo('algorithm', @LLM_SA_IMODE, ...
                          'problem', @F1, ...
                          'N', 50, ...          % Population size
                          'M', 1, ...           % Number of objectives
                          'D', 50, ...          % Problem dimension
                          'maxFE', 1000);       % Maximum function evaluations
```

### Running Batch Experiments

The `run.m` script provides automated batch testing:

```matlab
% Edit run.m to configure:
% - algorithms_name: Algorithms to test
% - problem_name: Problems to solve
% - D_N: Problem dimensions
% - run_N: Number of runs per configuration

run  % Execute batch experiments
```

### Algorithm Parameters

The LLM-SA-IMODE algorithm accepts the following parameters:

- `minN` (default: 4): Minimum population size
- `aRate` (default: 5): Ratio of archive size to population size

Example with custom parameters:

```matlab
platemo('algorithm', @LLM_SA_IMODE, 'minN', 10, 'aRate', 3.0, ...
        'problem', @F1, 'N', 50, 'D', 50, 'maxFE', 1000);
```

## Optimization Problems

### Standard Benchmark Functions (F1-F7)

Located in `Problems/F1-F7/`, these include common optimization test functions.

### Extended Benchmark Functions (SOP_F1-F13)

Located in `Problems/YLL/`, these provide additional test cases for algorithm validation.

## Output

Results are saved as `.mat` files containing:

- `output_res`: Individual run results
- `output_med_res`: Median and IQR statistics
- `output_avg_res`: Mean and standard deviation
- `output_avg_time`: Execution time statistics

## Reference

Based on:

K. M. Sallam, S. M. Elsayed, R. K. Chakrabortty, and M. J. Ryan, "Improved multi-operator differential evolution algorithm for solving unconstrained problems," Proceedings of the IEEE Congress on Evolutionary Computation, 2020.

## License

Copyright (c) 2021 BIMK Group. This implementation uses the PlatEMO framework. All publications using this code should acknowledge the use of "PlatEMO" and reference:

Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, "PlatEMO: A MATLAB platform for evolutionary multi-objective optimization [educational forum]," IEEE Computational Intelligence Magazine, 2017, 12(4): 73-87.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Contact

For questions or collaborations, please open an issue on GitHub.
