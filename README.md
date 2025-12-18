# LLM-SA-IMODE

Large-scale Learning Machine assisted by Surrogate-Assisted Improved Multi-Operator Differential Evolution

## Overview

LLM-SA-IMODE is an advanced optimization algorithm that combines machine learning with evolutionary computation for solving large-scale optimization problems. The algorithm implements an improved multi-operator differential evolution approach enhanced with surrogate-assisted learning using K-Nearest Neighbors (KNN) classification.

This implementation is built on top of the [PlatEMO](https://github.com/BIMK/PlatEMO) platform for evolutionary multi-objective optimization.

## Key Features

- **Multi-Operator Differential Evolution**: Uses five different mutation operators for diverse exploration strategies
- **Surrogate-Assisted Learning**: Employs KNN classification to predict offspring quality before expensive fitness evaluations
- **Incremental Learning**: Continuously updates the training dataset with new solutions
- **Eigencoordinate System**: Transforms the search space to improve exploration efficiency
- **Adaptive Population Sizing**: Dynamically adjusts population size during evolution

## Requirements

- MATLAB R2018a or later (R2020b or later for GUI support)
- Python 3.x with scikit-learn library (for KNN classification)
- MATLAB Python integration configured

### Setting up MATLAB-Python Integration

```matlab
% Check Python version
pyenv

% If needed, configure Python
pyenv('Version', '/path/to/python3')
```

## Installation

1. Clone this repository:
```bash
git clone https://github.com/whbuaa/LLM-SA-IMODE.git
cd LLM-SA-IMODE
```

2. Ensure Python scikit-learn is installed:
```bash
pip install scikit-learn numpy
```

3. Open MATLAB and navigate to the repository directory

## File Structure

```
LLM-SA-IMODE/
├── ALGORITHM.m          # Base algorithm class
├── LLM_SA_IMODE.m       # Main LLM-SA-IMODE algorithm implementation
├── platemo.m            # PlatEMO platform main function
├── refine_evo.m         # Refinement evolution function with surrogate model
├── run.m                # Example script for running experiments
└── Problems/            # Test problem functions
    ├── F1-F7/          # Benchmark functions (F1-F7)
    │   ├── F1.m        # Shifted elliptic function
    │   ├── F2.m        # Generalized Rosenbrock's function
    │   ├── F3.m        # Ackley's function
    │   ├── F4.m        # Generalized Griewank's function
    │   ├── F5.m        # Generalized Rastrigin's function
    │   ├── F6.m        # Shifted elliptic function (CEC2013)
    │   └── F7.m        # Shifted elliptic function (CEC2013)
    ├── YLL/            # Additional single-objective problems (SOP_F1-F13)
    ├── PROBLEM.m       # Base problem class
    ├── SOLUTION.m      # Solution representation class
    └── UserProblem.m   # User-defined problem template
```

## Usage

### Basic Usage

Run the algorithm on a single problem:

```matlab
% Run LLM-SA-IMODE on problem F1 with 50 dimensions
[Dec, Obj, Con] = platemo('algorithm', @LLM_SA_IMODE, ...
                          'problem', @F1, ...
                          'N', 5, ...           % Population size
                          'M', 1, ...           % Number of objectives
                          'D', 50, ...          % Number of dimensions
                          'maxFE', 1000);       % Maximum function evaluations
```

### Batch Experiments

Use the provided `run.m` script to conduct comprehensive experiments:

```matlab
% Edit run.m to configure:
% - run_N: Number of independent runs
% - algorithms_name: Algorithms to test
% - problem_name: Problems to solve
% - D_N: Problem dimensions

% Before running, update the cd path in run.m (line 34)
% to your local directory for saving results

run
```

**Important**: Before running `run.m`, update line 34 with your local path:
```matlab
cd 'YOUR_PATH_HERE'  % Replace with your actual path
```

### Algorithm Parameters

The LLM-SA-IMODE algorithm accepts the following parameters:

- `minN` (default: 4): Minimum population size during evolution
- `aRate` (default: 5): Ratio of archive size to population size

Example with custom parameters:
```matlab
platemo('algorithm', {@LLM_SA_IMODE, 4, 5}, 'problem', @F1)
```

## Output

When running batch experiments, the following MAT files are generated for each dimension:

- `*_sign_res.mat`: Raw results for statistical significance testing
- `*_med_res.mat`: Median and IQR (Interquartile Range) values
- `*_avg_res.mat`: Mean and standard deviation values
- `*_avg_time.mat`: Average runtime and standard deviation

Each file contains a matrix where:
- Rows represent different test problems
- Columns represent algorithm results (2 columns per algorithm: metric and spread measure)

## Algorithm Details

### Main Components

1. **Population Initialization**: Random population generation within problem bounds
2. **Adaptive Population Sizing**: Linear reduction of population size during evolution
3. **Archive Management**: Maintains successful solutions for guiding future generations
4. **Multi-Operator Mutation**: Five different DE mutation strategies:
   - OP1: `current-to-pbest/1/bin`
   - OP2: `current-to-pbest/1/bin (variant)`
   - OP3: `rand/2/bin`
   - OP4: `current-to-pbest/1/bin (with eigenvectors)`
   - OP5: `rand/2/bin (with eigenvectors)`
5. **Surrogate Model**: KNN-based classifier to predict offspring quality
6. **Parameter Adaptation**: Self-adaptive control parameters (CR and F)

### References

The algorithm is based on the following work:

**IMODE Algorithm**:
- K. M. Sallam, S. M. Elsayed, R. K. Chakrabortty, and M. J. Ryan, "Improved multi-operator differential evolution algorithm for solving unconstrained problems," Proceedings of the IEEE Congress on Evolutionary Computation, 2020.

**PlatEMO Platform**:
- Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, "PlatEMO: A MATLAB platform for evolutionary multi-objective optimization [educational forum]," IEEE Computational Intelligence Magazine, 2017, 12(4): 73-87.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This project uses the PlatEMO platform. Please see the copyright notices in individual files for licensing information. When using this code, please acknowledge both PlatEMO and cite the relevant papers mentioned in the References section.

## Contact

For questions or issues, please open an issue on GitHub or contact the repository maintainers.

## Acknowledgments

This implementation builds upon the PlatEMO platform developed by BIMK Group. We gratefully acknowledge their contribution to the evolutionary computation community.
