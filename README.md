# Tree Structure Generator

Generate directory and file structures from a tree-like format provided in a text file.

## Table of Contents

- [Tree Structure Generator](#tree-structure-generator)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Example Tree File Format](#example-tree-file-format)
  - [Limitations](#limitations)
  - [Contributing](#contributing)
  - [License](#license)

## Installation

1. Clone this repository:

```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/tree-structure-generator.git
cd tree-structure-generator
```

2. Ensure the `tree_generator.sh` script is executable:

```bash
chmod +x bin/tree_generator.sh
```

## Usage

Run the script with:

```bash
bash ./bin/tree_generator.sh <path-to-tree-file>
```

Where `<path-to-tree-file>` is the path to your text file containing the tree structure.

## Example Tree File Format

The script accepts tree structures in the following format:

```
project_folder/
|-- subfolder/
|   |-- file1.ext
|   |-- file2.ext
|-- .hiddenfile
|-- README.md
|-- LICENSE
```

## Limitations

- Assumes a specific tree file format as shown above.
- Might not handle filenames with leading or trailing spaces properly.
- Overwrites existing directories but not existing files.

## Contributing

Contributions are welcome! Please fork this repository and open a pull request with your changes, or open an issue to discuss potential changes/improvements.

## License

This project is licensed under the [MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details.
