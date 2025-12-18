# LLM-SA-IMODE

Surrogate-assisted evolutionary algorithm automatic design approach for expensive optimization via large language models.

## Overview

LLM-SA-IMODE is a MATLAB-based implementation of an improved multi-operator differential evolution algorithm that leverages large language models (LLMs) for surrogate-assisted optimization. This approach is designed for solving expensive optimization problems where function evaluations are computationally costly.

## Features

- **Surrogate-Assisted Optimization**: Uses machine learning models to approximate expensive objective functions
- **Multi-Operator Differential Evolution**: Implements improved differential evolution with multiple mutation operators
- **LLM Integration**: Leverages large language models for intelligent algorithm design
- **Incremental Learning**: Supports online learning to improve surrogate model accuracy
- **PlatEMO Framework**: Built on the PlatEMO platform for evolutionary multi-objective optimization

## Requirements

- MATLAB (R2019b or later recommended)
- PlatEMO framework

## Project Structure

```
.
├── ALGORITHM.m           # Base algorithm class definition
├── LLM_SA_IMODE.m       # Main algorithm implementation
├── run.m                # Main script to run experiments
├── platemo.m            # PlatEMO platform interface
├── refine_evo.m         # Low-dimensional refinement evolution
└── Problems/            # Test problem definitions
    ├── F1-F7/          # Standard test functions (F1-F7)
    ├── PROBLEM.m       # Base problem class
    ├── SOLUTION.m      # Solution representation class
    └── UserProblem.m   # User-defined problem template
```

## Usage

### Basic Example

To run the algorithm on test problems:

1. Open MATLAB and navigate to the project directory
2. Edit the `run.m` file to configure parameters:
   - `run_N`: Number of independent runs
   - `algorithms_name`: Algorithm to use (default: `@LLM_SA_IMODE`)
   - `problem_name`: Test problems to solve (e.g., `@F1`, `@F2`, etc.)
   - `D_N`: Problem dimensions (e.g., `{10, 50, 100}`)

3. Run the script:
```matlab
run
```

### Configuration

Key parameters in `run.m`:
- `N`: Population size (default: 5)
- `M`: Number of objectives (default: 1 for single-objective)
- `D`: Number of decision variables (problem dimension)
- `maxFE`: Maximum number of function evaluations (default: 1000)

### Algorithm Parameters

The LLM_SA_IMODE algorithm accepts the following parameters:
- `minN`: Minimum population size (default: 4)
- `aRate`: Ratio of archive size to population size (default: 5)

## Output

The algorithm generates `.mat` files containing:
- `*_sign_res.mat`: Results for significance comparison
- `*_med_res.mat`: Median and IQR (Interquartile Range) results
- `*_avg_res.mat`: Average results with standard deviation
- `*_avg_time.mat`: Average execution time with standard deviation

Results are organized with:
- Rows: Test problems
- Columns: Algorithm results (pairs of median/IQR or mean/std)

## Test Problems

The repository includes seven standard test functions (F1-F7) for benchmarking:
- F1-F7: Single-objective optimization test functions with varying characteristics

## Algorithm Details

### LLM-SA-IMODE

The algorithm combines:
1. **Differential Evolution**: Multiple mutation strategies for exploration and exploitation
2. **Surrogate Models**: Machine learning models to reduce expensive function evaluations
3. **Dimensionality Reduction**: Projects solutions to lower-dimensional space for efficient evolution
4. **Adaptive Parameters**: Self-adaptive control parameters (CR, F) for mutation and crossover

### Reference

The algorithm is based on:
> K. M. Sallam, S. M. Elsayed, R. K. Chakrabortty, and M. J. Ryan, "Improved multi-operator differential evolution algorithm for solving unconstrained problems," Proceedings of the IEEE Congress on Evolutionary Computation, 2020.

## Citation

If you use this code in your research, please acknowledge the use of PlatEMO:
> Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, "PlatEMO: A MATLAB platform for evolutionary multi-objective optimization [educational forum]," IEEE Computational Intelligence Magazine, 2017, 12(4): 73-87.

## License

Copyright (c) 2021 BIMK Group. You are free to use the PlatEMO for research purposes. All publications which use this platform or any code in the platform should acknowledge the use of "PlatEMO" and reference the citation above.

## Contributing

Contributions are welcome! Please ensure your code follows the existing structure and includes appropriate documentation.

## Contact

For questions or issues, please open an issue on the GitHub repository.
